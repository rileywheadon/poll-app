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

// Global variable for the current chart
var active_chart = null;

// Global event listener for creating a new graph
function add_graph_listener() {
  document.body.addEventListener("graph", function(evt) { 
    graphToggle(evt.detail);
  });
}

// Results Toggling Function
function graphToggle(poll) {
  
  // Destroy the active chart, if it exists
  if (active_chart != null) {
    active_chart.destroy();
  }

  // Get elements from the DOM
  var toggle = document.getElementById(`graph-toggle-${poll["id"]}`);
  var graph = document.getElementById(`poll-graph-${poll["id"]}`);

  // If we are hiding results, just hide the graph and return
  if (toggle.innerHTML == "Hide Results") {
    toggle.innerHTML = "Show Results";
    graph.classList.add("hidden");
    return;
  } 

  // Hide all of the other graphs
  graphs = document.getElementsByClassName("graph-toggle");
  for (var i = 0; i < graphs.length; i++) {
    id = graphs[i].getAttribute("id").substr(13);
    document.getElementById("graph-toggle-" + id).innerHTML = "Show Results";
    document.getElementById("poll-graph-" + id).classList.add("hidden");
  }

  // Then update toggle and graph
  toggle.innerHTML = "Hide Results";
  graph.classList.remove("hidden");

  // Create a "No votes yet!" message if the poll has no votes
  if (poll["response_count"] == 0) {
    var votes = document.createElement("p");
    const votes_message = document.createTextNode("No votes yet!");
    votes.appendChild(votes_message);
    graph.appendChild(votes);
  } 

  // Unhide the results if the poll is ranked or tier list
  else if (["RANKED_POLL", "TIER_LIST"].includes(poll["poll_type"])) {
    result = document.getElementById("poll-result-" + poll["id"]);
    result.classList.remove("hidden");
  }

  // Draw the graph if necessary
  else {
    graphInitRewritten(poll);
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
      options = scale_graph_options(poll);
      break;
  }

  active_chart = new ApexCharts(graph, options);
  active_chart.render();

}

function choose_one_options(user_rs, rs, type="pie") {

    user_rs ? user_rs = user_rs["answer"] : user_rs = "";
    
    var total_answers = rs.map((e) => e["count"]).reduce((acc, i) => acc + i, 0);


    // PIE CHART (default)
    if (type == "pie") {
        return {
            series: rs.map((e) => e["count"]),
            labels: rs.map((e) => e["answer"] == user_rs ? e["answer"] + " (you)" : e["answer"]),
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
                return w.globals.labels[seriesIndex].includes("(you)") ? cols["polll-green"] : cols["polll-blue"];
              }],
              fill: {
                colors: [function({ value, seriesIndex, w }) {
                    return w.globals.labels[seriesIndex].includes("(you)") ? cols["polll-green"]: cols["polll-blue"];
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


    // BAR CHART
    else {
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
                            type: "bar",
                            background: "null",
                            width: bp,
                            height: bp,
                        },
                    },
                },
            }],
        };
    }

}

function choose_many_options(user_rs, rs, type="bar") {

    user_rs == {} ? user_rs = "" : user_rs = user_rs.map((e) => e["answer"]);

    if (type == "bar") {
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
                data: rs.map((e) => e["count"])
            }],
            chart: {
                type: 'bar',
                background: 'null',
                width: bp,
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
                    const i = opt.w.globals.labels[opt.dataPointIndex];
                    const lbl = i + ": " + Math.round(val);
                    return user_rs.includes(i) ? lbl + " (you)" : lbl; // colours might be enough?
                  },
            },
            colors: [function({ value, seriesIndex, dataPointIndex, w }) {
                console.log(w.globals.labels[dataPointIndex]);

                return user_rs.includes(w.globals.labels[dataPointIndex]) ? cols["polll-green"] : cols["polll-blue"];
              }],

            tooltip: {
                enabled: true,
                y: {
                    formatter: function(val, { series, seriesIndex, dataPointIndex, w }) {
                        return val; // lbl w/ user_rs
                      }
                }
            },
            theme: {
                mode: "dark"
            },
            responsive: [{
                breakpoint: bp,
                options: {
                    chart: {
                        chart: {
                            type: "bar",
                            background: "null",
                            width: bp,
                            height: bp,
                        },
                    },
                },
            }],
    
        }
    }

    else {

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

}

// I'm just passing in the entire poll because there's too many arguments
function scale_graph_options(poll) {

    // Unpack Arguments
    user_rs = poll["response"]
    rs = poll["results"]
    rs_kde = poll["kde"]
    answers = poll["answers"]

    // Rest of the function should be untouched
    user_rs ? user_rs = user_rs["value"] : user_rs = -1;
    var pts = parse_kde_results(rs_kde);
    var average_rs = get_scale_average(rs, rs_kde[1].length);

    // This is a bit of a hack but if it works it works
    if (answers) {
      endpoints = [answers["left"], answers["right"]];
    }

    return  {
        grid: {
            show: false,
        },
        xaxis: {
            type: 'numeric',
            labels: {
                style: {
                    fontSize: "14px",
                    fontWeight: "bold"
                },
                formatter: function (val) {
                    if (endpoints.length != 0) {
                        if (val == 0) return endpoints[0];
                        if (Math.round(val) == 100) return endpoints[1];
                       return "";
                    }
                    else return Math.round(val)
                }
            },
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
                return ""
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
