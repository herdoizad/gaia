<%@ page import="gaia.documentos.TipoDocumento" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Estación ${estacion.nombre}</title>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">

    <imp:js src="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/js', file: 'bootstrap-select.js')}"/>
    <imp:css src="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/css', file: 'bootstrap-select.min.css')}"/>

    <style>
    .td-semaforo {
        text-align : center;
        width      : 110px;
    }

    .circle-card {
        width        : 40px;
        height       : 40px;
        margin-right : 30px;
    }

    .circle-btn {
        cursor : pointer;
    }

    .btn-header {

        margin-top : -30px;

    }

    .dibujo {
        width         : 100px;
        height        : 100px;
        border-radius : 5px;
        line-height   : 80px;
        display       : inline-block;
        margin        : 0;
        padding       : 10px;
    }

    .cardContent {
        width       : 57%;
        display     : inline-block;
        margin      : 0;
        height      : 100px;
        line-height : 80px;
        padding     : 10px;
        font-weight : bold;
        font-size   : 20px;
        text-align  : center;
    }
    </style>
</head>

<body>
<div class="btn-toolbar toolbar" style="margin-top: 10px;margin-bottom: 0;margin-left: -20px">
    <div class="btn-group">
        <g:link controller="legal" action="listaSemaforos" class="btn btn-default">
            <i class="fa fa-list"></i> Estaciones
        </g:link>
        <a href="#" class="btn btn-default detalles">
            <i class="fa fa-file-o"></i> Ver detalles
        </a>
        <a href="#" class="btn btn-default supervisor">
            <i class="fa fa-user-plus"></i> Supervisor
        </a>
        <a href="#" class="btn btn-default equipo">
            <i class="fa flaticon-fuel2"></i> Equipo
        </a>
    </div>
</div>
<elm:container tipo="horizontal" titulo="Estación: ${estacion.nombre} - ${estacion.mail} - ${dash.porcentajeComercializacion}%">
    <g:set var="contrato" value="${dash.getColorSemaforoContrato(check)}"/>

    <div class="row" style="margin-top: 0">
        <div class="header-panel">
            <div class="header-item" style="width:430px">
                <div class="header-content" style="position: relative;font-size: 14px">
                    <table></table>
                    <i class="fa fa-info-circle" style="color:#FFA324" ></i> <b>Email:</b> ${cliente.email}<br/>
                    <i class="fa fa-info-circle" style="color:#FFA324 "></i> <b>Telefono: </b>${cliente.telefono} <br/>
                    <i class="fa fa-info-circle" style="color:#FFA324 "></i> <b>Días crédito: </b> ${cliente.plazo?.toInteger()} <b style="margin-left: 45px">% comercialización:  </b>${dash.porcentajeComercializacion}%<br/>
                </div>
            </div>
            <div class="header-item">
                <div class="titulo-card" style="text-align: left;padding-left: 15px">
                    <i class="fa fa-newspaper-o"></i> Último Contrato
                </div>
                <div class="header-content" style="position: relative">
                    <div class="circle-card ${contrato[0]}"  ></div>
                    <div style="position: absolute;right: 40px;bottom: 20px">${dash.ultimoContrato?dash.ultimoContrato?.format("dd-MM-yyyy"):'N.A.'}</div>
                </div>
            </div>
            <div class="header-item" style="background: transparent">
                <div class="titulo-card" style="text-align: left;padding-left: 15px">
                    &nbsp;
                </div>
                <div class="header-content" style="position: relative;background: transparent">
                    &nbsp;
                </div>
            </div>
            <div class="header-item" style="background: transparent">
                <div class="titulo-card" style="text-align: left;padding-left: 15px">
                    &nbsp;
                </div>
                <div class="header-content" style="position: relative;background: transparent">
                    &nbsp;
                </div>
            </div>

        </div>
    </div>
    <div class="row" style="height: 400px;overflow-y: auto;width: 97.6%">
        <div role="tabpanel">
            <!-- Nav tabs -->
            <ul class="nav nav-tabs" role="tablist">
                <li role="presentation" class="active bg-info"><a href="#contratos" aria-controls="home" role="tab" data-toggle="tab"><i class="fa fa-newspaper-o"></i> Contratos</a></li>

            </ul>
            <!-- Tab panes -->
            <div class="tab-content">
                <div role="tabpanel" class="tab-pane active" id="contratos" style="padding-top: 20px;overflow-y: auto;height: 350px">
                    <table class="table table-striped table-hover table-bordered" style="font-size: 11px">
                        <thead>
                        <tr>
                            <th>Tipo</th>
                            <th>Registro</th>
                            <th>Vence</th>
                            <th>Duración</th>
                        </tr>
                        </thead>
                        <tbody>
                        <g:each in="${contratos}" var="contrato">
                            <tr class="tr-info ${contrato.tipo.id}">
                                <td >${contrato.tipo.descripcion}</td>
                                <td style="text-align: center">${contrato.inicio?.format("dd-MM-yyyy")}</td>
                                <td style="text-align: center">${contrato.fin?.format("dd-MM-yyyy")}</td>
                                <td style="text-align: center;width: 80px">${contrato.anios}</td>
                            </tr>
                        </g:each>
                        <tr>
                            <td>${inicial["tipo"]}</td>
                            <td style="text-align: center">${inicial["inicio"]?.format("dd-MM-yyyy")}</td>
                            <td style="text-align: center">${inicial["fin"]?.format("dd-MM-yyyy")}</td>
                            <td></td>
                        </tr>
                        </tbody>
                    </table>
                </div>

            </div>

        </div>

    </div>
