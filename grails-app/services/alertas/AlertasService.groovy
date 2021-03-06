package alertas

import gaia.alertas.Alerta
import gaia.alertas.UsuarioAlerta
import gaia.documentos.Documento
import grails.transaction.Transactional

@Transactional
class AlertasService {


    def generarAlertaDocumentoVencido(Documento doc){
        def now = new Date()


        if(!doc.fin){
            return false
        }else{
            if(doc.fin>now){
                if((doc.fin-now)<15 ){
                    UsuarioAlerta.findAllByEstado("A").each {
                        def alerta = new Alerta()
                        alerta.documento = doc
                        alerta.estacion = doc.estacion
                        alerta.fechaEnvio=new Date()
                        alerta.mensaje = "El documento: ${doc.referencia} de la estación ${doc.estacion} está por caducar (${doc.fin?.format('dd-MM-yyyy')})."
                        alerta.accion = "ver"
                        alerta.controlador="documento"
                        alerta.persona = it.persona
                        alerta.id_remoto=doc.id
                        if(!alerta.save(flush: true)){
                            println "error save alerta "+alerta.errors
                        }
                    }

                    return true
                }
            }else{
                return false
            }
        }


    }


}
