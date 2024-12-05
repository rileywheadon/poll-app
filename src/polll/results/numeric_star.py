from flask import render_template, redirect, url_for, request, current_app, session
from flask_login import current_user
from polll.models import *
from polll.decorators import requires_auth

import plotly.graph_objects as go
import numpy as np
from pprint import pprint
import plotly
import json



def numeric_star(request, poll):

    # Create data dictionary and populate it using database queries
    data = {}
    data["responses"] = len(poll.responses)
    responses = (db.session
        .query(NumericResponse)
        .join(NumericResponse.response)
        .filter(Response.poll_id == poll.id)
        .all()
    )

    ratings = [r.value for r in responses]
    data["bins"] = np.linspace(0, 5, num = 11)
    data["counts"] = np.histogram(ratings, np.linspace(-0.25, 5.25, num=12))[0]

    pprint(data)

    # Define the graph
    graph = {
        "data": [
            go.Bar(
                x = data["bins"],
                y = data["counts"],
                text = data["counts"],
                marker = dict(
                    color = "#96d0c3"
                )
            )
        ],
        "layout": go.Layout(
            yaxis = dict(
                color = "white",
                automargin = True,
                showticklabels = False,
                showgrid = False,
            ),
            xaxis = {
                "tickvals": data["bins"],
                "automargin": True,
                "showgrid":  False,
                "range": [-0.25, 5.25]
            },
            paper_bgcolor = 'rgba(0,0,0,0)',
            plot_bgcolor = 'rgba(0,0,0,0)',
            height = 300,
            margin = dict(l=20, r=20, t=20, b=20, pad=10),
            font = dict(size=18, color = "white"),
            bargap = 0.02,
        ),
        "config": {
            "displayModeBar": False,
        }
    }

    graphJSON = json.dumps(graph, cls=plotly.utils.PlotlyJSONEncoder)
    return render_template("results.html", poll = poll, plot = graphJSON)



