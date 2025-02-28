const cols = {
    'polll-green': '#B6D7A8',
    'polll-dark-green': '#6aa84f',
    'polll-blue':'#88bbd0',
    'polll-white': '#f3f3f3ff',
}

const bp = 768;
const graph_height = "60%";

// Global variable for the current chart
var active_chart = null;

// Global event listener for creating a new graph
function add_graph_listener() {
  document.body.addEventListener("graph", function(evt) { 
    handleGraphEvent(evt.detail);
  });
}

// Results Toggling Function
function handleGraphEvent(poll) {

    modal_text = get_modal_text(poll);
    graph = document.getElementById(`poll-graph${modal_text}-${poll["id"]}`);

    // If the modal is not being displayed
    if (!poll.elt.classList.contains("modal")) {
        // Destroy the active chart, if it exists
        if (active_chart != null) {
            active_chart.destroy();
        }

        toggle = document.getElementById(`graph-toggle-${poll["id"]}`);

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
    }

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
  else graphInit(poll);

}

function graphInit(poll) {

  var options;
  modal_text = get_modal_text(poll)

  graph = document.getElementById(`poll-graph${modal_text}-${poll["id"]}`);

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

function choose_one_options(user_rs, rs, annotation=null) {


    user_rs ? user_rs = user_rs["answer"] : user_rs = "";
    
    var user_col = localStorage.getItem("theme") == "dark" ? cols["polll-green"] : cols["polll-dark-green"];

    
    // PIE CHART (default)
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
            mode: localStorage.getItem("theme")
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
          
    }
}

function choose_many_options(user_rs, rs, annotation=null) {

    console.log(annotation)

    user_rs == null ? user_rs = "" : user_rs = user_rs.map((e) => e["answer"]);
    var user_col = localStorage.getItem("theme") == "dark" ? cols["polll-green"] : cols["polll-dark-green"];

    return {

        grid: {
            show: false,
            padding: { left: -5 }
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
            type: "bar",
            background: "null",
            width: "100%",
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
            mode: localStorage.getItem("theme")
        },

    }
}


function scale_graph_options(poll) {

    // Unpack Arguments
    user_rs = poll["response"]
    rs = poll["results"]
    rs_kde = poll["kde"]
    answers = poll["answers"]

    // If user_rs exists, set user_value and user_label
    user_value = -1;
    user_id = null;
    if (user_rs) { 
      user_value = user_rs["value"] 
      user_id = user_rs["user_id"]
    };  

    // Get KDE results, scale average, and theme
    var pts = parse_kde_results(rs_kde);
    var average_rs = get_scale_average(rs, rs_kde[1].length);
    const theme = localStorage.getItem("theme");
    var user_col = theme == "dark" ? cols["polll-green"] : cols["polll-dark-green"];

    // Get the endpoints, if they exist
    endpoints = null;
    if (answers) {
      endpoints = [answers["left"]["answer"], answers["right"]["answer"]] 
    }

    // Check TWO conditions on the annotation 
    //   1. Annotation is DIFFERENT from the logged in user
    //   2. Annotation exists (i.e. we are in the voter list)
    annotation = null;
    if (poll["annotation"] && user_id && poll["annotation"]["user_id"] != user_id) {
      annotation = poll["annotation"] 
    }

    // If the annotation object exists, create the voter_annotation graph element
    if (annotation) {
        voter_annotation = {
            x: annotation["value"],
            y: rs_kde[1][Math.round(annotation["value"] / 100 * rs_kde[1].length)],
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
                text: annotation["username"],
              }
          }
          voter_line = {
            x: annotation["value"],
            strokeDashArray: 0,
            borderColor: user_col,
            borderWidth: 3,
            label: {
                show: false,
            }
        } 
    } else {
        voter_annotation = {}
        voter_line = {}
    }

    return  {
        grid: {
            show: false,
            padding: { left: -5 }
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
            width: "100%",
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
            mode: localStorage.getItem("theme")
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
                    x: user_value,
                    strokeDashArray: 0,
                    borderColor: user_col,
                    borderWidth: 3,
                    label: {
                        show: false,   
                    }
                },
                voter_line
            ],
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
                    x: user_value,
                    y: rs_kde[1][Math.round(user_value / 100 * rs_kde[1].length)],
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
                  voter_annotation
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

function get_modal_text(poll) {
    return poll.elt.classList.contains("modal") ? "-modal" : "";
}
