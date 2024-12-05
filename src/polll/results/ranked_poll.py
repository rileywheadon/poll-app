from flask import render_template, redirect, url_for, request, current_app, session
from flask_login import current_user
from polll.models import *
from polll.decorators import requires_auth

import plotly.graph_objects as go
import numpy as np
from pprint import pprint
import plotly
import json


def ranked_poll(request, poll):

    # Create data dictionary and populate it using database queries
    data = {}
    data["responses"] = len(poll.responses)
    data["options"] = [a.answer for a in poll.answers]
    data["ranks"] = []

    for answer in poll.answers:
        responses = (db.session
            .query(RankedResponse)
            .filter(RankedResponse.answer_id == answer.id)
        )
        
        ranks = [r.rank for r in responses]
        data["ranks"].append(sum(ranks)/len(ranks))

    pprint(data)

    # Define the graph object
    graph = {
        "data": [
            go.Bar(
                y = data["options"],
                x = data["ranks"],
                orientation = "h",
                text = data["ranks"],
                texttemplate = "%{text:.2f}",
                marker = dict(
                    color = "#96d0c3"
                )
            )
        ],
        "layout": go.Layout(
            yaxis = dict(
                autorange = "reversed",
                color = "white",
                automargin = True,
                categoryorder = 'total ascending',
            ),
            xaxis = dict(
                showticklabels = False,
                showgrid = False,
            ),
            paper_bgcolor = 'rgba(0,0,0,0)',
            plot_bgcolor = 'rgba(0,0,0,0)',
            height = 250,
            margin = dict(l=20, r=20, t=20, b=20, pad=10),
            font = dict(size=18),
            barcornerradius = 5,
        ),

        "config": {
            "displayModeBar": False,
        }
    }

    graphJSON = json.dumps(graph, cls = plotly.utils.PlotlyJSONEncoder)
    return render_template("results.html", poll = poll, plot = graphJSON)
