from flask import render_template, redirect, url_for, request, current_app, session
from flask_login import current_user
from polll.models import *
from polll.decorators import requires_auth

import plotly.graph_objects as go
import numpy as np
from pprint import pprint
import plotly
import json
import collections


def tier_list(request, poll):

    # Create data dictionary and populate it using database queries
    data = {}
    data["responses"] = len(poll.responses)
    data["options"] = [a.answer for a in poll.answers]
    data["tiers"] = ["S", "A", "B", "C", "D", "F"]
    data["counts"] = []

    for answer in poll.answers:
        responses = (db.session
            .query(TieredResponse)
            .filter(TieredResponse.answer_id == answer.id)
        )

        names = [r.tier.name for r in responses]
        counts = collections.Counter(names)
        data["counts"].append([counts[t] for t in data["tiers"]])

    # Sneaky list transpose
    data["counts"] = list(zip(*data["counts"]))
    pprint(data)

    # Define the graph object
    graph = {
        "data": [
            go.Heatmap(
                z = data["counts"],
                text = data["counts"],
                texttemplate="%{text}",
                textfont = {"size": 20},
                y = data["tiers"],
                x = data["options"],
                colorscale = "greens",
                showscale = False
            )
        ],
        "layout": go.Layout(
            yaxis = dict(
                autorange = "reversed",
                color = "white",
                automargin = True,
                showgrid = False,
                ticks = ""
            ),
            xaxis = dict(
                color = "white",
                automargin = True,
                showgrid = False,
                ticks = ""
            ),
            paper_bgcolor = 'rgba(0,0,0,0)',
            plot_bgcolor = 'rgba(0,0,0,0)',
            height = 400,
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
