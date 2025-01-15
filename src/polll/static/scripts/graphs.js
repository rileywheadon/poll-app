function graphInit(type, poll_id, rs = null, rs_kde = null) {
    // Don't ask me how or why this works but it does (gotta be the dumbest shit I've ever wrote)
    var choose_one_graph, choose_many_graph, scale_graph, tier_graph, i, func;
    var graphs = [choose_one_graph, choose_many_graph, scale_graph, tier_graph];
    ["load", "htmx:afterSettle"].forEach((e) => {
        window.addEventListener(e, () => {
            switch (type.toLowerCase()) {
                case "choose one":
                    i = 0;
                    func = choose_one_options(rs);
                    break;
                case "choose many":
                    i = 1;
                    func = choose_many_options(rs);
                    break;
                case "scale":
                    i = 2;
                    func = scale_graph_options(rs, rs_kde);
                    break;
                case "tier":
                     i = 3;
                     func = tier_graph_options(rs);
                    break;
            }
            graphs[i] instanceof ApexCharts ? graphs[i].destroy() : graphs[i] = new ApexCharts(document.getElementById(`poll-graph-${poll_id}`), func);
            graphs[i].render();
        })
    })

}


// TOOD: add a 'theme' parameter to the parent function
//  and let it determine the colour scheme

function choose_one_options(rs) {

    // make bar charts a percent via making each element a fraction of the total number of votes

    return {
        xaxis: {
            categories: rs.map((e) => e["answer"]),
            show: false,
        },
        series: [{
            data: rs.map((e) => e["count"])
        }],
        chart: {
            type: 'bar',
            height: 200,
            width: 500,
            background: 'null',
            toolbar: {
                show: false
            }
        },
        plotOptions: {
            bar: {
                borderRadius: 4,
                borderRadiusApplication: 'end',
                horizontal: true,
            }
        },
        dataLabels: {
            enabled: true,
            formatter: function (val, opt) {
                return opt.w.globals.labels[opt.dataPointIndex] + ":  " + val
              },
        },
        theme: {
            mode: "dark",
        },
    };

}

function choose_many_options(rs) {

    return {
        series: rs.map((e) => e["count"]),
        labels: rs.map((e) => e["answer"]),
        chart: {
            type: "pie",
            background: "null",
            width: 500,
            height: 500
        },
        theme: {
            mode: "dark"
        },
        dataLabels: {
            enabled: true,
            formatter: function (val) {
                return val + "%"
            },
        }

    }

}

// TODO: 
// - Compute average response
// - Add vertical line at user and average response
function scale_graph_options(rs, rs_kde) {
    // not in use at the moment but gonna keep until certain on kde implementation
    vals = parse_results(rs);
    // kde
    pts = parse_kde_results(rs_kde);

    return {
        xaxis: {
            type: 'numeric',
            categories: [...Array(rs_kde[0].length).keys()]
        },
        yaxis: {
            labels: {
                formatter: function (val) {
                    return "";
                }
            },
        },
        series: [{
            name: 'Scale Results',
            data: pts
        }],
        chart: {
            height: 350,
            type: 'area',
            background: "null",
            toolbar: {
                show: false
            },
            zoom: {
                enabled: false,
            }
        },
        dataLabels: {
            enabled: false
        },
        stroke: {
            curve: 'monotoneCubic'
        },
        tooltip: {
            custom: function ({ series, seriesIndex, dataPointIndex, w }) {
                return '<div class="arrow_box">' + '</div>'
            }

        },
        theme: {
            mode: "dark"
        }
    };

}

function tier_graph_options(rs) {

    // TODO: 
    // - Use classic tier list colour scheme 
    // - 
    temp_data = [
        { answer: "Item 1", S: 10, A: 8, B: 4, C: 0, D: 0, F: 0 },
        { answer: "Item 2", S: 0, A: 0, B: 0, C: 4, D: 10, F: 8 },
        { answer: "Item 3", S: 2, A: 8, B: 6, C: 6, D: 0, F: 0 },
        { answer: "Item 4", S: 4, A: 4, B: 4, C: 3, D: 5, F: 0 },
        { answer: "Item 5", S: 1, A: 0, B: 1, C: 0, D: 5, F: 15 },
        // { answer: "Item 6", S: 10, A: 0, B: 1, C: 1, D: 0, F: 10 },
        // { answer: "Item 7", S: 0, A: 1, B: 10, C: 10, D: 1, F: 0 },
        // { answer: "Item 8", S: 21, A: 1, B: 0, C: 0, D: 0, F: 0 },
        // { answer: "Item 9", S: 6, A: 11, B: 7, C: 0, D: 0, F: 0 },
        // { answer: "Item 10", S: 5, A: 10, B: 7, C: 0, D: 0, F: 0 },
    ]
    // Remove this and "temp_data" when "rs" is giving valid results
    rs = temp_data

    return {
        series: rs.map(answer => ({
            name: answer["answer"],
            data: [answer["S"], answer["A"], answer["B"], answer["C"], answer["D"], answer["F"]]
        }
        )),
        chart: {
            type: 'bar',
            height: 500,
            stacked: true,
            stackType: '100%', // Fills the width of the screen with a the stack of bars (I kinda fw this off)
            background: "null",
            toolbar: {
                show: false
            }

        },
        plotOptions: {
            bar: {
                horizontal: true,
            },
        },
        stroke: {
            width: 1,
            colors: ['#fff']
        },
        xaxis: {
            categories: ["S Tier", "A Tier", "B Tier", "C Tier", "D Tier", "F Tier"],
        },
        tooltip: {
            y: {
                formatter: function (val) {
                    return val;
                }
            }
        },
        legend: {
            position: 'top',
            horizontalAlign: 'left',
            offsetX: 40
        },
        theme: {
            mode: "dark"
        }
    };

}

// Helpers for formatting the data into something that can be graphed
function parse_results(rs) {
    var vals = Array(101).fill(0);
    for (let i = 0; i < rs.length; i++) vals[rs[i]["value"]] = rs[i]["count"];
    return vals;
}

function parse_kde_results(rs_kde) {
    let pts = [];
    for (let j = 0; j < rs_kde[0].length; j++) pts.push({ x: rs_kde[0][j], y: rs_kde[1][j] });
    return pts;
}
