ctx = ca.getContext('2d')


function Vector() {

}


function Orb(x, y, c, fixed) {
  this.size = 5;
  this.x  = x;
  this.y  = y;
  this.vy = 0;
  this.vx = 0;
  this.id = Math.random();
  this.color = c || "red";
  this.fixed = fixed;
}

Orb.prototype.draw = function() {
  ctx.beginPath();
  ctx.arc(this.x, this.y, this.size, 0, 2 * Math.PI);
  ctx.closePath();
  ctx.fillStyle=this.color;
  ctx.fill();
}

Orb.prototype.tick = function() {
  if (this.fixed) {
    return;
  }

  this.x += this.vx;
  this.y += this.vy;
}

Orb.prototype.calcV = function() {
  var _this = this;
  var sumvX = 0;
  var sumvY = 0;

  orbs.forEach(function(o) {
    if (o == _this) { return}

    var xD = o.x-_this.x;
    var yD = o.y-_this.y;

    fY = Math.sin(Math.atan2(yD, xD))
    fX = Math.cos(Math.atan2(yD, xD))
    if (Math.sqrt(xD*xD + yD*yD) > 100) {
      fX *= 100;
      fY *= 100;
    } else {
      fX *= -100;
      fY *= -100;
    }
    sumvX += fX/3000
    sumvY += fY/3000
  })

  _this.vx += sumvX
  _this.vy += sumvY
  _this.vy *= .99
  _this.vx *= .99

}

var orbs = [];

for(var i =0; i < 50; ++i) {
  orbs.push(new Orb(Math.random()*400, Math.random()*400, ["red", "green", "blue"][Math.floor(Math.random()*3)]));
}

setInterval(function() {
  ctx.clearRect(0,0,1000,1000);

  orbs.forEach(function(o) {
    o.draw();
  });

  orbs.forEach(function(o) {
    o.calcV();
  });

  orbs.forEach(function(o) {
    o.tick();
  });

}, 16);

