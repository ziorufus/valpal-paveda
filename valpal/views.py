from valpal import models
from clld.db.meta import DBSession
from sqlalchemy.orm import aliased
from clld.db.models import common
from sqlalchemy import or_
from sqlalchemy import and_

import json
import re

def compare(request):
    mas = DBSession.query(
            models.Variety.pk,
            models.Variety.name,
            models.Variety.id
        ).select_from(models.Variety)
    languages = json.dumps([f"{m['name']} [{m['id']}]" for m in mas])

    mas = DBSession.query(
            models.VerbMeaning.pk,
            models.VerbMeaning.name,
            models.VerbMeaning.id
        ).select_from(models.VerbMeaning)
    meanings = json.dumps([m['name'] for m in mas])

    res = dict()
    res['languages'] = languages
    res['meanings'] = meanings
    res['params'] = dict()
    res['params']['nonever'] = "checked"
    res['params']['nomissradi'] = "checked"
    res['params']['lang1'] = None
    res['params']['lang2'] = None
    res['params']['meaning'] = None
    res['message'] = None
    res['query'] = None
    res['request'] = request

    # The button has been pressed
    if request.params.get('lang1') != None:

        # Fill the fields
        res['params']['lang1'] = request.params.get('lang1')
        res['params']['lang2'] = request.params.get('lang2')
        res['params']['meaning'] = request.params.get('meaning')
        res['params']['nonever'] = "checked" if request.params.get('nonever') else ""
        res['params']['nomissradi'] = "checked" if request.params.get('nomissradi') else ""

        if not request.params.get('lang1') or not request.params.get('lang2') or not request.params.get('meaning'):
            res['message'] = "All fields are mandatory"
            return res

        lang1 = re.sub(r".*\[(.*)\]$", r"\1", request.params.get("lang1"))
        lang2 = re.sub(r".*\[(.*)\]$", r"\1", request.params.get("lang2"))
        meaning = re.sub(r".*\[(.*)\]$", r"\1", request.params.get("meaning"))

        lang_o = []

        mas = DBSession.query(models.Variety)\
            .join(models.Variety.family, isouter=True)\
            .filter(models.Variety.glottocode == lang1)
        lang_o.append(None) # index 0
        for m in mas:
            lang_o[0] = m
        if lang_o[0] == None:
            res['message'] = f"Language {request.params.get('lang1')} not found"
            return res

        mas = DBSession.query(models.Variety)\
            .join(models.Variety.family, isouter=True)\
            .filter(models.Variety.glottocode == lang2)
        lang_o.append(None) # index 1
        for m in mas:
            lang_o[1] = m
        if lang_o[1] == None:
            res['message'] = f"Language {request.params.get('lang2')} not found"
            return res

        mas = DBSession.query(models.VerbMeaning)\
            .filter(models.VerbMeaning.id == meaning)
        meaning_o = None
        for m in mas:
            meaning_o = m
        if meaning_o == None:
            res['message'] = f"Meaning {request.params.get('meaning')} not found"
            return res

        # Basic frames

        query = DBSession.query(models.Verb)\
            .outerjoin(common.ValueSet)\
            .outerjoin(models.LanguageContribution, models.LanguageContribution.language_pk == common.ValueSet.language_pk)\
            .outerjoin(common.Parameter)\
            .outerjoin(models.CodingFrame, models.Verb.basic_codingframe)

        query = query.filter(or_(models.LanguageContribution.name == lang_o[0].name, models.LanguageContribution.name == lang_o[1].name))
        query = query.filter(common.ValueSet.parameter == meaning_o)

        res['query_b'] = query

        # Alternations

        basic_coding_frame_alias = aliased(models.CodingFrame)
        derived_coding_frame_alias = aliased(models.CodingFrame)

        query = DBSession.query(models.AlternationValue)\
            .join(models.Alternation, isouter=True)\
            .join(models.Verb, isouter=True)\
            .join(common.ValueSet, isouter=True)\
            .join(models.VerbMeaning, isouter=True)\
            .join(basic_coding_frame_alias, models.Verb.basic_codingframe, isouter=True)\
            .join(derived_coding_frame_alias, models.AlternationValue.derived_codingframe, isouter=True)\
            .join(models.LanguageContribution)

        query = query.filter(or_(models.LanguageContribution.name == lang_o[0].name, models.LanguageContribution.name == lang_o[1].name))
        query = query.filter(models.VerbMeaning.name == meaning_o.name)

        if request.params.get('nonever'):
            query = query.filter(models.AlternationValue.alternation_occurs != "Never")
        if request.params.get('nomissradi'):
            query = query.filter(and_(models.Alternation.radi != "None", models.Alternation.radi != ""))

        res['query_a'] = query

    return res
