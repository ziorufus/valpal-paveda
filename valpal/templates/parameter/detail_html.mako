<%inherit file="../${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="../util.mako"/>
<%! active_menu_item = "parameters" %>
<%block name="title">${_('Parameter')} ${ctx.name}</%block>
<% import valpal.models as m %>


<h2>${_('Parameter')} ${ctx.name}</h2>

% if ctx.description:
<p>${ctx.description}</p>
% endif

% if ctx.meaning_list:
<p>
<b>Meaning list</b>:
${ctx.meaning_list}
</p>
% endif
% if ctx.typical_context:
<p>
<b>Typical context</b>:
${ctx.typical_context}
</p>
% endif
% if ctx.role_frame:
<p>
<b>Role frame</b>:
${ctx.role_frame}
</p>
% endif
% if ctx.microroles:
<p>
<b>Microroles</b>:
${', '.join(h.link(request, m) for m in ctx.microroles) | n}
</p>
% endif

<div style="clear: both"/>
% if map_ or request.map:
${(map_ or request.map).render()}
% endif

<h2>Basic frames for ${ctx.name}</h2>

${request.get_datatable('values', h.models.Value, parameter=ctx).render()}

<h2>Alternations for ${ctx.name}</h2>

${request.get_datatable('alternationvalues', m.AlternationValue, verbmeaning=ctx).render()}
