package gaia.documentos

class Detalle {
    TipoDocumento tipo
    Proceso proceso
    Documento documento /*nullable blank*/
    int plazo = 0
    Date fechaRegistro = new Date()
    Date fechaMaxima /*nullable blank*/
    Detalle detalle
/**
 * Define el mapeo entre los campos del dominio y las columnas de la base de datos
 */
    static mapping = {
        table: 'dtll'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        id generator: 'identity'
        columns {
            id column: 'dtll__id'
            tipo column: 'tpdc__id'
            proceso column: 'prco__id'
            documento column: 'dcmt__id'
            plazo column: 'dtllplzo'
            fechaRegistro column: 'dtllfcrg'
            fechaMaxima column: 'dtllfcmx'
            detalle column: 'dtllpdre'
        }
    }
    static constraints = {
        fechaMaxima(nullable: true,blank:true)
        detalle(nullable: true,blank:true)
    }
}
