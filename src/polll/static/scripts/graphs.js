// I know I know
cols = {
    /* Tailwind-like Nord color names */
    'nord-0': '#2E3440',
    'nord-1': '#3B4252',
    'nord-2': '#434C5E',
    'nord-3': '#4C566A',
    'nord-4': '#D8DEE9',
    'nord-5': '#E5E9F0',
    'nord-6': '#ECEFF4',
    'nord-7': '#8FBCBB',
    'nord-8': '#88C0D0',
    'nord-9': '#81A1C1',
    'nord-10': '#5E81AC',
    'nord-11': '#BF616A',
    'nord-12': '#D08770',
    'nord-13': '#EBCB8B',
    'nord-14': '#A3BE8C',
    'nord-15': '#B48EAD',
    'grad-start': '#1f1f1f',
    'grad-end': '#171717',
    'polll-grad-1': '#D9EAD3', //polll logo gradient follows these 6 colors
    'polll-green': '#B6D7A8', // this is the custom green to be used on icons
    'polll-grad-3':'#A0CFB6',
    'polll-grad-4':'#97D0BF',
    'polll-grad-5':'#92D0D0',
    'polll-blue':'#88bbd0' // this is the custom blue to be used on icons
}

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

function choose_one_options(rs) {


    temp_data = [
        ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"], 
        [40, 25, 60, 10, 15]
    ]

    var total_answers = rs.map((e) => e["count"]).reduce((acc, i) => acc + i, 0);
    return {
        grid: {
            show: false,
        },
        xaxis: {
            // categories: rs.map((e) => e["answer"]),
            categories: temp_data[0],
            labels: {
                formatter: function (val) {
                    return val + "%";
                }
            },
        },
        yaxis: {
            labels: {
                formatter: function (val) {
                    return val;
                }
            },
        },
        series: [{
            // data: rs.map((e) => e["count"] / total_answers * 100)
            data: temp_data[1].map((e) => Math.round(e / temp_data[1].reduce((acc, i) => acc + i, 0) * 100))
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
                return opt.w.globals.labels[opt.dataPointIndex] + ":  " + val + "%";
              },
        },
        theme: {
            mode: "dark",
            palette: 'palette2',
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
            mode: "dark",
        },
        dataLabels: {
            enabled: true,
            formatter: function (val) {
                return val + "%"
            },
        }
    }

}

function scale_graph_options(rs, rs_kde) {
    // not in use at the moment but gonna keep until certain on kde implementation
    vals = parse_results(rs);
    // kde
    pts = parse_kde_results(rs_kde);

    var average_rs = get_scale_average(rs_kde[1]);
    var user_rs = 10; // still need actual value from database

    return {
        grid: {
            show: false,
        },
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
            curve: 'monotoneCubic',
            width: 5
        },
        tooltip: {
            custom: function ({ series, seriesIndex, dataPointIndex, w }) {
                return '<div class="arrow_box">' + '</div>'
            }

        },
        theme: {
            mode: "dark"
        },
        annotations: {
            xaxis: [{
                    x: average_rs[0],
                    strokeDashArray: 0,
                    borderColor: "#88bbd0",
                    borderWidth: 3,
                    label: {
                        show: false,
                    }
                }, {
                    x: user_rs,
                    strokeDashArray: 0,
                    borderColor: "#B6D7A8",
                    borderWidth: 3,
                    label: {
                        show: false,   
                    }
                }],
                points: 
                [
                  {
                    x: average_rs[0],
                    y: average_rs[1],
                    marker: {
                        size: 8,
                        fillColor: "#ffffff",
                        strokeColor: "#000000",
                        radius: 2,
                        cssClass: 'apexcharts-custom-class'
                      },
                      label: {
                        style: {
                          color: "#ffffff",
                          background: "null",
                        },
                        text: "Average Response",
                      }
                  },
                  {
                    x: user_rs,
                    y: rs_kde[1][user_rs],
                    marker: {
                        size: 8,
                        fillColor: "#ffffff",
                        strokeColor: "#000000",
                        radius: 2,
                        cssClass: 'apexcharts-custom-class'
                      },
                      label: {
                        style: {
                          color: "#ffffff",
                          background: "null",
                        },
                        text: "You",
                      }
                  },

                ]
        },
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
        { answer: "Item 6", S: 10, A: 0, B: 1, C: 1, D: 0, F: 10 },
        // { answer: "Item 7", S: 0, A: 1, B: 10, C: 10, D: 1, F: 0 },
        // { answer: "Item 8", S: 21, A: 1, B: 0, C: 0, D: 0, F: 0 },
        // { answer: "Item 9", S: 6, A: 11, B: 7, C: 0, D: 0, F: 0 },
        // { answer: "Item 10", S: 5, A: 10, B: 7, C: 0, D: 0, F: 0 },
    ]
    // Remove this and "temp_data" when "rs" is giving valid results
    rs = temp_data

    return {
        grid: {
            show: false,
        },
        xaxis: {
            categories: ["S Tier", "A Tier", "B Tier", "C Tier", "D Tier", "F Tier"],
            labels: {
                formatter: function (val) {
                    return val + "%";
                }
            },
        },
        series: rs.map(answer => ({
            name: answer["answer"],
            data: [answer["S"], answer["A"], answer["B"], answer["C"], answer["D"], answer["F"]]
        }
        )),
        chart: {
            type: 'bar',
            height: 500,
            stacked: true,
            stackType: '100%',
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
        tooltip: {
            y: {
                formatter: function (val) {
                    return val + "%";
                }
            }
        },
        legend: {
            position: 'top',
            horizontalAlign: 'left',
            offsetX: 40
        },
        // Not working atm - outputting polll gradient
        //colors: get_col_gradient("#D9EAD3", "#88bbd0", rs.length),
        theme: {
            mode: "dark",
            palette: "palette10"
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

// This "works" but is really dumb and is techincally flawed
function get_scale_average(rs) {
    var y = rs.reduce((acc, i) => acc + i, 0) / rs.length;
    return [rs.indexOf(rs.reduce((prev, curr) => {
         return (Math.abs(curr - y) < Math.abs(prev - y) ? curr : prev)})), y]
}

// A list of colours representing a gradient from "from_col" to "to_col" of length "num_col"
function get_col_gradient(from_col, to_col, num_col) {
    // TODO: implement
    // return ['#F44336', '#E91E63', '#9C27B0'];
    return [cols["polll-grad-1"], cols["polll-green"], cols["polll-grad-3"], cols["polll-grad-4"], cols["polll-grad-5"], cols["polll-blue"]] // I don't like this
}