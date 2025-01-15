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
                case "rank":
                    make_rank_graph(poll_id, rs);
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

      var chart = new ApexCharts(document.getElementById(`poll-graph-${poll_id}`), options);
      chart.render();

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
    var chart = new ApexCharts(document.getElementById(`poll-graph-${poll_id}`), options);
    chart.render();

}


function make_scale_graph(poll_id, rs, rs_kde) {
    // not in use at the moment but gonna keep until certain on kde implementation
    // might 
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

      var chart = new ApexCharts(document.getElementById(`poll-graph-${poll_id}`), options);
      chart.render();

}


// Apex Charts stacked 100%, stacked with two bars for each entry:
// one for the user's vote and one for the average vote for that rank 
// (inlcude labels on the side for each vote with colour coding)
// https://apexcharts.com/javascript-chart-demos/bar-charts/stacked-100/

// might also be a pure html thing
function make_rank_graph(poll_id, rs) {

    console.log(rs);

    // make a sepearte series for each option
    var options = {
        series: [{
        name: 'Marine Sprite',
        data: [1, 1, 1, 1, 1, 1]
      }, {
        name: 'Striking Calf',
        data: [1, 1, 1, 1, 1, 1]
      }],
        chart: {
        type: 'bar',
        height: 350,
        stacked: true,
        stackType: '100%',
        background: "null" 
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
        text: '100% Stacked Bar'
      },
      xaxis: {
        categories: [2008, 2009, 2010, 2011, 2012, 2013, 2014],
        labels: {
            formatter: (value) => {
              return value;
            }
          },
      },
      tooltip: {
        y: {
          formatter: function (val) {
            return val + "K"
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
      },
    };

      var chart = new ApexCharts(document.getElementById(`poll-graph-${poll_id}`), options);
      chart.render();

}

// Use Apex Charts' stacked bar charts
// https://apexcharts.com/javascript-chart-demos/bar-charts/stacked/
function make_tier_graph(poll_id, rs) {}

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
