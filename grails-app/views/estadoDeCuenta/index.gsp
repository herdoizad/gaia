<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Enviar estado de cuenta</title>
    <link href="${g.resource(dir: 'css/custom/', file: 'pdfViewer.css')}" rel="stylesheet" type="text/css">
    <imp:js src="${resource(dir: 'js/plugins/pdfObject', file: 'pdfobject.min.js')}"/>
    <style>
    .filaFecha{
        background: #82A640;
        color: #ffffff;
    }
    </style>
</head>
<body>
<div class="pdf-viewer">
    <div class="pdf-content" >
        <div class="pdf-container" id="doc"></div>
        <div class="pdf-handler" >
            <i class="fa fa-arrow-right"></i>
        </div>
        <div class="pdf-header" id="data">
            N. Referencia: <span id="referencia-pdf" class="data"></span>
            Código: <span id="codigo" class="data"></span>
            Tipo: <span id="tipo" class="data"></span>
        </div>
        <div id="msgNoPDF">
            <p>No tiene configurado el plugin de lectura de PDF en este navegador.</p>

            <p>
                Puede
                <a class="text-info" target="_blank" style="color: white" href="http://get.adobe.com/es/reader/">
                    <u>descargar Adobe Reader aquí</u>
                </a>
            </p>
        </div>
    </div>
</div>
<elm:message tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:message>
<elm:container tipo="horizontal" titulo="Estados de cuenta por supervisor">
    <div class="row">
        <div class="col-md-1">
            <label>
                Supervisor:
            </label>
        </div>
        <div class="col-md-3">
            <g:select name="supervisor" id="supervisor" from="${supervisores}" optionKey="key" optionValue="value" class="form-control input-sm"></g:select>
        </div>
        <div class="col-md-1">
            <label>
                Mes:
            </label>
        </div>
        <div class="col-md-2">
            <g:select name="mes" from="${meses}" optionKey="key" optionValue="value" class="form-control input-sm"></g:select>
        </div>
        <div class="col-md-1">
            <a href="#"  id="ver" class="btn btn-info btn-sm"><i class="fa fa-search"></i> Ver</a>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12" id="lista">

        </div>
    </div>
</elm:container>
<div class="modal fade" id="modal-copia">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">Enviar estados de cuenta</h4>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-2">
                        <label>Copia para:</label>
                    </div>
                    <div class="col-md-10">
                        <input type="text" id="copia" class="form-control input-sm" value="wilmer.naranjo@petroleosyservicios.com,monica.requena@petroleosyservicios.com">
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                <button type="button" id="enviar-dlg" class="btn btn-primary">Enviar</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<script type="text/javascript">
    function showPdf(div){
        $("#msgNoPDF").show();
        $("#doc").html("")
        var pathFile = div.data("file")
        $("#referencia-pdf").html(div.data("ref"))
        $("#codigo").html(div.data("codigo"))
        $("#tipo").html(div.data("tipo"))
        var path = "${resource()}/" + pathFile;
        var myPDF = new PDFObject({
            url           : path,
            pdfOpenParams : {
                navpanes: 1,
                statusbar: 0,
                view: "FitW"
            }
        }).embed("doc");
        $(".pdf-viewer").show("slide",{direction:'right'})
        $("#data").show()
    }
    $("#ver").click(function(){
        openLoader()
        $.ajax({
            type    : "POST",
            url     : '${createLink(action:'estadosPorSupervisor')}',
            data    : {
                supervisor : $("#supervisor").val(),
                mes: $("#mes").val()

            },
            success : function (msg) {
                closeLoader()
                $("#lista").html(msg)
            }
        });
    })
    $("#enviar-dlg").click(function(){
        openLoader()
        $("#modal-copia").modal("hide")
        var data = ""
        $(".chk").each(function(){
            if(this.checked){
                data+=$(this).attr("iden")+";"
            }
        });
        $.ajax({
            type    : "POST",
            url     : '${createLink(action:'enviar')}',
            data    : {
                data:data,
                supervisor : $("#supervisor").val(),
                mes: $("#mes").val(),
                copia:$("#copia").val()

            },
            success : function (msg) {
                closeLoader()
                bootbox.alert("Los correos electronicos serán enviados.")
                closeLoader()
                $("#lista").html(msg)
            }
        });
    })
</script>
</body>
</html>