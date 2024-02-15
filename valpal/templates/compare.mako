<%inherit file="./${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="util.mako"/>
<%! active_menu_item = "compare" %>
<% import valpal.models as models %>

<h2>Compare languages</h2>

<div class="row-fluid">
    <div class="span4">
        <form class="well well-small" autocomplete="off" class="form-horizontal">
            <div class="control-group">
                <label for="lang1" class="control-label">Language 1</label>
                <div class="controls">
                    <input tabindex="3" type="text" name="lang1" id="lang1"
                    value="${params['lang1'] if params['lang1'] else ''}"
                    data-provide="typeahead" data-source="${languages}"
                    placeholder="Start typing and choose">
                </div>
            </div>

            <div class="control-group">
                <label for="lang2" class="control-label">Language 2</label>
                <div class="controls">
                    <input tabindex="3" type="text" name="lang2" id="lang2"
                    value="${params['lang2'] if params['lang2'] else ''}"
                    data-provide="typeahead" data-source="${languages}"
                    placeholder="Start typing and choose">
                </div>
            </div>

            <div class="control-group">
                <label for="meaning" class="control-label">Verb meaning</label>
                <div class="controls">
                    <input tabindex="3" type="text" name="meaning" id="meaning"
                    value="${params['meaning'] if params['meaning'] else ''}"
                    data-provide="typeahead" data-source="${meanings}"
                    placeholder="Start typing and choose">
                </div>
            </div>

            <div class="control-group">
                <div class="controls">
                    <label class="checkbox">
                        <input tabindex="3" type="checkbox" name="nonever" ${'checked' if params['nonever'] else ''}> Hide alternations that never occur
                    </label>
                    <label class="checkbox">
                        <input tabindex="3" type="checkbox" name="nomissradi" ${'checked' if params['nomissradi'] else ''}> Hide alternations without class
                    </label>
                </div>
            </div>

            <div class="control-group">
                <div class="controls">
                    <button tabindex="3" type="submit" class="btn">Submit</button>
                </div>
            </div>
        </form>
    </div>
    <div class="span8">
        % if request.params.get('lang1') == None:
            <p>Fill in the fields to get the data.</p>
        % else:
            % if message:
            <div class="alert alert-error"><p>${message}</p></div>
            % else:
                <h2>Comparison between ${params['lang1']} and ${params['lang2']} on ${params['meaning']}</h2>
                <div class="tabbable">
                    <ul class="nav nav-tabs">
                        <li class="active"><a href="#basic" data-toggle="tab">Basic frames</a></li>
                        <li><a href="#alternations" data-toggle="tab">Alternations</a></li>
                    </ul>
                    <div class="tab-content">
                        <div id="basic" class="tab-pane active">
                            <%util:table eid="table_b" items="${query_b}" args="item" class_="table-condensed table-striped">\
                                <%def name="head()">
                                    <th>Language</th>
                                    <th>Verb form</th>
                                    <th>Basic coding frame</th>
                                </%def>
                                <% print(item.__dict__) %>
                                <td>${h.link(request, item.valueset.contribution)}</td>
                                <td>${h.link(request, item)}</td>
                                <td>${h.link(request, item.basic_codingframe)}</td>
                            </%util:table>
                        </div>
                        <div id="alternations" class="tab-pane">
                            <%util:table eid="table_a" items="${query_a}" args="item" class_="table-condensed table-striped">\
                                <%def name="head()">
                                    <th>Language</th>
                                    <th>Alternation</th>
                                    <th>Verb form</th>
                                    <th>Basic coding frame</th>
                                    <th>Derived coding frame</th>
                                    <th>Alternation class</th>
                                    <th>Occurs</th>
                                    <th></th>
                                    ##<th>Type</th>
                                    ##<th>Status</th>
                                    ##<th>Family</th>
                                </%def>
                                <td>${h.link(request, item.verb.valueset.contribution)}</td>
                                <td>${h.link(request, item.alternation)}</td>
                                <td>${h.link(request, item.verb)}</td>
                                <td>${h.link(request, item.verb.basic_codingframe)}</td>
                                <td>${h.link(request, item.derived_codingframe) if item.derived_codingframe else ""}</td>
                                <td>${item.alternation.radi}</td>
                                <td>${item.alternation_occurs}</td>
                                <td>${h.link(request, item, label="Details")}</td>
                            </%util:table>
                        </div>
                    </div>
                </div>

            % endif
        % endif

    </div>
</div>

<script>
    $(document).ready(function() {
        if (location.hash !== '') {
            $('a[href="#' + location.hash.substr(2) + '"]').tab('show');
        }
        return $('a[data-toggle="tab"]').on('shown', function(e) {
            return location.hash = 't' + $(e.target).attr('href').substr(1);
        });
    });
</script>
