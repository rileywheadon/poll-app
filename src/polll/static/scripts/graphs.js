// I know I know
cols = {
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
    'polll-grad-1': '#D9EAD3',
    'polll-green': '#B6D7A8',
    'polll-grad-3':'#A0CFB6',
    'polll-grad-4':'#97D0BF',
    'polll-grad-5':'#92D0D0',
    'polll-blue':'#88bbd0'
}

function graphInit(type, poll_id, user_rs=null, rs = null, rs_kde = null) {
    var choose_one_graph, choose_many_graph, scale_graph, tier_graph, i, func;
    var graphs = [choose_one_graph, choose_many_graph, scale_graph, tier_graph];
    ["load", "htmx:afterSettle"].forEach((e) => {
        window.addEventListener(e, () => {
            switch (type.toLowerCase()) {
                case "choose one":
                    i = 0;
                    func = choose_one_options(user_rs, rs);
                    break;
                case "choose many":
                    i = 1;
                    func = choose_many_options(user_rs, rs);
                    break;
                case "scale":
                    i = 2;
                    func = scale_graph_options(user_rs, rs, rs_kde);
                    break;
                case "tier":
                     i = 3;
                     func = tier_graph_options(user_rs, rs);
                    break;
            }            
            graphs[i] instanceof ApexCharts ? graphs[i].destroy() : graphs[i] = new ApexCharts(document.getElementById(`poll-graph-${poll_id}`), func);
            graphs[i].render();
        })
    })

}

function choose_one_options(user_rs, rs) {

    user_rs ? user_rs = user_rs["answer"] : user_rs = "";
    
    var total_answers = rs.map((e) => e["count"]).reduce((acc, i) => acc + i, 0);

    return {
        grid: {
            show: false,
        },
        xaxis: {
            categories: rs.map((e) => e["answer"]),
            labels: {
                formatter: function (val) {
                    return val;
                }
            },
            max: 100,
        },
        yaxis: {
            labels: {
                formatter: function (val) {
                    return "";
                }
            },
        },
        series: [{
            name: "",
            data: rs.map((e) => e["count"] / total_answers * 100)
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
                return opt.w.globals.labels[opt.dataPointIndex] + ":  " + Math.round(val) + "%";
              },
        },
        colors: [function({ value, seriesIndex, dataPointIndex, w }) {
            return dataPointIndex == rs.map((e) => e["answer"]).indexOf(user_rs) ? "#7E36AF" : "#D9534F";
          }],
        theme: {
            mode: "dark",
        },
        tooltip: {
            enabled: true,
            y: {
                formatter: (val) => {
                    return Math.round(val * total_answers / 100);
                }
            }
        }
    };

}

function choose_many_options(user_rs, rs) {

    user_rs ? user_rs = user_rs.map((e) => e["answer"]) : user_rs = "";

    return {
        series: rs.map((e) => e["count"]),
        labels: rs.map((e) => e["answer"]),
        chart: {
            type: "pie",
            background: "null",
            width: 500,
            height: 500,
        },
        theme: {
            mode: "dark",
        },
        dataLabels: {
            enabled: true,
            formatter: function (val) {
                return Math.round(val) + "%"
            },
        },
        colors: [function({ value, seriesIndex, dataPointIndex, w }) {
            if (value == 0) return "#808080";
            for (i = 0; i < user_rs.length; i++) if (dataPointIndex == w.globals.labels.indexOf(user_rs[i])) return "#7E36AF";
            return "#D9534F";
          }],
          fill: {
            colors: [function({ value, seriesIndex, w }) {
                for (i = 0; i < user_rs.length; i++) if (seriesIndex == w.globals.labels.indexOf(user_rs[i])) return "#7E36AF";
                return "#D9534F";
              }],
          },
    }

}

function scale_graph_options(user_rs, rs, rs_kde) {

    user_rs ? user_rs = user_rs["value"] : user_rs = -1;

    var pts = parse_kde_results(rs_kde);
    var average_rs = get_scale_average(rs, rs_kde[1].length);

    return  {
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
                    x: average_rs,
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
                    x: average_rs,
                    y: rs_kde[1][Math.round(average_rs / 100 * rs_kde[1].length)],
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
                    y: rs_kde[1][Math.round(user_rs / 100 * rs_kde[1].length)],
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

function tier_graph_options(user_rs, rs) {

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
        // Not working atm - outputing polll gradient
        colors: get_col_gradient("#D9EAD3", "#88bbd0", rs.length),
        theme: {
            mode: "dark",
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
    for (let j = 0; j < rs_kde[0].length; j++) pts.push({ x: rs_kde[0][j], y: rs_kde[1][j] <= Math.pow(10, -6) ? Math.pow(10, -6) : rs_kde[1][j]});
    return pts;
}

function format_sci_notation(vals) {
    var pts = [];
    vals.forEach((e) => {
        var s = e.toString();
        if (s.includes("e-")) s = "0." + new Array(Number(s.substring(s.indexOf("e-") + 2))).join("0") + s.substring(0, s.indexOf("e")).replace(".", "");
        pts.push(s);
    });
    return pts;
}

function get_scale_average(rs, nums) {
    var counts = rs.map((e) => e["count"]);
    var x = rs.map((e) => e["value"]).reduce((acc, curr, i) => acc + (curr * counts[i]), 0) / counts.reduce((acc, curr) => acc + curr);
    return [...Array(nums).keys()].reduce((prev, curr) => {
     return (Math.abs(curr - x) < Math.abs(prev - x) ? curr : prev)});
}

// A list of colours representing a gradient from "from_col" to "to_col" of length "num_col"
function get_col_gradient(from_col, to_col, num_col) {
    // TODO: implement
    // return ['#F44336', '#E91E63', '#9C27B0'];
    return [cols["polll-grad-1"], cols["polll-green"], cols["polll-grad-3"], cols["polll-grad-4"], cols["polll-grad-5"], cols["polll-blue"]] // I don't like this
}
