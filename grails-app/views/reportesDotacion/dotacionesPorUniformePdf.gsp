<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>

    <title>Reporte de dotaciones</title>

    <rep:estilos orientacion="p" pagTitle="LISTAD0 DOTACIONES APROBADAS"/>



    <style type="text/css">

    .label {
        width       : 150px;
        font-weight : bold;
    }

    table {
        font-size       : 10px;
        border-collapse : collapse;
    }

    th {
        background-color : #3A5DAA;
        color            : #ffffff;
        font-weight      : bold;
        font-size        : 10px;
        border           : 1px solid #000;
        padding          : 3px;
    }


    .table {
        width: 100%;
        font-size  : 10px;
        margin-top : 10px;
        border-collapse: collapse;
    }


    .table td {
        font-size : 10px;
        border: 1px solid #000000;
        padding: 3px;

    }

    </style>
</head>
<body>
<rep:headerFooter title="LISTAD0 DOTACIONES APROBADAS"/>
<p style="font-weight: bold">UNIFORME: ${uniforme.descripcion}</p>
<table class="table table-bordered table-striped table-hover" style="font-size: 11px">
    <thead>
    <tr>
        <th style="width: 150px">Supervisor</th>
        <g:each in="${tallas}" var="u">
            <th>${u.talla}</th>
        </g:each>
        <th>Total</th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${datos}" var="d" status="i">
        <g:set var="totH" value="${0}"/>
        <tr>
            <td style="font-weight: ${i==datos.size()-1?'bold':'normal'}">${d.key}</td>
            <g:each in="${d.value}" var="sd">
                <td style="font-weight: ${i==datos.size()-1?'bold':'normal'};text-align: right">${sd.value}</td>
                <g:set var="totH" value="${totH+sd.value}"/>
            </g:each>
            <td style="text-align: right">
                ${totH}
            </td>
        </tr>
    </g:each>
    </tbody>
</table>
<p style="font-weight: bold;">TOTAL ${uniforme}: ${total}</p>
</body>
</html>