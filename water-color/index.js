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
  ctx.beginPath();
  ctx.moveTo(last.x, last.y);
  ctx.lineTo(e.pageX, e.pageY);
  ctx.closePath();
  ctx.save();
  ctx.translate(centerX, centerY);
  ctx.moveTo(0, 0);

  var dist = magnitude * 500;
  ctx.moveTo(0, 0);
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

  ctx.lineTo(dist * Math.sin(ninety), dist * Math.cos(ninety));
  ctx.moveTo(0, 0);
  ctx.lineTo(-dist * Math.sin(ninety), -dist * Math.cos(ninety));
  ctx.restore();
  last = {x: e.pageX, y: e.pageY};
  ctx.stroke();

  if (points.length === 2) {
    fillSkelly(points);
    points = points.slice(1);
  }
}

function finishLine(points) {
  console.log(points[0].magnitude);
  if (points[0].magnitude.toFixed(2) <= 0.01) {
    return;
  }

  var nextPoint = {
    x: points[0].centerX + (700 * points[0].magnitude) * Math.sin(points[0].angle),
    y: points[0].centerY + (700 * points[0].magnitude) * Math.cos(points[0].angle)
  };

  ctx.fillStyle = 'rgba(0, 200, 0, 0.2)';
  ctx.fillRect(nextPoint.x - 5, nextPoint.y - 5, 10, 10);

  points[0].magnitude *= 0.90;
  points[0].centerX = (points[0].x1 + nextPoint.x) / 2;
  points[0].centerY = (points[0].y1 + nextPoint.y) / 2;
  points[0].x1 = nextPoint.x;
  points[0].y1 = nextPoint.y;
  /*

  points[1] = {
    angle: points[0].angle,
    magnitude: points[0].magnitude * 0.8,
    x1:
    y1:
    x2:
    y2:
  }

  fillSkelly(points, 'rgba(0, 200, 0, 0.2)');
  points = points.slice(1);

*/
  requestAnimationFrame(finishLine.bind(null, points));

}

function fillSkelly(points, fill) {
  ctx.fillStyle = fill || 'rgba(255, 0, 0, 0.1)';

  ctx.beginPath();

  ctx.moveTo(points[0].x1, points[0].y1);
  ctx.lineTo(points[0].x2, points[0].y2);
  ctx.lineTo(points[1].x2, points[1].y2);
  ctx.lineTo(points[1].x1, points[1].y1);

  ctx.fill();
  ctx.closePath();
}
