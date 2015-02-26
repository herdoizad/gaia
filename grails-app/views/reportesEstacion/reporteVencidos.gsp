<%@ page import="gaia.documentos.Documento" %>

<html>
    <head>
        <title>Documentos por vencer</title>

        <rep:estilos orientacion="l" pagTitle="Documentos vencidos"/>

        <style type="text/css">
        .titulo, .proyecto, .componente {
            width : 16cm;
        }

        .titulo {
            height        : .5cm;
            font-size     : 16pt;
            font-weight   : bold;
            text-align    : center;
            margin-bottom : .5cm;
        }

        .row {
            width      : 100%;
            height     : 14px;
            margin-top : 10px;
            font-size  : 12px;
        }

        .label {
            width       : 150px;
            font-weight : bold;
        }

        td {
            padding : 3px;
            border  : 1px solid #fff
        }

        table {
            font-size       : 12px;
            border-collapse : collapse;
        }

        th {
            background-color : #3A5DAA;
            color            : #ffffff;
            font-weight      : bold;
            font-size        : 12px;
            border           : 1px solid #fff;
            padding          : 3px;
        }

        .table {
            font-size  : 10pt;
            margin-top : 10px;
        }

        .table td {
            font-size : 10pt;
        }
        </style>
    </head>

    <body>

        <rep:headerFooter title="Documentos vencidos"/>

        <table border="1" class="table" width="100%">
            <thead>
                <tr>
                    <th style="width: 100px;">Estación</th>
                    <th style="width: 130px;">Tipo Documento</th>
                    <th style="width: 70px;"># Referencia</th>
                    <th style="width: 70px;">Emisión</th>
                    <th style="width: 70px;">Vencimiento</th>
                </tr>
            </thead>
            <tbody id="tb">
                <g:each in="${estaciones}" var="estacion">
                    <g:set var="documentos" value="${gaia.documentos.Documento.findAllByEstacion(estacion)}"/>
                    <g:if test="${documentos.size() > 0}">
                        <tr>
                            <td>
                                ${estacion.nombre}
                            </td>
                            <td>
                                <ul>
                                    <g:each in="${documentos}" var="documento">
                                        <li>
                                            ${documento.tipo.nombre}
                                        </li>
                                    </g:each>
                                </ul>
                            </td>
                            <td>
                                <ul>
                                    <g:each in="${documentos}" var="documento">
                                        <li>
                                            <g:fieldValue bean="${documento}" field="referencia"/>
                                        </li>
                                    </g:each>
                                </ul>
                            </td>
                            <td>
                                <ul>
                                    <g:each in="${documentos}" var="documento">
                                        <li>
                                            ${documento?.inicio?.format("dd-MM-yyyy")}
                                        </li>
                                    </g:each>
                                </ul>
                            </td>
                            <td>
                                <ul>
                                    <g:each in="${documentos}" var="documento">
                                        <g:if test="${documento?.fin}">
                                            <g:if test="${documento.fin.clearTime() <= new Date().clearTime()}">
                                                <li style="color: #ce464a">
                                                    Vencido ${documento?.fin?.format("dd-MM-yyyy")}
                                                </li>
                                            </g:if>
                                            <g:elseif test="${documento?.fin < new Date().plus(30)}">
                                                <li style="color: #ffa324">
                                                    Por vencer  ${documento?.fin?.format("dd-MM-yyyy")}
                                                </li>
                                            </g:elseif>
                                            <g:else>
                                                <li>
                                                    ${documento?.fin?.format("dd-MM-yyyy")}
                                                </li>
                                            </g:else>
                                        </g:if>
                                        <g:else>
                                            <li>
                                                Sin fecha de vencimiento
                                            </li>
                                        </g:else>
                                    </g:each>
                                </ul>
                            </td>
                        </tr>
                    </g:if>
                </g:each>
            </tbody>
        </table>

    </body>
</html>
