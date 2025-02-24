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

function choose_one_options(user_rs, rs) {

    user_rs ? user_rs = user_rs["answer"] : user_rs = "";
    var user_col = localStorage.getItem("theme") == "dark" ? cols["polll-green"] : cols["polll-dark-green"];

    var num_answers = rs.length;
    var gradient = graphColors(num_answers);


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

        stroke: {
            width: 0.75
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
            let labels = w.globals.labels;
            let youIndex = labels.findIndex(label => label.includes("(you)")); // Find where "(you)" is
            let newIndex = (seriesIndex - youIndex + gradient.length) % gradient.length; // Shift colors

            return labels[seriesIndex].includes("(you)") ? user_col : gradient[newIndex];
        }],

        fill: {
            colors: [function({ value, seriesIndex, w }) {
                let labels = w.globals.labels;
                let youIndex = labels.findIndex(label => label.includes("(you)")); // Find where "(you)" is
                let newIndex = (seriesIndex - youIndex + gradient.length) % gradient.length; // Shift colors

                return labels[seriesIndex].includes("(you)") ? user_col : gradient[newIndex];
            }],
        },
          
    }
}

function choose_many_options(user_rs, rs) {

    user_rs == null ? user_rs = "" : user_rs = user_rs.map((e) => e["answer"]);
    var user_col = localStorage.getItem("theme") == "dark" ? cols["polll-green"] : cols["polll-dark-green"];

    var cm_num_answers = rs.length+1;
    var gradient = graphColors(cm_num_answers);

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
            return user_rs.includes(w.globals.labels[dataPointIndex]) ? user_col : gradient[dataPointIndex];
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

// this finally fucking works
function graphColors(num_answers) {

    // creating list
    rgb_list = [];

    // defining the "hooks" of our gradient
    const rgbPolll_Blue = [136, 187, 208];// Polll_Blue, Hex is #88bbd0
    const rgbGrad_Blue = [100, 137, 255]; //Hex is #6489ff

    // vars
    div = num_answers-1;

    // makes 1 less than total answers
    for (i = 1; i < num_answers; i++) {
        col = [];
        cyc = i-1;
        //fix cycle

        col.push(rgbGenerator(rgbPolll_Blue[0], rgbGrad_Blue[0], div, cyc));
        col.push(rgbGenerator(rgbPolll_Blue[1], rgbGrad_Blue[1], div, cyc));
        col.push(rgbGenerator(rgbPolll_Blue[2], rgbGrad_Blue[2], div, cyc));
        rgb_list.push(col);
    }

    // tests
    console.log(rgb_list);
    console.log(hexList(rgb_list));

    // transfering the list into hex
    return hexList(rgb_list);
}

// returns the in between value for any of r, g, b
function rgbGenerator(startCol, endCol, divisor, cycle) {
    diff = startCol - endCol;
    return Math.round(startCol - ((diff / divisor) * cycle));
}

// creates a list of hex values from an rgb list
function hexList(col_list) {
    hex_list = [];
    reps = col_list.length;
    for (i = 0; i < reps; i++) {
        hex_list.push(rgbToHex(col_list[i]));
    }
    return hex_list;
}

// ripped these out of StackOverFlow i cant lie
function componentToHex(c) {
    var hex = c.toString(16);
    return hex.length == 1 ? "0" + hex : hex;
}
function rgbToHex(rgb) {
    return "#" + componentToHex(rgb[0]) + componentToHex(rgb[1]) + componentToHex(rgb[2]);
}


// unused iggy work
// colors
    // const rgbOldGrad_Blue = [72, 158, 255]; // Hex is, #489EFF
    // const rgbGrad_Green = [55, 190, 51]; // Hex is, #37BE33
    // const rgbPolll_Green = [182, 215, 168]; // Polll_Green, Hex is #B6D7A8
// for loop gradient maker
    // for (i = 1; i < amt; i++) {
    //     col = [];
    //     cyc = Math.ceil(i/3)-1
    //     if ((i % 3) == 1) {
    //         col.push(rgbGenerator(rgbPolll_Blue[0], rgbGrad_Blue[0], div, cyc));
    //         col.push(rgbGenerator(rgbPolll_Blue[1], rgbGrad_Blue[1], div, cyc));
    //         col.push(rgbGenerator(rgbPolll_Blue[2], rgbGrad_Blue[2], div, cyc));
    //     } else if ((i % 3) == 2) {
    //         col.push(rgbGenerator(rgbGrad_Blue[0], rgbGrad_Green[0], div, cyc));
    //         col.push(rgbGenerator(rgbGrad_Blue[1], rgbGrad_Green[1], div, cyc));
    //         col.push(rgbGenerator(rgbGrad_Blue[2], rgbGrad_Green[2], div, cyc));
    //     } else if ((i % 3) == 0) {
    //         col.push(rgbGenerator(rgbGrad_Green[0], rgbPolll_Green[0], div, cyc));
    //         col.push(rgbGenerator(rgbGrad_Green[1], rgbPolll_Green[1], div, cyc));
    //         col.push(rgbGenerator(rgbGrad_Green[2], rgbPolll_Green[2], div, cyc));
    //     }
    //     rgb_list.push(col);
    // }