</elm:container>
<script type="text/javascript">
    function verConsultores(id) {
        openLoader()
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'estacion', action:'consultores_ajax')}",
            data    : {
                codigo : id
            },
            success : function (msg) {
                closeLoader()
                bootbox.dialog({
                    title   : "Consultores",
                    message : msg,
                    class   : "modal-lg",
                    buttons : {
                        ok : {
                            label     : "Aceptar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    }
                });
            }
        });
    }
    function verInspectores(id) {
        openLoader()
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'estacion', action:'inspectores_ajax')}",
            data    : {
                codigo : id
            },
            success : function (msg) {
                closeLoader()
                bootbox.dialog({
                    title   : "Supervisores",
                    message : msg,
                    class   : "modal-lg",
                    buttons : {
                        ok : {
                            label     : "Aceptar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    }
                });
            }
        });
    }
    function verEstacion(id) {
        openLoader()
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'contratos', action:'show_ajax')}",
            data    : {
                id : id
            },
            success : function (msg) {
                closeLoader()
                bootbox.dialog({
                    title   : "Datos de la estación",
                    class   : 'modal-lg',
                    message : msg,
                    buttons : {
                        ok : {
                            label     : "Aceptar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    }
                });
            }
        });
    }
    function verEquipo() {
        openLoader()
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller:'estacion', action:'showEquipos',id:estacion.codigo)}",
            data    : "",
            success : function (msg) {
                closeLoader()
                bootbox.dialog({
                    title   : "Equipos",
                    class : "modal-lg",
                    message : msg,
                    buttons : {
                        ok : {
                            label     : "Aceptar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    }
                });
            }
        });
    }
    function buscar() {
        openLoader();
        var td = $("#tipos").val();
        var search = $.trim($("#txt-buscar").val());
        var prms = "";
        if (td != "") {
            prms += "td=" + td;
        }
        if (search != "") {
            if (prms != "") {
                prms += "&";
            }
            prms += "search=" + search;
        }
        if (prms != "") {
            prms = "?" + prms;
        }
        location.href = "${createLink(controller: 'estacion', action:'showEstacion')}/${estacion.codigo}" + prms;
    }
    $(function () {
        $("#tipos").selectpicker().change(function () {
            buscar();
        });
        $("#btnBuscar").click(function () {
            buscar();
            return false;
        });
        $(".detalles").click(function () {
            verEstacion("${estacion.codigo}");
            return false;
        });
        $(".consultores").click(function () {
            verConsultores("${estacion.codigo}");
            return false;
        });
        $(".supervisor").click(function () {
            verInspectores("${estacion.codigo}");
            return false;
        });
        $(".equipo").click(function () {
            verEquipo("${estacion.codigo}");
            return false;
        });

        $(".ver-pintura").click(function(){
            $.ajax({
                type    : "POST",
                url     : "${createLink(controller:'contratos', action:'verPintura')}",
                data    : {
                    secuencial:$(this).attr("iden"),
                    cliente:$(this).attr("cliente")
                },
                success : function (msg) {
                    closeLoader()
                    bootbox.dialog({
                        title   : "Detalle de trabajo de pintura",
                        class : "modal-lg",
                        message : msg,
                        buttons : {
                            ok : {
                                label     : "Aceptar",
                                className : "btn-primary",
                                callback  : function () {
                                }
                            }
                        }
                    });
                }
            });
            return false
        })
        $(".fa-info-circle").attr("title","Importante")
        $(".ver-uniforme").click(function(){
            $.ajax({
                type    : "POST",
                url     : "${createLink(controller:'contratos', action:'verUniforme')}",
                data    : {
                    dotacion:$(this).attr("iden")
                },
                success : function (msg) {
                    closeLoader()
                    bootbox.dialog({
                        title   : "Detalles de la dotación",
                        class : "modal-lg",
                        message : msg,
                        buttons : {
                            ok : {
                                label     : "Aceptar",
                                className : "btn-primary",
                                callback  : function () {
                                }
                            }
                        }
                    });
                }
            });
        })
        return false




    });
</script>
</body>
</html>