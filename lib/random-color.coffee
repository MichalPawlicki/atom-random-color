{CompositeDisposable} = require 'atom'

module.exports = RandomColor =
  _isActive: false
  _timer: null

  activate: ->
    atom.commands.add 'atom-workspace', 'random-color:toggle', => @toggle()
    console.log 'RandomColor activated!'

  toggle: ->
    console.log 'RandomColor was toggled!'
    if @_isActive then @_stop() else @_start()

  _start: ->
    console.log 'RandomColor started!'
    @_timer = setInterval =>
      @_changeColors()
    , 1000
    @_isActive = true

  _stop: ->
    console.log 'RandomColor stopped!'
    clearInterval @_timer
    @_isActive = false

  serialize: ->
    isActive: @_isActive

  _changeColors: ->
    tile = document.querySelector '.editor'
    textRgb = [0..2].map (_) => @_randomNum(256)
    backgroundRgb = textRgb.map (val) -> (val + 128) % 256
    tile.style['color'] = "rgb(#{textRgb.join()})"
    tile.style['background'] = "rgb(#{backgroundRgb.join()})"

  _randomNum: (max) ->
    Math.floor Math.random() * max
