var bounds = {x: 500, y: 500};
var bunnies = [];
var foxes = [];
var ctx = document.querySelector('canvas').getContext('2d');

for(var i = 0; i < 300; ++i) {
  bunnies.push({
    x: ~~(Math.random() * bounds.x),
    y: ~~(Math.random() * bounds.y),
    age: 1
  });
}

for(var i = 0; i < 20; ++i) {
  foxes.push({
    x: ~~(Math.random() * bounds.x),
    y: ~~(Math.random() * bounds.y),
    belly: 5
  });
}


setInterval(function() {
  tick();
}, 16.66);


setInterval(function() {
  paint();
}, 16.66);

function paint() {
  ctx.clearRect(0, 0, 500, 500);
  ctx.fillStyle = 'teal';
  bunnies.forEach(function(b) {
    ctx.fillRect(b.x, b.y, 1, 1);
  });

  ctx.fillStyle = 'red';
  foxes.forEach(function(b) {
    ctx.fillRect(b.x, b.y, 1, 1);
  });
}

function moveVal() {
  return ~~(Math.random() * 2) ? 1 : -1;
}

function age(obj) {
  if (obj.age < 1) {
    obj.age += 0.1;
  }

  return obj;
}

function move(obj) {
  var ret = {
    x: obj.x + moveVal(),
    y: obj.y + moveVal(),
    age: obj.age,
    belly: obj.belly
  };

  if (ret.x < 0 || ret.x > bounds.x || ret.y < 0 || ret.y > bounds.y) {
    return move(obj);
  }

  return ret;
}

function spawn(all) {
  if (bunnies.length > 1000) { return [] }

  var newBunnies = [];
  all.forEach(function(obj) {
    all.forEach(function(v) {
      if (v !== obj && obj.x === v.x && obj.y === v.y && v.age >= 1 && obj.age >= 1) {
        newBunnies.push({x: obj.x, y: obj.y, age: 0});
      }
    });
  });

  return newBunnies;
}

function eat(bunnies, foxes) {
  foxes.forEach(function(fox) {
    bunnies.forEach(function(bun) {
      if (Math.abs(fox.x - bun.x) < 20 && Math.abs(fox.y - bun.y) < 20 && bun.dead !== true) {
        bun.dead = true;
        fox.belly += 1;
      }
    });
  });

  return bunnies.filter(function(bun) {
    return bun.dead !== true;
  });
}

function dieOfHunger(foxes) {
  return foxes.reduce(function(prev, curr) {
    curr.belly -= 0.01;
    if (curr.belly > 0) {
      prev.push(curr);
    }

    return prev;
  }, []);
}

function reproduce(foxes) {
  return foxes.reduce(function(prev, cur) {
    if (cur.belly > 6) {
      cur.belly -= 5;
      var baby = {
        x: cur.x,
        y: cur.y,
        belly: 5,
        age: 1
      };
      baby.belly = 5;
      prev.push(baby);
    }

    prev.push(cur);
    return prev;
  }, []);
}

function tick() {
  console.log('foxes: ' + foxes.length, 'bunnies: ' + bunnies.length);

  bunnies = eat(bunnies, foxes);
  foxes = foxes.map(move);
  foxes = reproduce(foxes);

  foxes = dieOfHunger(foxes);
  bunnies = bunnies.map(move);

  bunnies = bunnies.map(age);
  bunnies = bunnies.concat(spawn(bunnies));
}
