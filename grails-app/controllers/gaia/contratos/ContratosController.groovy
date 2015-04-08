package gaia.contratos

import gaia.Contratos.Adendum
import gaia.Contratos.DashBoardContratos
import gaia.documentos.Inspector
import gaia.documentos.InspectorEstacion
import gaia.documentos.Responsable
import gaia.estaciones.Estacion
import gaia.parametros.Parametros
import groovy.sql.Sql


class ContratosController {
    static final sistema="CNTR"
    def dataSource_erp

    def index(){
        if(session.tipo=="cliente"){
            redirect(action: 'listaSemaforos')
        }else{
            redirect(controller: 'dashBoardContratos',action: 'dash')
        }
    }

    def listaSemaforos(){
        def estaciones
        def dash
        def dias = Parametros.getDiasContrato()
        def check = new Date().plus(dias)
        if(session.tipo=="cliente"){
            def responsable = Responsable.findByLogin(session.usuario.login)
            def supervisor = Inspector.findByCodigo(responsable.codigoSupervisor)
            estaciones=InspectorEstacion.findAllByInspector(supervisor)
            dash = DashBoardContratos.findAllByEstacionInList(estaciones.estacion,[sort: "id"])
        }else{
            dash = DashBoardContratos.list([sort: "id"])
        }

        [dash: dash, search: params.search,check:check]
    }

    def showEstacion(){
        def estacion
//        if (session.tipo == "cliente") {
//            estacion = session.usuario
//        } else {
        estacion = Estacion.findByCodigoAndAplicacion(params.id, 1)
//        }
        def dash = DashBoardContratos.findByEstacion(estacion)

        def contratos= Adendum.findAllByCliente(estacion.codigo,[sort:"fin",order:"desc"])
        def inicial = [:]
        def sql =  new Sql(dataSource_erp)
        def dias = Parametros.getDiasContrato()
        def check = new Date().plus(dias)
        sql.eachRow("select * from CLIENTE where TIPO_CLIENTE=1 and ESTADO_CLIENTE='A' and CODIGO_CLIENTE='${estacion.codigo}'".toString()) { r ->
            //if(r["FECHA_TERMINA_CONTRATO"]!=null){
            inicial["tipo"]="INICIAL"
            inicial["inicio"]=r["FECHA_PRIMER_CONTRATO"]
            inicial["fin"]=r["FECHA_TERMINA_CONTRATO"]
            //}
        }
        [estacion: estacion, contratos: contratos, params: params,dash:dash,inicial:inicial,check:check]
    }
}
