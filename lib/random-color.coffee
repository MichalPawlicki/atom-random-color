{CompositeDisposable} = require 'atom'

module.exports = RandomColor =
  _isActive: false
  _timer: null
  _syntaxThemes: []

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
    @_syntaxThemes = @_getThemes('syntax')

  _stop: ->
    console.log 'RandomColor stopped!'
    clearInterval @_timer
    @_isActive = false

  serialize: ->
    isActive: @_isActive

  _changeColors: ->
    @_activateRandomSyntaxTheme()
    editors = document.querySelectorAll '.editor'
    for editor in editors
      @_setRandomColors editor

  _activateRandomSyntaxTheme: ->
    themeConfig = atom.config.get('core.themes')
    themeConfig[1] = @_pickRandomElement(@_syntaxThemes).name
    atom.config.set('core.themes', themeConfig)
    console.log "core.themes: #{atom.config.get('core.themes')}"

  _pickRandomElement: (array) ->
    array[@_randomNum(array.length)]

  _randomNum: (max) ->
    Math.floor Math.random() * max

  _setRandomColors: (editor) ->
    textRgb = [0..2].map (_) => @_randomNum(256)
    backgroundRgb = textRgb.map (val) -> (val + 128) % 256
    editor.style['color'] = "rgb(#{textRgb.join()})"
    editor.style['background'] = "rgb(#{backgroundRgb.join()})"

  _getThemes: (themeType) ->
    allThemes = atom.themes.getLoadedThemes()
    allThemes.filter (theme) -> theme.metadata.theme == themeType
