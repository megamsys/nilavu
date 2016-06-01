import { on } from "ember-addons/ember-computed-decorators";

export default Ember.View.extend({
  tagName: "canvas",
  attributeBindings: ['height', 'width'],
  height: 400,
  width: 600,
  scaleFactor: 1,
  socket: null,
  canvas: null,
  ctx: null,
  keyMap: {
    8: [
      65288,
      65288
    ],
    9: [
      65289,
      65289
    ],
    13: [
      65293,
      65293
    ],
    16: [
      65506,
      65506
    ],
    17: [
      65508,
      65508
    ],
    18: [
      65514,
      65514
    ],
    27: [
      65307,
      65307
    ],
    32: [
      32,
      32
    ],
    33: [
      65365,
      65365
    ],
    34: [
      65366,
      65366
    ],
    35: [
      65367,
      65367
    ],
    36: [
      65360,
      65360
    ],
    37: [
      65361,
      65361
    ],
    38: [
      65362,
      65362
    ],
    39: [
      65363,
      65363
    ],
    40: [
      65364,
      65364
    ],
    45: [
      65379,
      65379
    ],
    46: [
      65535,
      65535
    ],
    48: [
      48,
      41
    ],
    49: [
      49,
      33
    ],
    50: [
      50,
      64
    ],
    51: [
      51,
      35
    ],
    52: [
      52,
      36
    ],
    53: [
      53,
      37
    ],
    54: [
      54,
      94
    ],
    55: [
      55,
      38
    ],
    56: [
      56,
      42
    ],
    57: [
      57,
      40
    ],
    65: [
      97,
      65
    ],
    66: [
      98,
      66
    ],
    67: [
      99,
      67
    ],
    68: [
      100,
      68
    ],
    69: [
      101,
      69
    ],
    70: [
      102,
      70
    ],
    71: [
      103,
      71
    ],
    72: [
      104,
      72
    ],
    73: [
      105,
      73
    ],
    74: [
      106,
      74
    ],
    75: [
      107,
      75
    ],
    76: [
      108,
      76
    ],
    77: [
      109,
      77
    ],
    78: [
      110,
      78
    ],
    79: [
      111,
      79
    ],
    80: [
      112,
      80
    ],
    81: [
      113,
      81
    ],
    82: [
      114,
      82
    ],
    83: [
      115,
      83
    ],
    84: [
      116,
      84
    ],
    85: [
      117,
      85
    ],
    86: [
      118,
      86
    ],
    87: [
      119,
      87
    ],
    88: [
      120,
      88
    ],
    89: [
      121,
      89
    ],
    90: [
      122,
      90
    ],
    97: [
      49,
      49
    ],
    98: [
      50,
      50
    ],
    99: [
      51,
      51
    ],
    100: [
      52,
      52
    ],
    101: [
      53,
      53
    ],
    102: [
      54,
      54
    ],
    103: [
      55,
      55
    ],
    104: [
      56,
      56
    ],
    105: [
      57,
      57
    ],
    106: [
      42,
      42
    ],
    107: [
      61,
      61
    ],
    109: [
      45,
      45
    ],
    110: [
      46,
      46
    ],
    111: [
      47,
      47
    ],
    112: [
      65470,
      65470
    ],
    113: [
      65471,
      65471
    ],
    114: [
      65472,
      65472
    ],
    115: [
      65473,
      65473
    ],
    116: [
      65474,
      65474
    ],
    117: [
      65475,
      65475
    ],
    118: [
      65476,
      65476
    ],
    119: [
      65477,
      65477
    ],
    120: [
      65478,
      65478
    ],
    121: [
      65479,
      65479
    ],
    122: [
      65480,
      65480
    ],
    123: [
      65481,
      65481
    ],
    186: [
      59,
      58
    ],
    187: [
      61,
      43
    ],
    188: [
      44,
      60
    ],
    189: [
      45,
      95
    ],
    190: [
      46,
      62
    ],
    191: [
      47,
      63
    ],
    192: [
      96,
      126
    ],
    219: [
      91,
      123
    ],
    220: [
      92,
      124
    ],
    221: [
      93,
      125
    ],
    222: [
      39,
      34
    ]
  },

  @on('init')
  openSocket() {
    this.set('socket', this.socketIO.socketFor('http://localhost:8090', { path: ""}));

    this.get('socket').emit('init', {
      host: "136.243.49.217",
      port: 6533,
      password: ""
    });
  },

  didInsertElement: function(){
    this.set('canvas', Ember.get(this, 'element'));
    this.set('ctx', this.get('canvas').getContext("2d"));
    this.drawItem();
  },

  willDestroy: function() {
    var socket = this.get('socket');
    var canvas = this.get('canvas');
    socket.close();
    document.removeEventListener('keydown', this._onkeydown);
    document.removeEventListener('keyup', this._onkeyup);
    canvas.removeEventListener('mouseup', this._onmouseup);
    canvas.removeEventListener('mousedown', this._onmousedown);
    canvas.removeEventListener('mousemove', this._onmousemove);
  },

  drawItem: function(){
      var socket = this.get('socket');
      socket.on('init', this.scaleScreen, this);
      socket.on('frame', this.drawRect, this);
  },

  drawRect: function(rect){
      var ctx = this.get('ctx');
      var img = new Image();
      img.width = rect.width;
      img.height = rect.height;
      img.src = 'data:image/png;base64,' + rect.image;
      img.onload = function () {
        ctx.drawImage(this, rect.x, rect.y, rect.width, rect.height);
      };
    },

  scaleScreen: function(config) {
    var canvas = this.get('canvas');
    canvas.width = config.width;
    canvas.height = config.height;
    this._initEventListeners();
  },

  _initEventListeners: function() {
    var self = this;
    var canvas = this.get('canvas');
    var socket = this.get('socket');
    var scaleFactor = this.get('scaleFactor');
    var keymap = this.get('keyMap');

    this._addMouseHandler(function (x, y, button) {
       socket.emit('mouse', {
         x: x / scaleFactor,
         y: y / scaleFactor,
         button: button
       });
     });

    this._addKeyboardHandlers(function (code, shift, isDown) {
      var rfbKey = null;
      code = code.toString();
      var keys = keymap[code];
      if (keys) {
        rfbKey = keys[shift ? 1 : 0];
      }
      if (rfbKey) {
        socket.emit('keyboard', {
          keyCode: rfbKey,
          isDown: isDown
        });
      }
    });
  },

_addKeyboardHandlers: function (cb) {
  document.addEventListener('keydown', this._onkeydown = function (e) {
    cb.call(null, e.keyCode, e.shiftKey, 1);
    e.preventDefault();
  }, false);
  document.addEventListener('keyup', this._onkeyup = function (e) {
    cb.call(null, e.keyCode, e.shiftKey, 0);
    e.preventDefault();
  }, false);
},

_addMouseHandler: function (cb) {
    var state = 0;
    var canvas = this.get('canvas');
    canvas.addEventListener('mousedown', this._onmousedown = function (e) {
      state = 1;
      cb.call(null, e.pageX, e.pageY, state);
      e.preventDefault();
    }, false);
    canvas.addEventListener('mouseup', this._onmouseup = function (e) {
      state = 0;
      cb.call(null, e.pageX, e.pageY, state);
      e.preventDefault();
    }, false);
    canvas.addEventListener('mousemove', this._onmousemove = function (e) {
      cb.call(null, e.pageX, e.pageY, state);
      e.preventDefault();
    });
  },

});
