package gaia.seguridad

import gaia.alertas.Alerta
import gaia.documentos.Responsable
import gaia.estaciones.Estacion

class LoginController {

    def index() {
        redirect(action: 'login')
    }

    def validarSesion() {
        println "sesion creada el:" + new Date(session.getCreationTime()) + " hora actual: " + new Date()
        println "último acceso:" + new Date(session.getLastAccessedTime()) + " hora actual: " + new Date()

        println session.usuario
        if (session.usuario) {
            render "OK"
        } else {
            flash.message = "Su sesión ha caducado, por favor ingrese nuevamente."
            render "NO"
        }
    }

    def login() {
        def usu = session.usuario
        def cn = "inicio"
        def an = "index"
        if (usu) {
            if (session.cn && session.an) {
                cn = session.cn
                an = session.an
            }
            redirect(controller: cn, action: an)
        }
    }

    def validar() {
        if (!params.user || !params.pass) {
            redirect(controller: "login", action: "login")
            return
        }
        def user = Persona.withCriteria {
            ilike("login", params.user)
            eq("activo", 1)
        }
        if (user.size() == 0) {
            flash.message = "No se ha encontrado el usuario"
            flash.tipo = "error"
            redirect(controller: 'login', action: "login")
            return
        } else if (user.size() > 1) {
            flash.message = "Ha ocurrido un error grave"
            flash.tipo = "error"
            redirect(controller: 'login', action: "login")
            return
        } else {
            user = user.first()
            def perfiles = Sesion.findAllByUsuario(user)
            if (perfiles.size() == 0) {
                flash.message = "No puede ingresar porque no tiene ningún perfil asignado a su usuario. Comuníquese con el administrador."
                flash.tipo = "error"
                flash.icon = "icon-warning"
                session.usuario = null
                session.departamento = null
                redirect(controller: 'login', action: "login")
                return
            } else {
                if (params.pass.encodeAsMD5() != user.password) {
                    flash.message = "Contraseña incorrecta"
                    flash.tipo = "error"
                    flash.icon = "icon-warning"
                    session.usuario = null
                    session.departamento = null
                    redirect(controller: 'login', action: "login")
                    return
                }
            }
            session.usuario = user
            session.usuarioKerberos = user.login
            if (perfiles.size() == 1) {
                doLogin(perfiles.first().perfil)
            } else {
                redirect(action: "perfiles")
                return
            }
        }
    }

    def doLogin(perfil) {
        session.perfil = perfil
        cargarPermisos()
        def count = Alerta.countByPersonaAndFechaRecibidoIsNull(session.usuario)
        if (count > 0) {
            redirect(controller: 'alerta', action: 'list')
            return
        } else {
            if (session.an && session.cn) {
                redirect(controller: session.cn, action: session.an, params: session.pr)
            } else {
                redirect(controller: "inicio", action: "index")
            }
            return
        }
    }

    def perfiles() {
        def usuarioLog = session.usuario
//        def perfilesUsr = Sesn.findAllByUsuario(usuarioLog, [sort: 'perfil'])
//        def perfiles = []
//        perfilesUsr.each { p ->
//            perfiles.add(p)
//        }

        def perfiles = Sesion.withCriteria {
            eq("usuario", usuarioLog)
            perfil {
                order("nombre", "asc")
            }
        }.perfil

        return [perfiles: perfiles]
    }

    def savePerfil() {
        if (!params.perfil) {
            redirect(controller: "inicio", action: "perfiles")
        }
        def perfil = Perfil.get(params.perfil)
        doLogin(perfil)
    }

