<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DonutChart.aspx.cs" Inherits="DataVisualizingUsingD3Charts.DonutChart" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8"/>
	<title>D3 Version 4 Charts</title>
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js" integrity="sha384-vFJXuSJphROIrBnz7yo7oB41mKfc8JzQZiCq4NCceLEaO4IHwicKwpJf9c9IpFgh" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css" integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb" crossorigin="anonymous" />
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js" integrity="sha384-alpBpkh1PFOepccYVYDB4do5UnbKysX5WZXm3XxPqe5iKTfUKjNkCk9SaVuEZflJ" crossorigin="anonymous"></script>
	<script src="https://d3js.org/d3.v4.min.js"></script>
    <%--Donut Chart CSS Start--%>
    <style>
        .pie {
          margin: 20px;
        }

        .pie text {
          font-family: "Verdana";
          fill: #888;
        }

        .pie .name-text{
          font-size: 1em;
        }

        .pie .value-text{
          font-size: 3em;
        }
    </style>
    <%--Donut Chart CSS End--%>
    <%--Bar Chart CSS Start--%>
    <style> 
        .bar { fill: #5877ad; }

        .barChartDiv{
	        font:14px sans-serif;
        }

        .toolTip {
            font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
            position: absolute;
            display: none;
            width: auto;
            height: auto;
            background: none repeat scroll 0 0 lightsteelblue;
            border: 0 none;
            border-radius: 8px 8px 8px 8px;
            box-shadow: -3px 3px 15px #4c4c4c;
            color: black;
            font: 10px sans-serif;
            padding: 5px;
            text-align: center;
        }
      </style>
    <%--Bar Chart CSS End--%>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
          <h1>D3 Charts Version 4+</h1>
          <div class="row">
            <div class="col-sm-6"  id="donutChart">
              <h4><small><b>Donut Chart</b></small></h4>
            </div>
            <div class="col-sm-6" id="chartDiv">
              <h4><small><b>Bar Chart</b></small></h4>
            </div>
          </div>
          <div class="col-lg-12" style="background-color:#64d1b2;">
            <asp:Label runat="server" ID="JsonLabel"></asp:Label>
          </div>
        </div>  
    </form>
    <%--ALWAYS PLACE CHARTS DATA FILL UP JSCRIPT AT LAST OF DOM CREATION ie.END OF BODY OR AFTER THE CHART SPACE IS DECLARED--%>
    
    <%--Donut Chart Script Start--%>
    <script>
        var text = "";
        var width = 300;
        var height = 300;
        var thickness = 40;
        var duration = 750;

        var radius = Math.min(width, height) / 2;
        var color = d3.scaleOrdinal(d3.schemeCategory10);

        var svg = d3.select("#donutChart")
            .append('svg')
            .attr('class', 'pie')
            .attr('width', width)
            .attr('height', height);

        var g = svg.append('g')
            .attr('transform', 'translate(' + (width / 2) + ',' + (height / 2) + ')');

        var arc = d3.arc()
            .innerRadius(radius - thickness)
            .outerRadius(radius);

        var pie = d3.pie()
            .value(function (d) { return d.value; })
            .sort(null);

        var path = g.selectAll('path')
            .data(pie(data))
            .enter()
            .append("g")
            .on("mouseover", function (d) {
                let g = d3.select(this)
                    .style("cursor", "pointer")
                    .style("fill", "black")
                    .append("g")
                    .attr("class", "text-group");

                g.append("text")
                    .attr("class", "name-text")
                    .text(`${d.data.name}`)
                    .attr('text-anchor', 'middle')
                    .attr('dy', '-1.2em');

                g.append("text")
                    .attr("class", "value-text")
                    .text(`${d.data.value}`)
                    .attr('text-anchor', 'middle')
                    .attr('dy', '.6em');
            })
            .on("mouseout", function (d) {
                d3.select(this)
                    .style("cursor", "none")
                    .style("fill", color(this._current))
                    .select(".text-group").remove();
            })
            .append('path')
            .attr('d', arc)
            .attr('fill', (d, i) => color(i))
            .on("mouseover", function (d) {
                d3.select(this)
                    .style("cursor", "pointer")
                    .style("fill", "#707684");
            })
            .on("mouseout", function (d) {
                d3.select(this)
                    .style("cursor", "none")
                    .style("fill", color(this._current));
            })
            .each(function (d, i) { this._current = i; });


        g.append('text')
            .attr('text-anchor', 'middle')
            .attr('dy', '.35em')
            .text(text);
    </script>  
    <%--Donut Chart Script End--%>
    <%--Bar Chart Script Start--%>
    <script>        
        // set the dimensions and margins of the graph
        var margin = { top: 20, right: 20, bottom: 30, left: 50 },
            width = 350 - margin.left - margin.right,
            height = 300 - margin.top - margin.bottom;

        // set the ranges
        var x = d3.scaleBand()
            .range([0, width])
            .padding(0.1);
        var y = d3.scaleLinear()
            .range([height, 0]);

        // append the svg object to the body of the page
        // append a 'group' element to 'svg'
        // moves the 'group' element to the top left margin
        var svg = d3.select("#chartDiv").append("svg")
            .attr("width", width + margin.left + margin.right)
            .attr("height", height + margin.top + margin.bottom)
            .append("g")
            .attr("transform",
            "translate(" + margin.left + "," + margin.top + ")");

        var tooltip = d3.select("body").append("barChartDiv").attr("class", "toolTip");

        // format the data
        data.forEach(function (d) {
            d.value = +d.value;
        });

        // Scale the range of the data in the domains
        x.domain(data.map(function (d) { return d.name; }));
        y.domain([0, d3.max(data, function (d) { return d.value; })]);

        // append the rectangles for the bar chart
        svg.selectAll(".bar")
            .data(data)
            .enter().append("rect")
            .attr("class", "bar")
            .attr("x", function (d) { return x(d.name); })
            .attr("width", x.bandwidth())
            .attr("y", function (d) { return y(d.value); })
            .attr("height", function (d) { return height - y(d.value); })
            .on("mousemove", function (d) {
                tooltip
                    .style("left", d3.event.pageX - 20 + "px")
                    .style("top", d3.event.pageY - 50 + "px")
                    .style("display", "inline-block")
                    .html((d.name) + "<br>" + "In Stock " + (d.value));
            })
            .on("mouseout", function (d) { tooltip.style("display", "none"); });

        // add the x Axis
        //added additional x axis tick capabilities to break text and display it without overlapping
        svg.append("g")
            .attr("transform", "translate(0," + height + ")")
            .call(d3.axisBottom(x))
            .selectAll(".tick text")
            .call(wrap, x.bandwidth());

        // add the y Axis
        svg.append("g")
            .call(d3.axisLeft(y));

        // add label to y Axis
        svg.append("text")
            .attr("transform", "rotate(-90)")
            .attr("dy", "-2.4em")
            .style("text-anchor", "end")
            .text("IN STOCK / QTY.");

        //wrap function used for breaking down long labels on x axis so that it doesnt overlap with each other
        function wrap(text, width) {
            text.each(function () {
                var text = d3.select(this),
                    words = text.text().split(/\s+/).reverse(),
                    word,
                    line = [],
                    lineNumber = 0,
                    lineHeight = 1.1, // ems
                    y = text.attr("y"),
                    dy = parseFloat(text.attr("dy")),
                    tspan = text.text(null).append("tspan").attr("x", 0).attr("y", y).attr("dy", dy + "em");
                while (word = words.pop()) {
                    line.push(word);
                    tspan.text(line.join(" "));
                    if (tspan.node().getComputedTextLength() > width) {
                        line.pop();
                        tspan.text(line.join(" "));
                        line = [word];
                        tspan = text.append("tspan").attr("x", 0).attr("y", y).attr("dy", ++lineNumber * lineHeight + dy + "em").text(word);
                    }
                }
            });
        };

</script>
</body>
</html>
