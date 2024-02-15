<%inherit file="app.mako"/>

<%block name="brand">
    <a href="${request.route_url('dataset')}" class="brand">
        <img alt="PaVeDa" src="${request.static_url('valpal:static/logo-paveda-100-3.png')}" />
    </a>
</%block>

${next.body()}
