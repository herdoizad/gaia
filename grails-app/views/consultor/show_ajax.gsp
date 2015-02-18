<%@ page import="gaia.documentos.Consultor" %>

<g:if test="${!consultorInstance}">
    <elm:notFound elem="Consultor" genero="o"/>
</g:if>
<g:else>
    <div class="modal-contenido">

        <g:if test="${consultorInstance?.nombre}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Nombre
                </div>

                <div class="col-sm-4">
                    <g:fieldValue bean="${consultorInstance}" field="nombre"/>
                </div>

            </div>
        </g:if>

        <g:if test="${consultorInstance?.ruc}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Ruc
                </div>

                <div class="col-sm-4">
                    <g:fieldValue bean="${consultorInstance}" field="ruc"/>
                </div>

            </div>
        </g:if>

        <g:if test="${consultorInstance?.telefono}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Teléfono
                </div>

                <div class="col-sm-4">
                    <g:fieldValue bean="${consultorInstance}" field="telefono"/>
                </div>

            </div>
        </g:if>

        <g:if test="${consultorInstance?.direccion}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Dirección
                </div>

                <div class="col-sm-4">
                    <g:fieldValue bean="${consultorInstance}" field="direccion"/>
                </div>

            </div>
        </g:if>

        <g:if test="${consultorInstance?.mail}">
            <div class="row">
                <div class="col-sm-3 show-label">
                    Mail
                </div>

                <div class="col-sm-4">
                    <g:fieldValue bean="${consultorInstance}" field="mail"/>
                </div>

            </div>
        </g:if>

    </div>
</g:else>