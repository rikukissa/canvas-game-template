window.requestAnimFrame = ((callback) ->
  return window.requestAnimationFrame   || 
  window.webkitRequestAnimationFrame    || 
  window.mozRequestAnimationFrame       || 
  window.oRequestAnimationFrame         || 
  window.msRequestAnimationFrame        ||
  (callback) ->
    window.setTimeout callback, 1000 / 60
)()

class window.World
  constructor: () ->
    @size =
      x: 50
      y: 50
    @bodies = []
  createBody: (b) ->
    b.parent = @
    @bodies.push b

class window.Keys
	constructor: () ->
    @up = false
    @down = false
    @left = false
    @right = false
    @commands =
      37: 'left'
      38: 'up'
      39: 'right'
      40: 'down'
    @loadEvents()
  loadEvents: () ->
    $(window).bind 'keydown keyup', (e) =>
      if @commands.hasOwnProperty e.keyCode
        @[@commands[e.keyCode]] = e.type == 'keydown'

class window.Assets
  constructor: (@arr) ->
    @asset = {}
    @loaded = 0

  load: (callback) ->
    if @arr.length == 0 || !@assets 
      callback()
      return
    for path in @arr
      @asset[path] = new Image()
      @asset[path].onload = () =>
        @loaded++
        if @loaded == @arr.length
          callback()
      @asset[path].src = path

class window.Camera
  constructor: (@canvas) ->
    @ctx = @canvas.getContext '2d'
    @position =
      x: 0
      y: 0
    @translation =
      x: 0
      y: 0
    @scale = 64
    @angle = Math.PI / 4
    @loadEvents()

  move: () ->
    @position.x += @translation.x
    @position.y += @translation.y
    @ctx.translate @position.x, @position.y

  loadEvents: () ->
    window.addEventListener 'mousemove', (e) =>
      if e.offsetX < 50
        @translation.x = 10
      else if e.offsetX > @canvas.width - 50
        @translation.x = -10
      else
        @translation.x = 0

      if e.offsetY < 50
        @translation.y = 10
      else if e.offsetY > @canvas.height - 50
        @translation.y = -10
      else
        @translation.y = 0

    window.addEventListener 'mouseout', () =>
      @translation.y = 0
      @translation.x = 0

class window.Body
  constructor: () ->
    @position =
      x: 0
      y: 0
      z: 0
     @dimensions =
      w: 0
      d: 0     
      h: 0
    @fixtures = []
    @type = 'static'
  createFixture: (fix) ->
    fix.parent = @
    @fixtures.push fix

class window.Fixture
  constructor: () ->
    @position =
      x: 0
      y: 0
      z: 0
    @dimensions =
      w: 0
      d: 0
      h: 0