data = [2,5,7,3,15,4, 15, 2, 10, 10, 20, 100, 30, 60, 20]

document.body.innerHTML = "<svg class='chart'></svg>";

marginBottom    = 22
height          = 100 + marginBottom
width           = 300
leftRightMargin = 10
y = x = 0

calcY = ->
  y = d3.scale.linear()
        .domain([0, d3.max(data)])
        .range([height-marginBottom, 0])

calcX = ->
  x = d3.scale.linear()
        .domain([0, data.length])
        .range([leftRightMargin, width-leftRightMargin])

calcY()
calcX()

chart = d3.select('.chart')
          .attr('width', width)
          .attr 'height', height

line = d3.svg.line()
       .interpolate("basis")
       .x((d, i) -> x(i))
       .y y

chart.append("svg:path").attr("d", line(data))

xAxis = d3.svg.axis()
        .scale(x)
        .orient("bottom")

chart.append('g')
     .attr('transform', -> "translate(0, #{height - marginBottom})")
     .call(xAxis)

setInterval ->
  data.push(Math.random()*100)
  path = line(data)

  calcX()
  calcY()

  chart.select('path')
       .transition()
       .attr 'd', path
, 1000