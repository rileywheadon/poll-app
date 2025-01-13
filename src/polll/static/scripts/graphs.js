// Landing function so that the data in the jinja template can be used in a js file 
// (jinja syntax isn't supported in exteneral js files as far as I'm aware)

// TODO: 
// - Generally improve look of graph for both dark and light mode
// - When hovering with the mouse over a line graph, hide the 
//   actual y value as it doesn't correspond to the true number of votes
//   due to the normalization from the Gaussian kde
// - add another paramater graphInit() corresponding to the desired graph
//   and make it call a seperate function (which all have to be made as well)

function graphInit(rs, rs_kde) {
// shows the graph on page refresh and re-entering the page without a load
["load", "htmx:afterSettle"].forEach((e) => 
    window.addEventListener(e, () => {
        // not in use at the moment but gonna keep until certain on kde implementation
        var vals = Array(101).fill(0);
        for (let i = 0; i < rs.length; i++) vals[rs[i]["value"]] = rs[i]["count"];

        // kde
        let pts = [];
        for (let i = 0; i < rs_kde[0].length; i++) pts.push({x: rs_kde[0][i], y: rs_kde[1][i]});

        new Chart(document.getElementById("scale-graph"), {
          type: "line",
          data: {
            labels: [...Array(rs_kde[0].length).keys()], // x-values (no need to get from database)
              datasets: [{
                  label: "y-axis",
                  fill: true,
                  lineTension: 0.3,
                  borderColor: "#ffffff",
                  data: pts,
              }]
          },
          options: {
              title: {
                  display: true,
                  text: "Title",
                  fontSize: 24,
                  fontColor: "#ffffff"
              },
              legend: {display: false},
              scales: {
                  y: {
                      beginAtZero: true
                  }
              }
          }
      }
  
      )
    }
))
}

