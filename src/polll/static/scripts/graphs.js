function choose_one_graph(element, data, theme, title="Title", label_x="x-axis", label_y="y-axis") {
    return new Chart(element, {
        type: "line",
        data: {
            labels: data[0],
            datasets: [{
                label: label_y,
                fill: true,
                lineTension: 0.3,
                borderColor: theme,
                
                data: data[1],
            }]
        },
        options: {
            title: {
                display: true,
                text: title,
                fontSize: 24,
                fontColor: theme
            },
            legend: {display: false},
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    })
}


// shows the graph on page refresh and re-entering the page without a load
["load", "htmx:afterSettle"].forEach((e) => 
    window.addEventListener(e, () => {
        choose_one_graph(document.getElementById("choose-one-graph"), [[1, 2, 3, 4, 5], [6, 4, 5, 7, 4]], "pink", "Choose One Results");
    }
))

