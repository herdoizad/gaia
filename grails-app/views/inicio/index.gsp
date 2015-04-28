<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>P&S</title>
    <style type="text/css">
    .inicio img {
        height : 190px;
    }

    i {
        margin-right : 5px;
    }
    .link-modulo{
        width: 100%;
        height: 100px;
        border-radius: 5px;
        /*border: 1px solid #000;*/
        padding: 7px;
        background: #006EB7;
    }
    .imagen-link{
        border-radius: 5px;
        height: 85px;
        width: 40%;
        display: inline-table;
        line-height: 100%;
        padding: 5px;
        /*border: 1px solid #000000;*/
        margin: 0px;
        background: #ffffff;
    }
    .texto-link{
        border-radius: 5px;
        height: 85px;
        padding: 3px;
        width: 55%;
        display: inline-table;
        line-height: 78px;
        vertical-align: middle;
        font-weight: bold;
        text-align: center;
        /*border: 1px solid #000000;*/
        margin: 0px;
        color: #E14429;
        text-shadow: #ffffff;
        font-size: 14px;
        text-shadow:
        -1px -1px 0 #fff,
        1px -1px 0 #fff,
        -1px 1px 0 #fff,
        1px 1px 0 #fff;
        text-decoration: none;
    }
    </style>
    <link href="${g.resource(dir: 'css/custom/', file: 'dashboard.css')}" rel="stylesheet" type="text/css">
</head>
<body>
<elm:container titulo=" Panel de control Petróleos y servicios - Seleccione el módulo para ingresar" tipo="horizontal">
    <div class="row">
        <g:each in="${session.sistemas}" var="sistema" status="i" >
            <g:if test="${sistema.codigo!='T'}">
                <div class="col-md-3" style="margin-top:20px;">
                    <g:link controller="inicio" action="modulos" params="[sistema:sistema.codigo]" title="${sistema.descripcion}" id="link_${i}"  >
                        <div class="link-modulo">
                            <div class="imagen-link" style="padding-left: 8px">
                                <img src="${resource(dir: 'images',file: sistema.imagen)}" height="100%" >
                            </div>
                            <div class="texto-link">
                                ${sistema.nombre}
                            </div>
                        </div>
                    </g:link>
                </div>
            </g:if>
        </g:each>
    </div>
</elm:container>
</body>
</html>