// I know I know
const cols = {
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

const bps =  {
    'xs': '520px',
    'sm': '640px',
    'md': '768px',
    'lg': '1024px',
    'xl': '1536px',
  }

const bp = 768;

// Global charts object use to handle creating/destroying charts
var charts = {} 

// Results Toggling Function
function graphToggle(poll) {

  toggle = document.getElementById(`graph-toggle-${poll["id"]}`);
  graph = document.getElementById(`poll-graph-${poll["id"]}`);
  var btn_text = document.getElementById(`rs-btn-txt-${poll["id"]}`).innerHTML;
  
  btn_text == "Show Results" ? document.getElementById(`rs-btn-txt-${poll["id"]}`).innerHTML = "Hide Results" : document.getElementById(`rs-btn-txt-${poll["id"]}`).innerHTML = "Show Results";

  // NOTE: Behaviour if the poll has no votes
  if (poll["votes"] == 0) {

    var votes = document.createElement("p");
    const votes_message = document.createTextNode("No votes yet!");
    votes.appendChild(votes_message);

    btn_text == "Hide Results" ? graph.removeChild(graph.firstElementChild) : graph.insertBefore(votes, graph.firstElementChild);
    return

  }

  // NOTE: Behaviour for ranked poll / tier list
  if (poll["poll_type"] == "RANKED_POLL" || poll["poll_type"] == "TIER_LIST") {

    result = document.getElementById(`poll-result-${poll["id"]}`);

    btn_text == "Hide Results" ? result.classList.add("hidden") : result.classList.remove("hidden");

  }

  // NOTE: Behaviour for all other poll types
  else {
    if (poll["id"] in charts) {
      charts[poll["id"]].destroy();
      delete charts[poll["id"]];
    } else graphInitRewritten(poll);
  }
}

function graphInitRewritten(poll) {

  var options;
  graph = document.getElementById(`poll-graph-${poll["id"]}`);

  switch (poll["poll_type"]) {
    case "CHOOSE_ONE": 
      options = choose_one_options(poll["response"], poll["results"]);
      break;
    case "CHOOSE_MANY":
      options = choose_many_options(poll["response"], poll["results"]);
      break;
    case "NUMERIC_SCALE":
      options = scale_graph_options(poll["response"], poll["results"], poll["kde"]);
      break;
  }

  chart = new ApexCharts(graph, options);
  charts[poll["id"]] = chart;
  chart.render();
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
            background: 'null',
            width: "100%",
            height: 250,
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
            return dataPointIndex == rs.map((e) => e["answer"]).indexOf(user_rs) ? cols["polll-green"] : cols["polll-blue"];
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
        },
        responsive: [{
            breakpoint: bp,
            options: {
                chart: {
                    chart: {
                        type: "pie",
                        background: "null",
                        width: bp,
                        height: bp,
                    },
                },
            },
        }],
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
            width: "100%",
            height: 350,
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
            for (i = 0; i < user_rs.length; i++) if (dataPointIndex == w.globals.labels.indexOf(user_rs[i])) return cols["polll-green"];
            return cols["polll-blue"];
          }],
          fill: {
            colors: [function({ value, seriesIndex, w }) {
                for (i = 0; i < user_rs.length; i++) if (seriesIndex == w.globals.labels.indexOf(user_rs[i])) return cols["polll-green"];
                return cols["polll-blue"];
              }],
          },
          responsive: [{
            breakpoint: bp,
            options: {
                chart: {
                    chart: {
                        type: "pie",
                        background: "null",
                        width: bp,
                        height: bp,
                    },
                },
            },
        }],
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
        responsive: [{
            breakpoint: bp,
            options: {
                chart: {
                    chart: {
                        type: "pie",
                        background: "null",
                        width: bp,
                        height: bp,
                    },
                },
            },
        }],
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
