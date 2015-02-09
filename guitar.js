
var Guitar = function() {
  var canvas = document.getElementById("screen");
  this.screen = canvas.getContext('2d');
  //green,red,yellow,blue.orange
  this.colors = ['#2ecc71', '#e74c3c', '#f1c40f', '#55acee', '#e67e22'];
  this.size = { x: this.screen.canvas.width, y: this.screen.canvas.height };
  this.padding = 10;
  this.onFinish;
  this.onHit;
  this.player = new Player(this);
  this.music = new Music(this, this.player);
  this.bodies = [this.music, this.player];
  this.song;
  this.canvasPosition;
  this.startTime = (new Date()).getTime();
  
  this.active = true;
  this.player.draw(this.screen);
  
  var self = this;
  var listener = function(e) {
    //console.log(e.changedTouches);
    if (!self.canvasPosition) {
      console.log('aca')
      self.canvasPosition = {
        x: $('#screen').offset().left,
        y: $('#screen').offset().top
      }
    }
    var mouse = {
      x: e.changedTouches[0].clientX - self.canvasPosition.x,
      y: e.changedTouches[0].clientY - self.canvasPosition.y
    }
    //var mouse = {
    //  x: e.pageX - canvasPosition.x,
    //  y: e.pageY - canvasPosition.y
    //}
    self.bodies.forEach(function(body) {
      if (body.handleClick) {
        body.handleClick(mouse);
      }
    });
  }
  canvas.removeEventListener('touchstart', listener, false);
  canvas.addEventListener('touchstart',listener, false);
  /*document.body.addEventListener('touchmove', function(event) {
    event.preventDefault();
  }, false);*/
};

Guitar.prototype = {
  start: function(data) {
    data = data || {};
    this.startTime = (new Date()).getTime();
    this.music.setMusic(data.music);
    this.onFinish = data.onFinish;
    this.onHit = data.onHit;
    this.player.clear();
    var self = this;
    loadSound(data.song, function(song) {
      self.song = song;
      self.starGame();
    })
  },
  stop: function() {
    this.song.pause();
    /*for (var i = this.music.test.length - 1; i >= 0; i--) {
      console.log('{x:'+this.music.test[i]+', y: 0},')
    };*/
    this.active = false;
  },
  resume: function() {
    this.starGame()
  },
  starGame: function() {
    this.active = true;
    var self = this;
    this.song.play();
    var tick = function() {
      if(!self.active) {
        return;
      }
      self.update();
      self.draw(self.screen);
      requestAnimationFrame(tick);
    };
    tick();
  },
  finish:function() {
    if (!this.active) return
    /*for (var i = this.music.test.length - 1; i >= 0; i--) {
      console.log('{x:'+this.music.test[i]+', y: 0},')
    };*/
    this.active = false;
    this.song.pause();
    var finishTime = (new Date()).getTime();
    var time = (finishTime - this.startTime) / 1000;
    console.log('demoro', time);
    this.onFinish(this.player.points.val);
  },
  showText: function(text) {
    this.onHit({
      text: text
    });
  },
  update: function() {
    this.bodies.forEach(function(item) {
      item.update();
    })
  },
  draw: function(screen) {
    screen.clearRect(0, 0, this.size.x, this.size.y);
    this.bodies.forEach(function(item) {
      item.draw(screen);
    })
  },
  shake: function() {
    window.navigator.vibrate(300);
  }
};

var Player = function(game) {
  this.mult = 0;
  this.game = game;
  this.points = {
    val: 0,
    x: 10,
    y: 40
  }
  this.combo = {
    val: 0,
    x: 10,
    y: 65
  }
  this.center = {x: 200, y : this.game.size.y};
  this.size = {
    x: 50,
    y: 50
  };
  this.buttons = [];
  for (var i = 0; i < 5; i++) {
    this.buttons.push({
      size: this.size,
      center: {
        x: (i+1)* this.size.x - this.size.x/2 + i*this.game.padding,
        y: this.center.y - this.size.y/2
      },
      color: this.game.colors[i]
    });
  }
};

