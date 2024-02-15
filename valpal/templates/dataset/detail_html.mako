<%inherit file="../home_comp.mako"/>
<%namespace name="util" file="../util.mako"/>

<h2>Welcome to PaVeDa</h2>

<p>PaVeDa–Pavia Verbs Database is an open-source relational database for investigating verb argument structure across languages (Zanchi et al. 2022), which intends to expand and enhance the ValPaL database (valpal.info/ Hartmann et al. 2013; Haspelmath/Hartmann 2015) with more languages and further features.</p>

<p>This project is funded through the European Union funding – NextGenerationEU – Missione 4 Istruzione e ricerca - componente 2, investimento 1.1” Fondo per il Programma Nazionale della Ricerca (PNR) e Progetti di Ricerca di Rilevante Interesse Nazionale (PRIN)” progetto 20223XH5XM "Verbs’ constructional patterns across languages: a multi-dimensional investigation" CUP F53D23004570006 - Dipartimento Studi Umanistici (Università di Pavia).</p>

<p class="colab paveda-logo">
    <a href="https://next-generation-eu.europa.eu/index_en">
        <img id="home-eu-logo" alt="Next generation EU logo" src="${request.static_url('valpal:static/logo-pnrr.png')}" />
    </a>
    <a href="https://www.mur.gov.it/">
        <img id="home-mur-logo" alt="MUR logo" src="${request.static_url('valpal:static/logo-mur.png')}"/>
    </a>
    <a href="https://www.italiadomani.gov.it/content/sogei-ng/it/it/home.html">
        <img id="home-pnrr-logo" alt="PNRR logo" src="${request.static_url('valpal:static/logo-italiadomani.png')}" />
    </a>
    <a href="https://www.unipv.it">
        <img alt="University of Pavia logo" src="${request.static_url('valpal:static/logo-unipv-logo.png')}" />
    </a>
    <a href="https://www.unina.it">
        <img alt="University of Naples Federico II logo" src="${request.static_url('valpal:static/logo-uninapoli-logo.png')}" />
    </a>
    <a href="https://valpal.info/">
        <img alt="ValPaL" src="${request.static_url('valpal:static/logo_valpal_cut.png')}"/>
    </a>
</p>

<p class="lead">The Valency Patterns Leipzig Online Database</p>

<p class="colab">
    <a href="http://www.dfg.de/">
        <img id="home-dfg-logo" alt="DFG" src="${request.static_url('valpal:static/dfg_logo.jpg')}" />
    </a>
    <a href="http://www.eva.mpg.de/">
        <img id="home-eva-logo" alt="MPI-EVA" src="${request.static_url('valpal:static/logo_minerva.png')}"/>
    </a>
    <img id="home-valency-logo" alt="Valency Project" src="${request.static_url('valpal:static/logo_valency.png')}"/>
</p>

<h3>How to cite ValPaL</h3>

<p>
The ValPaL online database is an edited database consisting of different
languages which should be regarded as separate publications, like chapters of an
edited volume.
These datasets exemplified by
<a href="${request.resource_url(example_contribution)}">Icelandic</a> should be
cited as follows:
</p>

<pre class="citation">
${citation.render(example_contribution, request).rstrip('\n')}
</pre>

<p>
The complete work should be cited as follows:
${h.button('BibTeX', onclick=h.JSModal.show('BibTeX citation', None, '<pre>{}</pre>'.format(bibtex.render(ctx, request))))}
</p>

<pre class="citation">
${citation.render(ctx, request).rstrip('\n')}
</pre>

<h3>Terms of use</h3>

The content of this web site is published under a
<a href="${ctx.license}">${ctx.jsondata['license_name']}</a>.
We invite the community of users to think about further applications for the
available data and look forward to your comments, feedback, and questions.
