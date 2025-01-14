// TODO: 
// - Generally improve look of graph for dark and light mode
// - When hovering with the mouse over a line graph, hide the 
//   actual y value as it doesn't correspond to the true number of votes
//   due to the normalization from the Gaussian kde



// landing funciton for every graph type so that the data in the 
// Jinja template can be used in a js file as well as so there is
//  only one event listener in this file
// (Jinja isn't supported in exteneral .js files as far as I'm aware)
function graphInit(type, poll_id, rs=null, rs_kde=null) {
    ["load", "htmx:afterSettle"].forEach((e) => {
        window.addEventListener(e, () => {
            switch (type.toLowerCase()) {
                case "choose one":
                    make_choose_one_graph(poll_id, rs);
                    break;
                case "choose many":
                    make_choose_many_graph(poll_id, rs);
                    break;
                case "scale":
                    make_scale_graph(poll_id, rs, rs_kde);
                    break;
                case "rank":
                    make_rank_graph(poll_id, rs);
                    break;
            }
        })
    })
}

function make_choose_one_graph(poll_id, rs) {
    new Chart(document.getElementById(`poll-graph-${poll_id}`), {
        type: "bar",
        data: {
            labels: rs.map((e) => e["answer"]),
                datasets: [{
                    label: "y-axis",
                    fill: true,
                    borderColor: "#ffffff",
                    data: rs.map((e) => e["count"]),
                }]
            },
            options: {
                indexAxis: 'y',
                title: {
                    display: true,
                    text: "Title",
                    fontSize: 24,
                    fontColor: "#ffffff"
                },
                legend: {display: false},
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }


    })
}

function make_choose_many_graph(poll_id, rs) {

    new Chart(document.getElementById(`poll-graph-${poll_id}`), {
        type: "pie",
        data: {
            labels: rs.map((e) => e["answer"]),
                datasets: [{
                    label: "y-axis",
                    fill: true,
                    borderColor: "#ffffff",
                    data: rs.map((e) => e["count"]),
                }]
            },
            options: {
                indexAxis: 'y',
                title: {
                    display: true,
                    text: "Title",
                    fontSize: 24,
                    fontColor: "#ffffff"
                },
                legend: {display: false},
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }


    })    

}


function make_scale_graph(poll_id, rs, rs_kde) {
    // not in use at the moment but gonna keep until certain on kde implementation
    vals = parse_results(rs);   

    // kde
    pts = parse_kde_results(rs_kde);

    new Chart(document.getElementById(`poll-graph-${poll_id}`), {
        type: "line",
        data: {
        labels: [...Array(rs_kde[0].length).keys()],
            datasets: [{
                label: "y-axis",
                fill: true,
                lineTension: 0.3,
                borderColor: "#ffffff",
                data: pts,
            }]
        },
        options: {
            title: {
                display: true,
                text: "Title",
                fontSize: 24,
                fontColor: "#ffffff"
            },
            legend: {display: false},
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    }
    )
}

function make_rank_graph(poll_id, rs) {}



// Helpers for formatting the data into something that can be graphed
function parse_results(rs) {
    var vals = Array(101).fill(0);
    for (let i = 0; i < rs.length; i++) vals[rs[i]["value"]] = rs[i]["count"];
    return vals;
}

function parse_kde_results(rs_kde) {
    let pts = [];
    for (let i = 0; i < rs_kde[0].length; i++) pts.push({x: rs_kde[0][i], y: rs_kde[1][i]});
    return pts;
}
