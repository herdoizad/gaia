<%@ page import="gaia.estaciones.Estacion" %>

<g:if test="${!estacionInstance}">
    <elm:notFound elem="Estacion" genero="o"/>
</g:if>
<g:else>
<div class="modal-contenido">
<g:if test="${estacionInstance?.nombre}">
    <div class="row">
        <div class="col-sm-2 show-label">
            Nombre
        </div>

        <div class="col-sm-8">
            <g:fieldValue bean="${estacionInstance}" field="nombre"/>
        </div>

    </div>
</g:if>

<g:if test="${estacionInstance?.ruc}">
    <div class="row">
        <div class="col-sm-2 show-label">
            Ruc
        </div>

        <div class="col-sm-8">
            <g:fieldValue bean="${estacionInstance}" field="ruc"/>
        </div>

    </div>
</g:if>

<g:if test="${estacionInstance?.direccion}">
    <div class="row">
        <div class="col-sm-2 show-label">
            Direccion
        </div>

        <div class="col-sm-8">
            <g:fieldValue bean="${estacionInstance}" field="direccion"/>
        </div>

    </div>
</g:if>

<g:if test="${estacionInstance?.mail}">
    <div class="row">
        <div class="col-sm-2 show-label">
            Mail
        </div>

        <div class="col-sm-8">
            <g:fieldValue bean="${estacionInstance}" field="mail"/>
        </div>

    </div>
</g:if>

<g:if test="${estacionInstance?.telefono}">
    <div class="row">
        <div class="col-sm-2 show-label">
            Telefono
        </div>

        <div class="col-sm-8">
            <g:fieldValue bean="${estacionInstance}" field="telefono"/>
        </div>

    </div>
</g:if>


<div class="row">
    <div class="col-sm-2 show-label">
        Propetario
    </div>

    <div class="col-sm-8">
        <g:fieldValue bean="${estacionInstance}" field="propetario"/>
    </div>

</div>







<g:if test="${estacionInstance?.codigo}">
    <div class="row">
        <div class="col-sm-2 show-label">
            Código
        </div>

        <div class="col-sm-8">
            <g:fieldValue bean="${estacionInstance}" field="codigo"/>
        </div>

    </div>
</g:if>

<g:if test="${estacionInstance?.codigo}">
    <div class="row">
        <div class="col-sm-2 show-label">
            Provincia
        </div>

        <div class="col-sm-8">

            ${gaia.documentos.Ubicacion.findByCodigo(estacionInstance.provincia)?.nombre}
        </div>

    </div>
</g:if>
<g:if test="${estacionInstance?.codigo}">
    <div class="row">
        <div class="col-sm-2 show-label">
            Cantón
        </div>

        <div class="col-sm-8">
            ${gaia.documentos.Ubicacion.findByCodigo(estacionInstance.canton)?.nombre}
        </div>

    </div>
</g:if>
<g:if test="${estacionInstance?.codigo}">
    <div class="row">
        <div class="col-sm-2 show-label">
            Parroquia
        </div>

        <div class="col-sm-8">
            ${gaia.documentos.Ubicacion.findByCodigo(estacionInstance.parroquia)?.nombre}
        </div>

    </div>
</g:if>

<div class="row">
    <div class="col-sm-2 show-label">
        Representante
    </div>

    <div class="col-sm-8">
        ${estacionInstance.representante}
    </div>

</div>


<div class="row">
    <div class="col-sm-2 show-label">
        Cédula representante
    </div>

    <div class="col-sm-8">
        ${estacionInstance.cedulaRepresentante}
    </div>
</div>


<div class="row">
    <div class="col-sm-2 show-label">
        Administrador
    </div>

    <div class="col-sm-8">
        ${estacionInstance.administrador}
    </div>
</div>


<div class="row">
    <div class="col-sm-2 show-label">
        Cédula administrador
    </div>

    <div class="col-sm-8">
        ${estacionInstance.administrador}
    </div>
</div>


<div class="row">
    <div class="col-sm-2 show-label">
        Arrendatario
    </div>

    <div class="col-sm-8">
        ${estacionInstance.arrendatario}
    </div>
</div>


<div class="row">
    <div class="col-sm-2 show-label">
        Representante arrendatario
    </div>

    <div class="col-sm-8">
        ${estacionInstance.representanteArrendatario}
    </div>
</div>


<div class="row">
    <div class="col-sm-2 show-label">
        Cédula representante arrendatario
    </div>

    <div class="col-sm-8">
        ${estacionInstance.cedulaRepresentanteArrendatario}
    </div>
</div>


</div>
</g:else>