from functools import partial

from pyramid.config import Configurator

from clld_glottologfamily_plugin import util as fam_util

from clld.interfaces import IMapMarker, IValueSet
from clld.web.app import menu_item
from clldutils.svg import icon, data_url

# we must make sure custom models are known at database initialization!
from valpal import models, interfaces


_ = lambda s: s

_('Parameter')
_('Parameters')
_('Contribution')
_('Contributions')
_('Contributor')
_('Contributors')
_('Sentence')
_('Sentences')
_('Value Set')
_('Value')
_('Values')
_('Address')
_('Datapoints')


class LanguageByFamilyMapMarker(fam_util.LanguageByFamilyMapMarker):
    def __call__(self, ctx, req):
        if IValueSet.providedBy(ctx):
            if ctx.language.family:
                map_icon = icon(ctx.language.family.jsondata['icon'])
            else:
                map_icon = icon(req.registry.settings.get(
                    'clld.isolates_icon', fam_util.ISOLATES_ICON))
            return data_url(map_icon)
        else:
            return super().__call__(ctx, req)


def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    # move `/languages` out of the way, because the old webapp used that route
    # for contributions
    settings['route_patterns'] = {
        'languages': '/languoids',
        'language': r'/languoids/{id:[^/\.]+}',
    }
    config = Configurator(settings=settings)
    config.include('clld.web.app')

    config.include('clldmpg')

    config.register_menu(
        ('dataset', partial(menu_item, 'dataset', label='Home')),
        ('contributions', partial(menu_item, 'contributions')),
        ('parameters', partial(menu_item, 'parameters')),
        ('codingframes', partial(menu_item, 'codingframes', label='All coding frames')),
        ('microroles', partial(menu_item, 'microroles')),
        ('alternations', partial(menu_item, 'alternations', label='All alternations')),
        ('compare', partial(menu_item, 'compare', label="Compare languages")),
    )

    config.registry.registerUtility(LanguageByFamilyMapMarker(), IMapMarker)

    config.register_resource(
        'microrole', models.Microrole, interfaces.IMicrorole, with_index=True)
    config.register_resource(
        'codingset', models.CodingSet, interfaces.ICodingSet, with_index=True)
    config.register_resource(
        'codingframe', models.CodingFrame, interfaces.ICodingFrame, with_index=True)
    config.register_resource(
        'alternation', models.Alternation, interfaces.IAlternation, with_index=True)
    config.register_resource(
        'alternationvalue', models.AlternationValue, interfaces.IAlternationValue, with_index=True)
    config.register_resource(
        'verbcodingframemicrorole',
        models.VerbCodingFrameMicrorole,
        interfaces.IVerbCodingFrameMicrorole,
        with_index=True)

    config.add_page('project')
    config.add_page('database')
    config.add_page('glossary')
    config.add_page('credits')
    config.add_settings(home_comp=[
        'project', 'database', 'download', 'glossary', 'credits', 'legal',
        'contact',
    ])

    config.add_route_and_view(
        'compare',
        '/compare',
        views.compare,
        renderer='compare.mako')

    config.add_settings({
        'clld.publisher_logo': 'valpal:static/logo-unipv-logo.png'
        # 'clld.privacy_policy_url': 'https://example.com',
    })

    return config.make_wsgi_app()
