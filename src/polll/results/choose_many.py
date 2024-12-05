from flask import render_template, redirect, url_for, request, current_app, session
from flask_login import current_user
from polll.models import *
from polll.decorators import requires_auth

import plotly.graph_objects as go
import numpy as np
from pprint import pprint
import plotly
import json

def choose_many(request, poll):

    # Create data dictionary and populate it using database queries
    data = {}
    data["responses"] = len(poll.responses)
    data["options"] = [a.answer for a in poll.answers]

    getCount = lambda answer : (db.session
        .query(DiscreteResponse)
        .filter(DiscreteResponse.answer_id == answer.id)
        .count()
    )

    data["counts"] = [getCount(a) for a in poll.answers]

    pprint(data)

    # Define the graph object
    graph = {
        "data": [
            go.Bar(
                y = data["options"],
                x = data["counts"],
                orientation = "h",
                text = data["counts"],
                marker = dict(
                    color = "#96d0c3"
                )
            )
        ],
        "layout": go.Layout(
            yaxis = dict(
                autorange = "reversed",
                color = "white",
                automargin = True
            ),
            xaxis = dict(
                showticklabels = False,
                showgrid = False
            ),
            paper_bgcolor = 'rgba(0,0,0,0)',
            plot_bgcolor = 'rgba(0,0,0,0)',
            height = 200,
            margin = dict(l=20, r=20, t=20, b=20, pad=10),
            font = dict(size=18),
            barcornerradius = 5,
        ),

        "config": {
            "displayModeBar": False,
        }
    }

    # Print the data to the terminal for debugging
    graphJSON = json.dumps(graph, cls = plotly.utils.PlotlyJSONEncoder)
    return render_template("results.html", poll = poll, plot = graphJSON)
