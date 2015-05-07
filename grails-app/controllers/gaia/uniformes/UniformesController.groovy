package gaia.uniformes

import gaia.Contratos.Cliente
import gaia.Contratos.DashBoardContratos

import gaia.Contratos.esicc.Pedido
import gaia.documentos.Inspector
import gaia.documentos.InspectorEstacion
import gaia.documentos.Responsable
import gaia.estaciones.Estacion
import gaia.parametros.Parametros

class UniformesController {

    static sistema="UNFR"

    def index() {
        redirect(action: "dash")
    }

    def dash(){
        def dash = DashBoardContratos.list([sort: "id"])
        def dias = Parametros.getDiasContrato()
        def check = new Date().plus(dias)
        //println "check "+check.format("dd-MM-yyyy")
        def colores = ["card-bg-green", "svt-bg-warning", "svt-bg-danger"]

        def equipo = 0
        def equipoWarning = 0
        def total = 0
        dash.each { d ->

            switch (d.getColorSemaforoUniforme()[0]){
                case colores[0]:
                    equipo++
                    break;
                case colores[1]:
                    equipoWarning++
                    break;
                case colores[2]:
                    break;
            }

            total++
        }


        [equipo:equipo,equipoWarning:equipoWarning,total: total, colores: colores]
    }
    def listaSemaforos() {
        def estaciones
        def dash
        def dias = Parametros.getDiasContrato()
        def check = new Date().plus(dias)
        if (session.tipo == "cliente") {
            def responsable = Responsable.findByLogin(session.usuario.login)
            def supervisor = Inspector.findByCodigo(responsable.codigoSupervisor)
            estaciones = InspectorEstacion.findAllByInspector(supervisor)
            dash = DashBoardContratos.findAllByEstacionInList(estaciones.estacion, [sort: "id"])
        } else {
            dash = DashBoardContratos.list([sort: "id"])
        }

        [dash: dash, search: params.search, check: check]
    }

    def showEstacion(){
        def estacion
//        if (session.tipo == "cliente") {
//            estacion = session.usuario
//        } else {
        estacion = Estacion.findByCodigoAndAplicacion(params.id, 1)//        }
        def dash = DashBoardContratos.findByEstacion(estacion)
        def uniformes = Pedido.findAllByEstacion(estacion,[sort:"fecha",order: "desc"])

        def cliente = Cliente.findByCodigoAndTipo(params.id,1)

        [estacion: estacion, params: params,dash:dash,uniformes:uniformes,cliente:cliente]

    }

}
