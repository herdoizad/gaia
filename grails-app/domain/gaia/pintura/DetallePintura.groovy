package gaia.pintura

import gaia.Contratos.Cliente

class DetallePintura  implements Serializable{

    Cliente cliente
    Contratista contratista
    String numeroFactura
    String atencionA
    String observaciones
    Date fin

    static auditable = false
    static mapping = {
        datasource 'erp'
        table 'DETALLE_PINTURA_N'
        cache usage: 'read-write', include: 'non-lazy'
        id column:'ID',sqlType: "int"
        id generator: "increment"
        version false
        columns {
            cliente column: 'CODIGO_CLIENTE'
            contratista column: 'CODIGO_CONTRATISTA'
            numeroFactura column: 'NUMERO_FACTURA'
            fin column: 'FECHA_FIN_TRABAJO'
            observaciones column: 'OBSERVACIONES_PINTURA'
            atencionA column: 'ATENCION_A'
        }
    }
    static constraints = {
        cliente(size:1..8,nullable: false,blank:false)
        numeroFactura(size: 1..50)
        atencionA(size: 1..30,nullable: true,blank: true)
        observaciones(nullable: true,blank: true,size: 1..255)
    }

    String toString(){
        return "${this.cliente} - Fin de trabajo: ${fin.format('dd-MM-yyyy')}"
    }

    def getRotulacion(){
        def total = 0
        def detalles = SubDetallePintura.findAllByDetallePintura(this)
        detalles.each {
            if(it.item.tipoItem=="R")
                total+=it.total
        }
        return total.toDouble().round(2)
    }
    def getPintura(){
        def total = 0
        def detalles = SubDetallePintura.findAllByDetallePintura(this)
        detalles.each {
            if(it.item.tipoItem=="P")
                total+=it.total
        }
        return total.toDouble().round(2)
    }

    def getTotal(){
        def total = 0
        def detalles = SubDetallePintura.findAllByDetallePintura(this)
        detalles.each {
                total+=it.total
        }
        return total.toDouble().round(2)
    }

    def getTotalGrupo(ItemImagen grupo){
        def total = 0
        def detalles = SubDetallePintura.findAllByDetallePintura(this)
        detalles.each {
            if(it.item.padre.id==grupo.id)
                total+=it.total
        }
        return total.toDouble().round(2)
    }


}
