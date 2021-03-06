package gaia.alertas

import gaia.seguridad.Persona
import gaia.seguridad.Sistema

class UsuarioAlerta {


    Persona persona
    Sistema sistema
    String estado = "A"/*A--> activado D--> desactivado*/
/**
 * Define los campos que se van a ignorar al momento de hacer logs
 */
    static auditable = [ignore: []]

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'usal'
        cache usage: 'read-write', include: 'non-lazy'
        version false
        columns {
            id column: 'usal__id'
            persona column: 'prsn__id'
            estado column: 'usaletdo'
            sistema column: 'stma__id'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
       estado(size: 1..1)
        sistema(nullable: true,blank:true)
    }
}