Player.prototype = {
  getPositions: function() {
    var res = [];
    this.buttons.forEach(function(item) {
      res.push(item.center.x)
    });
    return res;
  },
  addPoints: function(points) {
    if (points > 20) {;
      if (this.mult <= 25) {
        this.mult += 1;
        this.combo.val = parseInt( this.mult / 5 ) + 1;
      }
    } else {
      this.combo.val = 1;
      this.mult = 0;
    }
    this.points.val += points * this.combo.val;
    
  },
  clearCombo: function() {
    this.mult = 0;
    this.combo.val = 1;
    this.game.shake();
  },
  update: function() {

  },
  clear: function() {
    this.points.val = 0;
    this.mult = 0;
    this.combo.val = 1;
  },
  draw: function(screen) {
    this.buttons.forEach(function(item) {
      drawCircle(screen, item)
    });

    drawText(screen, this.points);
    drawText(screen, {
      val: 'x'+ this.combo.val,
      x: this.combo.x,
      y: this.combo.y
    }, '30')
  }
};

var Music = function(game, player) {
  this.player = player;
  this.game = game;
  this.step = 3;
  this.test = []
  this.matrix = [];
  this.size = {x: 50, y: 50};
  this.center = {x: this.game.size.x / 2, y : 0};
  this.height = this.game.size.y / this.size.y;
  this.random = {
    'easy': {
      percentage: 0.55,
      maxCol: 3
    }, 
    'medium': {
      percentage: 0.70,
      maxCol: 4
    }, 
    'hard': {
      percentage: 0.85,
      maxCol: 5
    }
  }
}

