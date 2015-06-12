var canvas = document.createElement('canvas');
canvas.setAttribute('width', window.innerWidth);
canvas.setAttribute('height', window.innerHeight);

var ctx = canvas.getContext('2d');
var mouseDown = false;
var last = null;
var points = [];
document.body.appendChild(canvas);

canvas.addEventListener('mousedown', function() {
  mouseDown = true;
});

canvas.addEventListener('mouseup', function() {
  finishLine(points.slice(0));
  points = [];
  mouseDown = false;
});

canvas.addEventListener('mousemove', drop);

function drop(e) {
  if (!mouseDown) {
    last = null;
    return;
  }

  if (!last) {
    last = {x: e.pageX, y: e.pageY};
    return;
  }

  ctx.strokeStyle = 'rgba(0, 0, 0, 0.5)';
  var centerX = (last.x + e.pageX) / 2;
  var centerY = (last.y + e.pageY) / 2;
  var magnitude = (Math.abs(e.pageX - last.x) + Math.abs(e.pageY - last.y)) / (window.innerHeight + window.innerWidth);

  var angle = Math.atan2(e.pageX - last.x, e.pageY - last.y);
  var ninety = angle - (90 * Math.PI/180);

  var dist = magnitude * 500;
  points = points.concat({
    angle: angle,
    magnitude: magnitude,
    centerX: centerX,
    centerY: centerY,
    x1: dist * Math.sin(ninety) + centerX,
    y1: dist * Math.cos(ninety) + centerY,
    x2: -dist * Math.sin(ninety) + centerX,
    y2: -dist * Math.cos(ninety) + centerY
  });

  last = {x: e.pageX, y: e.pageY};

  if (points.length === 2) {
    fillSkelly(points);
    points = points.slice(1);
  }
}

function finishLine(points) {
  if (points[0].magnitude.toFixed(3) <= 0.001) {
    return;
  }

  var ninety = points[0].angle - (90 * Math.PI/180);
  var center = {
    x: points[0].centerX + (700 * points[0].magnitude) * Math.sin(points[0].angle),
    y: points[0].centerY + (700 * points[0].magnitude) * Math.cos(points[0].angle)
  };
  var magnitude = points[0].magnitude * 0.9;

  points.push({
    angle: points[0].angle += (Math.floor(2 * Math.random()) ? Math.random() : -Math.random()),
    magnitude: magnitude,
    centerX: center.x,
    centerY: center.y,
    x1: center.x + (500 * magnitude) * Math.sin(ninety),
    y1: center.y + (500 * magnitude) * Math.cos(ninety),
    x2: center.x + (-500 * magnitude) * Math.sin(ninety),
    y2: center.y + (-500 * magnitude) * Math.cos(ninety)
  });

  fillSkelly(points, 'rgba(0, 200, 0, 0.2)');

  requestAnimationFrame(finishLine.bind(null, points.slice(1)));
}

function fillEdges(x1, y1, x2, y2, x3, y3, x4, y4) {
  var w = 2;
  var topMid = {
    x: (x2 + x4) / 2 - w/2,
    y: (y2 + y4) / 2 - w/2
  };
  var bottomMid = {
    x: (x1 + x3) / 2 - w/2,
    y: (y1 + y3) / 2 - w/2
  };

  ctx.fillRect(topMid.x, topMid.y,  w, w);
  ctx.fillRect(bottomMid.x, bottomMid.y, w, w);
}

function edgeNoise(m, x) {
  return 2 * Math.random() * Math.sin(x);
}

function edgeFill(points) {
  ctx.strokeStyle = 'rgba(37, 194, 233, 0.2)';
  points.forEach(function(v) {
    ctx.beginPath();
    ctx.moveTo(v[0], v[1])
    for(var i = 0; i < v.length; i+=2) {
      ctx.lineTo(v[i], v[i+1]);
    }
    ctx.stroke();
  });
}

function fillSkelly(points, fill) {
  var lines = [];

  ctx.fillStyle = 'rgba(37, 194, 233, 0.2)';
  ctx.beginPath();
  var m = (points[1].y1 - points[0].y1) / (points[1].x1 - points[0].x1);
  var b = points[0].y1 - m * points[0].x1;
  var minX = Math.min(points[0].x1, points[1].x1);
  var maxX = Math.max(points[0].x1, points[1].x1);

  ctx.moveTo(minX, minX * m + b);
  lines.push([]);

  for(var x = minX; x < maxX; x += 1) {
    lines[0].push(x, edgeNoise(points[0].magnitude, x) + m * x + b);
    ctx.lineTo(x, edgeNoise(points[0].magnitude, x) + m * x + b);
  }
  ctx.lineTo(maxX, maxX * m + b);

  var m2 = (points[1].y2 - points[0].y2) / (points[1].x2 - points[0].x2);
  var b2 = points[0].y2 - m2 * points[0].x2;

  var minX2 = Math.min(points[0].x2, points[1].x2);
  var maxX2 = Math.max(points[0].x2, points[1].x2);
  lines.push([]);

  if (Math.sign((points[1].x1 - points[0].x1)) !== Math.sign((points[1].x2 - points[0].x2))) {
    ctx.lineTo(minX2, minX2 * m2 + b2);
    for(var x = maxX2; x > minX2; x -= 1) {
      lines[1].push(x, edgeNoise(points[1].magnitude, x) + m2 * x + b2);
      ctx.lineTo(x, edgeNoise(points[1].magnitude, x) + m2 * x + b2);
    }
    ctx.lineTo(maxX2, maxX2 * m2 + b2);
  } else {
    ctx.lineTo(maxX2, maxX2 * m2 + b2);

    for(var x = maxX2; x > minX2; x -= 1) {
      lines[1].push(x, edgeNoise(points[1].magnitude, x) + m2 * x + b2);
      ctx.lineTo(x, edgeNoise(points[1].magnitude, x) + m2 * x + b2);
    }
    ctx.lineTo(minX2, minX2 * m2 + b2);
  }
  ctx.fill();
  ctx.closePath();
  edgeFill(lines);
}
