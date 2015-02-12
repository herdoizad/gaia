package gaia.procesos

import gaia.documentos.Dependencia
import gaia.documentos.Detalle
import gaia.documentos.Documento
import gaia.documentos.Observacion
import gaia.documentos.Proceso
import gaia.documentos.TipoDocumento
import gaia.estaciones.Estacion

class LicenciaController {

    def registrarLicencia(){
        def estacion = Estacion.findByCodigo(params.id)
        def lic = estacion.getColorLicencia()
        def warning = false
        def proceso = null
        def tipoLicencia = TipoDocumento.findByCodigo('TP01')
        def detalle = null
        if(lic[1]){
            warning = true
        }else{
            proceso = Proceso.findAll("from Proceso where estacion='${estacion.codigo}' and tipo=${tipoLicencia.id} and completado='N'")
            // println " proceso "+proceso
            if( proceso.size()==0){
                proceso = new Proceso()
                proceso.completado="N"
                proceso.estacion=estacion
                proceso.tipo = tipoLicencia
                proceso.inicio=new Date()
                if(!proceso.save(flush: true)){
                    println "error save proceso "+proceso.errors
                }
            }else{
                proceso=proceso.pop()
                detalle = Detalle.findByProcesoAndPaso(proceso,1)
                //println "detalle "+detalle
            }

        }
        [estacion:estacion,warning:warning,proceso:proceso,detalle:detalle]
    }

    def caducarLic(){

    }

    def saveCertificado(){
        println "upload "+params

        def estacion = Estacion.findByCodigo(params.estacion_codigo)
        def detalle
        def proceso = Proceso.get(params.proceso)
        if(!proceso)
            response.sendError(403)
        def tipoCert = TipoDocumento.findByCodigo("TP03")
        def pathPart = "documentos/${estacion.codigo}/"
        if(params.id)
            detalle=Detalle.get(params.id)
        else{
            detalle = new Detalle()
            detalle.proceso=proceso
            detalle.tipo = tipoCert
            detalle.dependencia=Dependencia.get(params.dependencia)
            detalle.fechaRegistro=new Date()
            detalle.paso=1
            detalle.plazo = 0
            if(!detalle.save(flush: true)){
                println "error save detalle "+detalle.errors
            }
        }

        def path = servletContext.getRealPath("/") + pathPart
        def numero = Documento.list([sort: "id",order: "desc",max: 1])
        if(numero.size()==1)
            numero=numero.pop().id+1
        else
            numero=1
        def codigo = "PS-DA-"+numero

        new File(path).mkdirs()
        def f = request.getFile('file')  //archivo = name del input type file
        def okContents = [
                'application/pdf'                                                          : 'pdf',
                'application/download'                                                     : 'pdf'
        ]
        if (f && !f.empty) {
            def ext
            if (okContents.containsKey(f.getContentType())) {
                ext = okContents[f.getContentType()]
                def nombre = codigo + "." + ext
                def pathFile = path + nombre
                try {
                    f.transferTo(new File(pathFile)) // guarda el archivo subido al nuevo path
                } catch (e) {
                    flash.message = "Ha ocurrido un error al guardar"
                }

                def documento
                if(detalle.documento)
                    documento=detalle.documento
                else
                    documento = new Documento(params)
                //println "path "+pathFile
                //println "codigo "+codigo
                documento.path= pathPart + nombre
                documento.fechaRegistro=new Date()
                documento.estacion=estacion
                documento.codigo = codigo
                documento.tipo = tipoCert
                if (documento.save()) {
                    detalle.dependencia = Dependencia.get(params.dependencia)
                    if(!detalle.documento)
                        detalle.documento=documento
                    detalle.save(flush: true)
                    flash.message="Datos guardados, por favor continue con el siguiente paso"
                    redirect(action: 'licenciaTdr',controller: 'licencia',id: proceso.id)
                    return
                } else {
                    println "errores "+documento.errors
                    flash.message = "Ha ocurrido un error al guardar: " + renderErrors(bean: documento)
                    redirect(action: 'registrarLicencia',controller: 'licencia',id: estacion.codigo)
                    return
                }

            } //ok contents
            else {
                println "llego else no se acepta"
                flash.message= "Extensión no permitida"
                redirect(action: 'registrarLicencia',controller: 'licencia',id: estacion.codigo)
                return

            }
        }else{

            params.remove("id")
            detalle.documento.properties =params
            detalle.dependencia = Dependencia.get(params.dependencia)
            detalle.documento.save()
            detalle.save(flush: true)
            flash.message="Datos guardados, por favor continue con el siguiente paso"
            redirect(action: 'licenciaTdr',controller: 'licencia',id: proceso.id)
            return
        } //f && !f.empty
    }