    def savePer() {
        def sesn = Sesion.get(params.prfl)
        def perf = sesn.perfil

        if (perf) {

            def permisos = Prpf.findAllByPerfil(perf)
//            println "perfil "+perf.descripcion+"  "+perf.codigo
            permisos.each {
//                println "perm "+it.permiso+"  "+it.permiso.codigo
                def perm = PermisoUsuario.findAllByPersonaAndPermisoTramite(session.usuario, it.permiso)
                perm.each { pr ->
//                    println "fechas "+pr.fechaInicio+"  "+pr.fechaFin+" "+pr.id+" "+pr.estaActivo
                    if (pr.estaActivo) {

                        session.usuario.permisos.add(pr.permisoTramite)
                    }
                }

            }
//            println "permisos " + session.usuario.permisos.id + "  " + session.usuario.permisos
//            println "add " + session.usuario.permisos
//            println "puede recibir " + session.usuario.getPuedeRecibir()
//            println "puede getPuedeVer " + session.usuario.getPuedeVer()
//            println "puede getPuedeAdmin " + session.usuario.getPuedeAdmin()
//            println "puede getPuedeJefe " + session.usuario.getPuedeJefe()
//            println "puede getPuedeDirector " + session.usuario.getPuedeDirector()
//            println "puede getPuedeExternos " + session.usuario.getPuedeExternos()
//            println "puede getPuedeAnular " + session.usuario.getPuedeAnular()
//            println "puede getPuedeTramitar " + session.usuario.getPuedeTramitar()
            session.perfil = perf
            cargarPermisos()
//            if (session.an && session.cn) {
//                if (session.an.toString().contains("ajax")) {
//                    redirect(controller: "inicio", action: "index")
//                } else {
//                    redirect(controller: session.cn, action: session.an, params: session.pr)
//                }
//            } else {
            def count = 0

            count = Alerta.countByPersonaAndFechaRecibidoIsNull(session.usuario)


            if (count > 0)
                redirect(controller: 'alerta', action: 'list')
            else {//
//                redirect(controller: "retrasadosWeb", action: "reporteRetrasadosConsolidado", params: [dpto: Persona.get(session.usuario.id).departamento.id,inicio:"1"])

                redirect(controller: "inicio", action: "index")


            }

//            }
        } else {
            redirect(action: "login")
        }
    }

    def logout() {
        session.usuario = null
        session.perfil = null
        session.permisos = null
        session.menu = null
        session.an = null
        session.cn = null
        session.invalidate()
        redirect(url: "http://www.petroleosyservicios.com/esicc/bienvenida.php")
    }

    def finDeSesion() {

    }

    def cargarPermisos() {
        def permisos = Permiso.findAllByPerfil(session.perfil)
        def hp = [:]
        permisos.each {
            if (hp[it.accion.control.nombre.toLowerCase()]) {
                hp[it.accion.control.nombre.toLowerCase()].add(it.accion.nombre.toLowerCase())
            } else {
                hp.put(it.accion.control.nombre.toLowerCase(), [it.accion.nombre.toLowerCase()])
            }
        }
        session.sistemas = permisos.accion.sistema.unique().sort { it?.id }

        session.permisos = hp
    }

    def remoteLogin(){
//        println "params "+params
        if(!params.token)
            response.sendError(403)
        def data = params.token.split("\\|")
        def usuario = null
        def perfil = null
        def perfilSupervisor = Perfil.findByCodigo("2")
        def token = new Date().format("ddMMyyyy").encodeAsMD5()
        if(data.size()!=4)
            response.sendError(403)
        usuario = Persona.findByLoginAndPassword(data[0].trim(),data[3].trim())
        //println "usuario "+usuario.login
        if(!usuario)
            response.sendError(403)
        Perfil.list().each {
            if(it.codigo.encodeAsMD5()==data[1].trim()) {
                perfil = it
                return
            }
        }
        if(!perfil)
            response.sendError(403)
        if(token==data[2]){
            session.usuario = usuario
            session.perfil = perfil
            session.usuarioKerberos = usuario.login
            session.tipo="usuario"
//            if(perfil==perfilSupervisor)
//                session.tipo="cliente"

            def resposable = Responsable.findByLogin(usuario.login)

            if(resposable){
                if(resposable.codigoSupervisor!="" && resposable.codigoSupervisor!=null)
                    session.tipo="cliente"
            }
            println "tipo "+session.tipo
            cargarPermisos()
            println "sistemas "+session.sistemas
            redirect(controller: "inicio",action: "index")
        }




    }

}
