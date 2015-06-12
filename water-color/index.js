var canvas = document.createElement('canvas');
canvas.setAttribute('width', window.innerWidth);
canvas.setAttribute('height', window.innerHeight);

var ctx = canvas.getContext('2d');
var GRID_SIZE = 50;
var DEBUG = 1;
var mousedown = false;

document.body.appendChild(canvas);

var paper = [];
paper.width = parseInt(canvas.width / GRID_SIZE);

for(var x = 0; x < paper.width; ++x) {
  for(var y = 0; y < canvas.height/GRID_SIZE; ++y) {
    paper[y * paper.width + x] = {};
  }
}

function paintGrid() {
  ctx.font = "12px serif";
  for(var x = 0; x < paper.width; ++x) {
    for(var y = 0; y < paper.length/paper.width; ++y) {
      var v = paper[paper.width * y + x].v || 0;
      ctx.strokeStyle = 'orange';
      ctx.strokeRect(x * GRID_SIZE, y * GRID_SIZE, GRID_SIZE, GRID_SIZE);
      ctx.strokeText(v.toFixed(3), x * GRID_SIZE, (y + 1) * GRID_SIZE);
      ['red', 'green', 'blue'].forEach(function(v, i) {
        ctx.strokeStyle = v;
        //ctx.fillStyle = v;
        ctx.strokeRect(
            x * GRID_SIZE + (GRID_SIZE / 10 * (i + 1)) + GRID_SIZE / 5 * i,
            y * GRID_SIZE + GRID_SIZE / 2 - GRID_SIZE / 10,
            GRID_SIZE / 5,
            GRID_SIZE / 5);
      });
    }
  }

  var sum = paper.reduce(function(acc, prev) {
    return acc + (prev.v === undefined ? 0 : prev.v);
  }, 0);
  ctx.fillStyle = 'red';
  ctx.font = "50px serif";

  //ctx.fillText(sum.toFixed(2), 100, 100);
}

function calculateFill(x, y) {
  var val = paper[paper.width * y + x].v;

  val = val === undefined ? 0 : val;
  return 'rgba(0,0,0,' + val + ')';
}

function addToPoint(x, y, amount) {
  var point = paper[paper.width * y + x];
  if (point !== undefined) {
    if (point.v === undefined) {
      point.v = amount;
    } else {
      if (point.v < 1) {
        point.v += amount;
      }
    }
  }
}

function spreadToNeighbors(x, y) {
  var point = paper[paper.width * y + x];

  if (point !== undefined && point.v > 0.1) {
    // take an eigth out and get 1/8 to apply to neighbors
    var prev = point.v;
    point.v -= Math.floor((point.v/8 + 0.005) * 1000) / 1000;
    var toSpread = Math.floor((prev/8)/8 * 1000) / 1000;

    for(var Dx = -1; Dx < 2; ++Dx) {
      for(var Dy = -1; Dy < 2; ++Dy) {
        addToPoint(x + Dx, y + Dy, toSpread);
      }
    }
  }
}

function diffuse() {
  for(var x = 0; x < paper.width; ++x) {
    for(var y = 0; y < paper.length/paper.width; ++y) {
      spreadToNeighbors(x, y);
    }
  }
}

function paint() {
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  for(var x = 0; x < paper.width; ++x) {
    for(var y = 0; y < paper.length/paper.width; ++y) {
      ctx.fillStyle = calculateFill(x, y);
      ctx.fillRect(x * GRID_SIZE, y * GRID_SIZE, GRID_SIZE, GRID_SIZE);
    }
  }

  DEBUG && paintGrid();
  requestAnimationFrame(paint);
}

function getPaperPoint(x, y) {
  return [parseInt(x / GRID_SIZE), parseInt(y / GRID_SIZE)];
}

paint();

setInterval(diffuse, 16.66);
canvas.addEventListener('mousemove', function(e) {
  addToPoint.apply(null, getPaperPoint(e.pageX, e.pageY).concat(5));
});