    def upload(){
        /*todo probar con el alcance... ultimo era el 5... creo el 6??? revisar*/
        println "upload "+params
        def estacion = Estacion.findByCodigo(params.estacion_codigo)
        def detalle
        def proceso = Proceso.get(params.proceso)
        if(!proceso)
            response.sendError(403)
        def tipoDoc
        def paso = params.paso.toInteger()
        def plazo = 0
        def redirectStr =""
        def padre=null
        def now = new Date().parse("dd-MM-yyyy",params.inicio_input)
        switch (params.tipo){
            case "tdr":
                tipoDoc = TipoDocumento.findByCodigo("TP04")
                redirectStr = "licenciaTdr"
                break;
            case "obs":
                tipoDoc = TipoDocumento.findByCodigo("TP07")
                params.descripcion = "Oficio de observaciones"
                if(params.padre)
                    padre = Detalle.get(params.padre)
                redirectStr = params.origen
                if(params.plazo)
                    plazo=params.plazo.toInteger()
                else
                    plazo=30
                break;
            case "alc":
                tipoDoc = TipoDocumento.findByCodigo("TP05")
                padre = Detalle.get(params.padre)
                params.descripcion = "Alcance a las observaciones"
                redirectStr = params.origen
                break;
            case "apbTdr":
                tipoDoc = TipoDocumento.findByCodigo("TP06")
                redirectStr = "licenciaEia"
                break;
            case "apbEia":
                tipoDoc = TipoDocumento.findByCodigo("TP06")
                redirectStr = "licenciaPago"
                break;
            case "eia":
                tipoDoc = TipoDocumento.findByCodigo("")
                redirectStr = "licenciaEia"
                break;
        }
        def pathPart = "documentos/${estacion.codigo}/"
        println "detalle? "+detalle
        if(params.id)
            detalle=Detalle.get(params.id)
        else{
            detalle = new Detalle()
            detalle.proceso=proceso
            detalle.tipo = tipoDoc
            detalle.fechaRegistro=new Date()
            println "padre "+padre
            detalle.detalle=padre
            detalle.paso = paso
            detalle.plazo = plazo
            if(!detalle.save(flush: true)){
                println "error save detalle "+detalle.errors
            }
        }

        def path = servletContext.getRealPath("/") + pathPart
        def numero = Documento.list([sort: "id",order: "desc",max: 1])
        if(numero.size()==1)
            numero=numero.pop().id+1
        else
            numero=1
        def codigo = "PS-DA-"+numero
        new File(path).mkdirs()
        def f = request.getFile('file')  //archivo = name del input type file
        def okContents = [
                'application/pdf'                                                          : 'pdf',
                'application/download'                                                     : 'pdf'
        ]
        if (f && !f.empty) {
            def ext
            if (okContents.containsKey(f.getContentType())) {
                ext = okContents[f.getContentType()]
                def nombre = codigo + "." + ext
                def pathFile = path + nombre
                try {
                    f.transferTo(new File(pathFile)) // guarda el archivo subido al nuevo path
                } catch (e) {
                    flash.message = "Ha ocurrido un error al guardar"
                }
                params.remove("tipo")
                def documento
                if(detalle.documento)
                    documento=detalle.documento
                else
                    documento = new Documento(params)
                //println "path "+pathFile
                //println "codigo "+codigo
                documento.path= pathPart + nombre
                documento.fechaRegistro=new Date()
                documento.estacion=estacion
                documento.codigo = codigo
                documento.tipo = tipoDoc
                documento.inicio=now
                if(plazo>0){
                    /*todo Generar alerta*/
                    documento.fin =now.plus(plazo)
                    //println "plazo >0 "+documento?.inicio?.format("dd-MM-yyyy")+"  "+documento?.fin?.format("dd-MM-yyyy")
                }
                if (documento.save()) {
                    if(!detalle.documento)
                        detalle.documento=documento
                    detalle.save(flush: true)
                    flash.message="Datos guardados, por favor continue con el siguiente paso"
                    redirect(action: ""+redirectStr,controller: 'licencia',id: proceso.id)
                    return
                } else {
                    println "errores "+documento.errors
                    flash.message = "Ha ocurrido un error al guardar: " + renderErrors(bean: documento)
                    redirect(action: ""+redirectStr,controller: 'licencia',id: proceso.id)
                    return
                }

            } //ok contents
            else {
                println "llego else no se acepta"
                flash.message= "Extensión no permitida"
                redirect(action: ""+redirectStr,controller: 'licencia',id: proceso.id)
                return

            }
        }else{
            println "no file"
            params.remove("id")
            params.remove("tipo")
            detalle.documento.properties =params
            if(params.plazo){
                /*todo Generar alerta*/
                plazo = params.plazo.toInteger()
                detalle.plazo=plazo
                detalle.documento.fin =now.plus(plazo)
                //println "plazo >0 "+documento?.inicio?.format("dd-MM-yyyy")+"  "+documento?.fin?.format("dd-MM-yyyy")
            }
            detalle.dependencia = Dependencia.get(params.dependencia)
            detalle.documento.save()
            detalle.save(flush: true)
            flash.message="Datos guardados, por favor continue con el siguiente paso"
            redirect(action: redirectStr,controller: 'licencia',id: proceso.id)
            return
        } //f && !f.empty
    }

    def licenciaTdr(){
        if(!params.id)
            response.sendError(403)
        def proceso = Proceso.get(params.id)
        if(!proceso)
            response.sendError(403)
        def estacion = proceso.estacion
        def detalleTdr = Detalle.findByProcesoAndTipo(proceso,TipoDocumento.findByCodigo("TP04"))
        def detalleObs = Detalle.findByProcesoAndTipo(proceso,TipoDocumento.findByCodigo("TP07"))
        def detalleAprobacion = Detalle.findByProcesoAndTipo(proceso,TipoDocumento.findByCodigo("TP06"))
        [proceso:proceso,estacion: estacion,detalleTdr:detalleTdr,detalleApb:detalleAprobacion,detalleObs:detalleObs]
    }


}