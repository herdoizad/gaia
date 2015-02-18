package gaia.reportes

import gaia.documentos.Documento
import gaia.documentos.Entidad
import gaia.documentos.TipoDocumento
import gaia.estaciones.Estacion
import org.springframework.dao.DataIntegrityViolationException
import gaia.seguridad.Shield



/**
 * Controlador de las pantallas de reportes por estación
 */
class ReportesEstacionController extends Shield{
    def diasLaborablesService
    def index() {}

    def getList(params, all) {
        params = params.clone()
        params.max = params.max ? Math.min(params.max.toInteger(), 100) : 10
        params.offset = params.offset ?: 0
        if (all) {
            params.remove("max")
            params.remove("offset")
        }
        def list
        if (params.search) {
            def c = Estacion.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("codigo", "%" + params.search + "%")
                    ilike("direccion", "%" + params.search + "%")
                    ilike("estado", "%" + params.search + "%")
                    ilike("mail", "%" + params.search + "%")
                    ilike("nombre", "%" + params.search + "%")
                    ilike("propetario", "%" + params.search + "%")
                    ilike("representante", "%" + params.search + "%")
                    ilike("ruc", "%" + params.search + "%")
                    ilike("telefono", "%" + params.search + "%")
                }
            }
        } else {
            list = Estacion.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    def supervisores () {

        def estaciones = Estacion.list()
        def estacionInstanceCount = getList(params, true).size()

        return [estaciones: estaciones, estacionInstanceCount: estacionInstanceCount]
    }

    def vencidos () {

        def estaciones = Estacion.list()
        def estacionInstanceCount = getList(params, true).size()

        return [estaciones: estaciones, estacionInstanceCount: estacionInstanceCount]
    }

    def documentos () {

        def estaciones = Estacion.list()
        def estacionInstanceCount = getList(params, true).size()

        def tiposDocumentos = TipoDocumento.list(sort: "id")

        return [estaciones: estaciones, estacionInstanceCount: estacionInstanceCount, tiposDocumentos: tiposDocumentos]
    }

    def entidad () {

        def mae = Entidad.findByCodigo("MAE");
        def arch = Entidad.findByCodigo("ARCH");

        def tiposDocumentosMae = TipoDocumento.findAllByEntidad(mae);
        def tiposDocumentosArch = TipoDocumento.findAllByEntidad(arch);

        def documentos = Documento.list()
        def otros = []

        tiposDocumentosMae.each {
          otros += Documento.findAllByTipo(it)
        }

        print("-->" + otros)






        return [tiposDocumentosMae: tiposDocumentosMae, tiposDocumentosArch: tiposDocumentosArch ]

    }
}
