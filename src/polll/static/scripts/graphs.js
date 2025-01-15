// TODO: 
// - Generally improve look of graph for dark and light mode
// - When hovering with the mouse over a line graph, hide the 
//   actual y value as it doesn't correspond to the true number of votes
//   due to the normalization from the Gaussian kde
// - If tier/rank is using Apex Charts it makes sense use it here too


// FIX: 
// - clicking the history tab creates a new graph with identical data below
//   the current one and is removed on a page refresh


// landing funciton for every graph type so that the data in the 
// Jinja template can be used in a js file as well as so there is
//  only one event listener in this file
// (Jinja isn't supported in exteneral .js files as far as I'm aware)
function graphInit(type, poll_id, rs=null, rs_kde=null) {

    // Reset the graph element
    var graph = document.getElementById("poll-graph-" + poll_id);
    if (graph) {
        console.log("graph exists")
        graph.innerHTML = "";
    }



    // Create a new graph element
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
                case "tier":
                    make_tier_graph(poll_id, rs);
                    break;
            }
        })
    })
}


// TOOD: add a 'theme' parameter to the parent function
//  and let it determine the colour scheme

function make_choose_one_graph(poll_id, rs) {

    var options = {
        xaxis: {
            categories: rs.map((e) => e["answer"]),
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
        enabled: false
      },
      theme: {
        mode: "dark",
      },
      };

    new ApexCharts(document.getElementById(`poll-graph-${poll_id}`), options).render();

}

function make_choose_many_graph(poll_id, rs) {

    var options = {
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
    new ApexCharts(document.getElementById(`poll-graph-${poll_id}`), options).render();

}

// TODO: 
// - Compute average response
// - Add vertical line at user and average response
function make_scale_graph(poll_id, rs, rs_kde) {
    // not in use at the moment but gonna keep until certain on kde implementation
    vals = parse_results(rs);
    // kde
    pts = parse_kde_results(rs_kde);

    var options = {
        xaxis: {
            type: 'numeric',
            categories: [...Array(rs_kde[0].length).keys()]
        },
        yaxis: {
            labels: {
              formatter: function (value) {
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
        custom: function({series, seriesIndex, dataPointIndex, w}) {
            return '<div class="arrow_box">' + '</div>'
          }
        
      },
      theme: {
        mode: "dark"
        }
      };

    new ApexCharts(document.getElementById(`poll-graph-${poll_id}`), options).render();

}

// https://apexcharts.com/javascript-chart-demos/bar-charts/stacked/
function make_tier_graph(poll_id, rs) {

    // Use classic tier list colour scheme

    temp_data = [
        {answer: "Item 1", S: 10, A: 8, B: 4, C: 0, D: 0, F: 0},
        {answer: "Item 2", S: 0, A: 0, B: 0, C: 4, D: 10, F: 8},
        {answer: "Item 3", S: 2, A: 8, B: 6, C: 6, D: 0, F: 0},
        {answer: "Item 4", S: 4, A: 4, B: 4, C: 3, D: 5, F: 0},
        {answer: "Item 5", S: 1, A: 0, B: 1, C: 0, D: 5, F: 15},
        {answer: "Item 6", S: 10, A: 0, B: 1, C: 1, D: 0, F: 10},
        {answer: "Item 7", S: 0, A: 1, B: 10, C: 10, D: 1, F: 0},
        {answer: "Item 8", S: 21, A: 1, B: 0, C: 0, D: 0, F: 0},
        {answer: "Item 9", S: 6, A: 11, B: 7, C: 0, D: 0, F: 0},
        {answer: "Item 10", S: 5, A: 10, B: 7, C: 0, D: 0, F: 0},
    ]


    var answers = []

    for (let i = 0; i < temp_data.length; i++) {
        answers.push({
            name: temp_data[i]["answer"],
            data: [temp_data[i]["S"], temp_data[i]["A"], temp_data[i]["B"], temp_data[i]["C"], temp_data[i]["D"], temp_data[i]["F"]]
        })
    }

    var options = {
        series: answers,
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
      title: {
        text: 'Tier List Results'
      },
      xaxis: {
        categories: ["S Tier", "A Tier", "B Tier", "C Tier", "D Tier", "F Tier", ],
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

    new ApexCharts(document.getElementById(`poll-graph-${poll_id}`), options).render();

}

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
