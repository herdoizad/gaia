package gaia.documentos

import gaia.estaciones.Estacion

class Dashboard {

    Estacion estacion
    Integer licencia = 0
    Integer auditoria = 0
    Integer docs = 0
    Integer monitoreo = 0

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'dash'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        columns {
            id column: 'dash__id'
            estacion column: 'stcn__id'
            licencia column: 'dashlicn'
            auditoria column: 'dashaudt'
            docs column: 'dashdocs'
            monitoreo column: 'dashmnto'
        }
    }
}
