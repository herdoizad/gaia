<%--
  Created by IntelliJ IDEA.
  User: DELL
  Date: 23/01/2015
  Time: 17:44
--%>

<%@ page import="gaia.estaciones.Estacion" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE HTML>
<head>
    <meta name="layout" content="main">
    <title>Documentos</title>

    <imp:js src="${resource(dir: 'js/plugins/jstree-3.0.9/dist', file: 'jstree.min.js')}"/>
    <imp:css src="${resource(dir: 'js/plugins/jstree-3.0.9/dist/themes/default', file: 'style.min.css')}"/>
    <imp:css src="${resource(dir: 'css/custom', file: 'jstree-context.css')}"/>

    <imp:js src="${resource(dir: 'js/plugins/pdfObject', file: 'pdfobject.min.js')}"/>

    <imp:js src="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/js', file: 'bootstrap-select.min.js')}"/>
    <imp:css src="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/css', file: 'bootstrap-select.min.css')}"/>

    <style type="text/css">
    #tree {
    }

    .jstree-search {
        color : #5F87B2 !important;
    }

    .treePart {
        overflow-y : auto;
        height     : 440px;
    }
    </style>
</head>

<body>

    %{--<div>Icon made by <a href="http://www.freepik.com" title="Freepik">Freepik</a> from <a href="http://www.flaticon.com" title="Flaticon">www.flaticon.com</a> is licensed under <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0">CC BY 3.0</a></div>--}%

    <div class="row" style="margin-bottom: 10px;">
        <div class="col-md-1">
            <g:link controller="estacion" action="showEstacion" id="${params.codigo}" class="btn btn-default btn-sm">
                Estación
            </g:link>
        </div>

        <g:if test="${params.combo}">
            <div class="col-md-3">
                <g:select name="estacion" from="${Estacion.list([sort: 'nombre'])}" class="form-control select"
                          optionKey="codigo" data-live-search="true" value="${params.codigo}"/>
            </div>
        </g:if>

        <div class="col-md-2">
            <div class="input-group input-group-sm">
                <g:textField name="searchArbol" class="form-control input-sm" placeholder="Buscador"/>
                <span class="input-group-btn">
                    <a href="#" id="btnSearchArbol" class="btn btn-sm btn-info">
                        <i class="fa fa-search"></i>
                    </a>
                </span>
            </div><!-- /input-group -->
        </div>

        <div class="col-md-3 hidden" id="divSearchRes">
            <span id="spanSearchRes">
                5 resultados
            </span>

            <div class="btn-group">
                <a href="#" class="btn btn-xs btn-default" id="btnNextSearch" title="Siguiente">
                    <i class="fa fa-chevron-down"></i>
                </a>
                <a href="#" class="btn btn-xs btn-default" id="btnPrevSearch" title="Anterior">
                    <i class="fa fa-chevron-up"></i>
                </a>
                <a href="#" class="btn btn-xs btn-default" id="btnClearSearch" title="Limpiar búsqueda">
                    <i class="fa fa-close"></i>
                </a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="btn-group">
                <a href="#" class="btn btn-xs btn-default" id="btnCollapseAll" title="Cerrar todos los nodos">
                    <i class="fa fa-minus-square-o"></i>
                </a>
                <a href="#" class="btn btn-xs btn-default" id="btnExpandAll" title="Abrir todos los nodos">
                    <i class="fa fa-plus-square"></i>
                </a>
            </div>
        </div>
    </div>

    <div class="well">
        <div class="row no-margin-top">
            <div class="col-md-5 treePart" id="tree">
                ${raw(arbol)}
            </div>

            <div class="col-md-7 treePart" id="doc" style="overflow: hidden;">
                <div id="msgNoPDF">
                    <p>No tiene configurado el plugin de lectura de PDF en este navegador.</p>

                    <p>
                        Puede
                        <a class="text-info" target="_blank" href="http://get.adobe.com/es/reader/">
                            <u>descargar Adobe Reader aquí</u>
                        </a>
                    </p>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        var searchRes = [];
        var posSearchShow = 0;
        var $treeContainer = $("#tree");

        function createContextMenu(node) {
            var nodeStrId = node.id;
            var $node = $("#" + nodeStrId);
            var nodeId = nodeStrId.split("_")[1];
            var nodeType = $node.data("jstree").type;

            var nodeText = $node.children("a").first().text();

            var cantHijos = parseInt($node.data("hijos"));

//            var esEstacion = nodeType == "estacion";
//            var esTipoDoc = nodeType == "tipoDoc";
            var esDoc = nodeType == "doc";

            var verDetalles = {
                label  : "Ver Detalles",
                icon   : "fa fa-search",
                action : function () {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller:'documento', action:'verDetalles_ajax')}",
                        data    : {
                            id : nodeId
                        },
                        success : function (msg) {
                            var b = bootbox.dialog({
                                id      : "dlgDetallesDoc",
                                title   : "Detalles del documento",
                                message : msg,
                                buttons : {
                                    cerrar : {
                                        label     : "Cerrar",
                                        className : "btn-primary",
                                        callback  : function () {
                                        }
                                    }
                                } //buttons
                            }); //dialog
                        } //success
                    }); //ajax
                }
            };
            var verObservaciones = {
                label  : "Ver observaciones",
                icon   : "fa fa-comments-o",
                action : function () {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller:'observacion', action:'showObservacionesDoc_ajax')}",
                        data    : {
                            id : nodeId
                        },
                        success : function (msg) {
                            var b = bootbox.dialog({
                                id      : "dlgDetallesDoc",
                                title   : "Observaciones del documento",
                                message : msg,
                                buttons : {
                                    cerrar : {
                                        label     : "Cerrar",
                                        className : "btn-primary",
                                        callback  : function () {
                                        }
                                    }
                                } //buttons
                            }); //dialog
                            setTimeout(function () {
                                b.find(".form-control").first().focus()
                            }, 500);
                        } //success
                    }); //ajax

                }
            };
            var download = {
                label            : "Descargar",
                icon             : "fa fa-download",
                separator_before : true,
                action           : function () {
                    location.href = "${createLink(controller: 'documento', action:'download')}/" + nodeId;
                }
            };
            var downloadObs = {
                label  : "Descargar con observaciones",
                icon   : "fa fa-cloud-download",
                action : function () {

                }
            };

            var items = {};

            if (esDoc) {
                items.verDetalles = verDetalles;
                items.verObservaciones = verObservaciones;
                items.download = download;
//                items.downloadObs = downloadObs;
            }

            return items;
        }

        function scrollToNode($scrollTo) {
            $treeContainer.jstree("deselect_all").jstree("select_node", $scrollTo).animate({
                scrollTop : $scrollTo.offset().top - $treeContainer.offset().top + $treeContainer.scrollTop() - 50
            });
        }

        function scrollToRoot() {
            var $scrollTo = $("#estacion");
            scrollToNode($scrollTo);
        }

        function scrollToSearchRes() {
            var $scrollTo = $(searchRes[posSearchShow]).parents("li").first();
            $("#spanSearchRes").text("Resultado " + (posSearchShow + 1) + " de " + searchRes.length);
            scrollToNode($scrollTo);
        }

        $(function () {
            $('.select').selectpicker();

            $("#estacion").change(function () {
                var codigo = $(this).val();
                openLoader();
                location.href = "${createLink(action:'arbolEstacion')}?codigo=" + codigo;
            });

            $treeContainer.on("loaded.jstree", function () {
                $("#loading").hide();
                $("#tree").removeClass("hidden");
                $("#msgNoPDF").hide();
                <g:if test="${params.selected}">
                setTimeout(function () {
                    $("#tree").jstree("deselect_all").jstree("select_node", "liDoc_${params.selected}");
                }, 500);
                </g:if>
            }).on("select_node.jstree", function (node, selected, event) {
                var nodeId = selected.selected[0];
                var $node = $("#" + nodeId);
                var nodeType = $node.data("jstree").type;
                if (nodeType == "doc") {
                    $("#msgNoPDF").show();
                    var parts = nodeId.split("_");
                    var docId = parts[1];
                    var pathFile = $node.data("file");
                    var path = "${resource()}/" + pathFile;
//                    console.log(path);
                    var myPDF = new PDFObject({
                        url           : path,
                        pdfOpenParams : {
                            zoom : 10
//                            navpanes  : 0,
//                            statusbar : 1,
//                            view      : "FitBH",
//                            pagemode  : "thumbs"
                        }
                    }).embed("doc");
                } else {
                    $("#msgNoPDF").hide();
                }
//                    $('#tree').jstree('toggle_node', selected.selected[0]);
            }).on('search.jstree', function (nodes, str, res) {
//                console.log(nodes, str, res);
                searchRes = $(".jstree-search");
                var cantRes = searchRes.length;
                posSearchShow = 0;
                $("#divSearchRes").removeClass("hidden");
                $("#spanSearchRes").text("Resultado " + (posSearchShow + 1) + " de " + cantRes);
                scrollToSearchRes();
            }).jstree({
                plugins     : ["types", "state", "contextmenu", "search"],
                core        : {
                    multiple       : false,
                    check_callback : true,
                    themes         : {
                        variant : "small",
                        dots    : true,
                        stripes : true
                    }
                },
                contextmenu : {
                    show_at_node : false,
                    items        : createContextMenu
                },
                state       : {
                    key : "docsEstacion"
                },
                search      : {
                    fuzzy             : false,
                    show_only_matches : false,
                    case_sensitive    : false
                    %{--ajax              : {--}%
                    %{--url     : "${createLink(action:'arbolSearch_ajax')}",--}%
                    %{--success : function (msg) {--}%
                    %{--var json = $.parseJSON(msg);--}%
                    %{--$.each(json, function (i, obj) {--}%
                    %{--$('#tree').jstree("open_node", obj);--}%
                    %{--});--}%
                    %{--setTimeout(function () {--}%
                    %{--searchRes = $(".jstree-search");--}%
                    %{--var cantRes = searchRes.length;--}%
                    %{--posSearchShow = 0;--}%
                    %{--$("#divSearchRes").removeClass("hidden");--}%
                    %{--$("#spanSearchRes").text("Resultado " + (posSearchShow + 1) + " de " + cantRes);--}%
                    %{--scrollToSearchRes();--}%
                    %{--}, 300);--}%

                    %{--}--}%
                    %{--}--}%
                },
                types       : {
                    estacion : {
                        icon : "${resource(dir:'images/tree', file:'fuel_16.png')}"
                    },
                    tipoDoc  : {
                        icon : "fa fa-briefcase text-info"
                    },
                    doc      : {
                        icon : "fa fa-file-pdf-o text-danger"
                    }
                }
            });

            $("#btnExpandAll").click(function () {
                $treeContainer.jstree("open_all");
                scrollToRoot();
                return false;
            });

            $("#btnCollapseAll").click(function () {
                $treeContainer.jstree("close_all");
                scrollToRoot();
                return false;
            });

            $('#btnSearchArbol').click(function () {
                $treeContainer.jstree(true).search($.trim($("#searchArbol").val()));
                return false;
            });
            $("#searchArbol").keypress(function (ev) {
                if (ev.keyCode == 13) {
                    $treeContainer.jstree(true).search($.trim($("#searchArbol").val()));
                    return false;
                }
            });

            $("#btnPrevSearch").click(function () {
                if (posSearchShow > 0) {
                    posSearchShow--;
                } else {
                    posSearchShow = searchRes.length - 1;
                }
                scrollToSearchRes();
                return false;
            });

            $("#btnNextSearch").click(function () {
                if (posSearchShow < searchRes.length - 1) {
                    posSearchShow++;
                } else {
                    posSearchShow = 0;
                }
                scrollToSearchRes();
                return false;
            });

            $("#btnClearSearch").click(function () {
                $treeContainer.jstree("clear_search");
                $("#searchArbol").val("");
                posSearchShow = 0;
                searchRes = [];
                scrollToRoot();
                $("#divSearchRes").addClass("hidden");
                $("#spanSearchRes").text("");
            });

        });
    </script>
</body>
</html>