Music.prototype = {
  setMusic: function(music) {
    this.center.y = 0;
    if (!music) throw 'no music';
    this.matrix = [];
    for (var i = 0; i < music.height; i++) {
      var arr = [];
      for (var j = 0; j < 5; j++) {
        arr.push(null);
      };
      this.matrix.push(arr);
    };
    var x, y;
    if (music.type === 'random') {
      music.notes = this.generateRandom(music);
    }
    for (var i = 0; i < music.notes.length; i++) {
      x = music.notes[i].x;
      y = music.notes[i].y;
      this.matrix[x][y] = {
        hit: false,
        check: false
      }
    };
  },
  generateRandom: function(data) {
    var height = data.height-10;
    var take = parseInt(this.random[data.level].percentage * height, 10);
    var temp = [];
    var notes = [];
    for (var i = 0; i < height; i++) {
      temp.push(i);
    }
    var valTemp;
    for (var i = 0; i < 300; i++) {
      var rdn1 = Math.floor(Math.random() * height);
      var rdn2 = Math.floor(Math.random() * height);
      valTemp = temp[rdn1];
      temp[rdn1] = temp[rdn2];
      temp[rdn2] = valTemp;
    };
    var maxNote = this.random[data.level].maxCol;
    for (var i = 0; i < take; i++) {
      notes.push({
        x: temp[i],
        y: Math.floor(Math.random() * maxNote)
      });
    };
    return notes;
  },
  handleClick: function(mouse) {
    if (this.noMoreNotes()) {
      return;
    }
    var lenRows = this.matrix.length;
    var actualRow = parseInt(this.center.y / this.size.y, 10);
    var y = lenRows - actualRow - 1;
    var self = this;
    if (y >= self.matrix.length) {
      return;
    }
    this.test.push(y)
    var rows = this.getLastRow();
    this.player.buttons.forEach(function(item, i) {
     
      if (item.center.x - item.size.x/2 < mouse.x &&
          item.center.x + item.size.x/2 > mouse.x &&
          item.center.y - item.size.y/2 < mouse.y &&
          item.center.y + item.size.y/2 > mouse.y) {
        if (!rows[i]) {
          self.game.showText('Miss');
          self.player.clearCombo();
          return;
        }
        var index = rows[i].index;
        var dist = item.center.y - rows[i].y;
        if (dist < 0) {
          return;
        }
        if (dist >= self.size.y) {
          self.game.showText('Miss');
          self.player.clearCombo();
          return;
        }

        self.matrix[index][i].check = true;
        self.matrix[index][i].hit = true;
        var points = 20;
        var text = 'Bad'
        if (dist <= 17 && dist > 10) {
          text = 'Good';
          points = 30
        }
        else if (dist <= 10 && dist > 5) {
          text = 'Very Good';
          points = 40
        }
        else if (dist <= 5 && dist > 0) {
          text = 'Excelent';
          points = 50;
        }
        self.game.showText(text);
        self.player.addPoints(points);
      }
    })
  },
  validate: function() {
    if (this.noMoreNotes()) {
      this.game.finish();
      return;
    }
    if ( (this.center.y % this.size.y) == 0) {
      return;
    }
    var lenRows = this.matrix.length;
    var actualRow = parseInt(this.center.y / this.size.y, 10);
    var y = lenRows - actualRow - 1;
    var posY = this.height*this.size.y - this.size.x/2 + 2;
    var buttons = this.player.getPositions();
    var allHit = true;
    var anyNote = false;
    for (var k = 0; k < 5; k++) {
      var elem = this.matrix[y][k];
      if (elem && !elem.check && !elem.hit) {
        elem.check = true;
        allHit = false;
        anyNote = true;
      }
    }
    if (anyNote) {
      if (!allHit) {
        this.game.showText('Miss');
        this.player.clearCombo();
      }
    }
    
  },
  noMoreNotes: function() {
    var lenRows = this.matrix.length;
    var actualRow = parseInt(this.center.y / this.size.y, 10);
    return actualRow >= lenRows;
  },
  getLastRow: function() {
    if (this.noMoreNotes()) {
      return;
    }
    var res = [];
    var lenRows = this.matrix.length;
    var actualRow = parseInt(this.center.y / this.size.y, 10);
    var y = lenRows - actualRow - 1;
    var posY = this.height*this.size.y - this.size.x/2 + this.center.y % this.size.y;
    for (var k = 0; k < 5; k++) {
      var val = undefined;
      for (var j = 0; j < 2; j++) {
        if (y - j >= 0 && this.matrix[y - j][k]) {
          val = {
            y: posY - j*this.size.y,
            index: y - j
          };
          break;
        }
      }
      res.push(val);
    }
    return res;
  },    
  update: function() {
    this.center.y += this.step;
    this.validate();

  },
  draw: function(screen) {
    if (this.noMoreNotes()) {
      return;
    }
    var lenRows = this.matrix.length;
    var lenCols = this.matrix[0].length;
    var center = this.size.x / 2;
    var actualRow = parseInt(this.center.y / this.size.y, 10);
    var rest = this.center.y % this.size.y;
    var temp = {
      size: {
        x: this.size.x,
        y: this.size.y
      },
      center: {
        x: 0,
        y: 0
      }
    }
    
    for (var i = 0; i < this.height; i++) {
      var y = lenRows - this.height - actualRow + i;
      for (var j = 0; j <= lenCols; j++) {
        if (y >= 0 && this.matrix[y][j]) {
          temp.center.x = (j+1) * this.size.x - center + j*this.game.padding;
          temp.center.y = (i+1) * this.size.y - center + rest;
          temp.color = this.game.colors[j];
          drawCircle(screen, temp);
        }
      }
    }
  }
};

var drawRect = function(screen, body) {
  screen.fillRect(body.center.x - body.size.x / 2,
                  body.center.y - body.size.y / 2,
                  body.size.x,
                  body.size.y);
};
var drawText = function(screen, body, size) {
  size = size || '40'
  screen.font = size + 'px Calibri';
  screen.fillStyle = 'white'
  screen.fillText(body.val, body.x, body.y);
}

var drawCircle = function(screen, body) {
  screen.fillStyle = body.color; //red
  screen.beginPath();
  screen.arc(body.center.x,
    body.center.y, 
    body.size.x/2,0,Math.PI*2,true);
  screen.closePath();
  screen.fill();
}
var loadSound = function(url, callback) {
  var sound = new Audio(url);
  var loaded = function() {
    callback(sound);
    sound.removeEventListener('canplaythrough', loaded);
  };
  sound.addEventListener('canplaythrough', loaded);
  sound.load();
};
/*window.addEventListener('load', function() {
  var music = [];
  var songPath = 'music/otherside.ogg';
  var delay=  0;
  new Game();
})*/

module.exports.Guitar = Guitar;
