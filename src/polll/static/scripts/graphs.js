const cols = {
    'polll-green': '#B6D7A8',
    'polll-dark-green': '#6aa84f',
    'polll-blue':'#88bbd0',
    'polll-white': '#f3f3f3ff',
}

const bp = 768;
const graph_height = 300;


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
  console.log(toggle.childElementCount);

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
    var user_col = localStorage.getItem("theme") == "dark" ? cols["polll-green"] : cols["polll-dark-green"];



    // PIE CHART (default)
    if (type == "pie") {
        return {
            series: rs.map((e) => e["count"]),
            labels: rs.map((e) => e["answer"] == user_rs ? e["answer"] + " (you)" : e["answer"]),
            chart: {
                type: "pie",
                background: "null",
                width: "100%",
                height: graph_height,
            },
    
            theme: {
                mode: "dark",
            },
    
            dataLabels: {
                enabled: true,
                dropShadow: {
                    enabled: false
                },
                style: {
                    fontSize: '16px',
                    fontFamily: 'Helvetica, Arial, sans-serif',
                    fontWeight: 'medium',
                    colors: ["#171717"]
                },
                formatter: function (val) {
                    return Math.round(val) + "%"
                },
            },
            colors: [function({ value, seriesIndex, dataPointIndex, w }) {
                if (value == 0) return "#808080";
                return w.globals.labels[seriesIndex].includes("(you)") ? user_col : cols["polll-blue"];
              }],
              fill: {
                colors: [function({ value, seriesIndex, w }) {
                    return w.globals.labels[seriesIndex].includes("(you)") ? user_col : cols["polll-blue"];
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
                height: graph_height,
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
                return dataPointIndex == rs.map((e) => e["answer"]).indexOf(user_rs) ? user_col : cols["polll-blue"];
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
    var user_col = localStorage.getItem("theme") == "dark" ? cols["polll-green"] : cols["polll-dark-green"];

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
                height: graph_height,
                toolbar: {
                    show: false
                },
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
                    const label = i + ": " + Math.round(val);
                    return user_rs.includes(i) ? label + " (you)" : label;
                  },
            },
            colors: [function({ value, seriesIndex, dataPointIndex, w }) {
                console.log(w.globals.labels[dataPointIndex]);

                return user_rs.includes(w.globals.labels[dataPointIndex]) ? user_col : cols["polll-blue"];
              }],

            tooltip: {
                enabled: true,
                y: {
                    formatter: function(val, { series, seriesIndex, dataPointIndex, w }) {
                        return val;
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
            height: graph_height,
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
            for (i = 0; i < user_rs.length; i++) if (dataPointIndex == w.globals.labels.indexOf(user_rs[i])) return user_col;
            return cols["polll-blue"];
          }],
          fill: {
            colors: [function({ value, seriesIndex, w }) {
                for (i = 0; i < user_rs.length; i++) if (seriesIndex == w.globals.labels.indexOf(user_rs[i])) return user_col;
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
    var user_col = localStorage.getItem("theme") == "dark" ? cols["polll-green"] : cols["polll-dark-green"];

    // This is a bit of a hack but if it works it works
    answers["left"] && answers["right"] ? endpoints = [answers["left"]["answer"], answers["right"]["answer"]] : endpoints = null;

    return  {
        grid: {
            show: false,
        },
        xaxis: {
            type: 'numeric',
            tooltip: {
                enabled: false
            },
            labels: {
                style: {
                    fontSize: "14px",
                    fontWeight: "bold"
                },
                formatter: function (val) {
                    if (endpoints) {
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
            height: graph_height,
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
                    borderColor: user_col,
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
