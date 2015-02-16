React = require 'react'
{levelsDB} = require './../DB/levelsDB.coffee'
{Dispatcher} = require './../dispatcher.coffee'
{Guitar} = require './../guitar.js'

guitar = null

module.exports = Game = React.createClass
  getInitialState: ->
    Dispatcher.subscribe 'startGame', @startGame
    Dispatcher.subscribe 'setShake', @setShake
    idx: -1,
    modalMenu: null,
    modalFinish: null,
    points: 0,
    hitText: '',
    songName: ''
  componentDidMount: ->
    guitar = new Guitar()
    self = @
    localforage.getItem('config', (err, val) ->
      guitar.setShake(val.vibrate);
      $('.modal').easyModal {
        top: 150
        overlay: 0.2
        overlayClose: false
        closeOnEscape: false 
      }
      self.setState 
        modalMenu: $('#modalMenu')
        modalFinish: $('#modalFinish')
    )
  showText: (obj) ->
    console.log 'showText', obj.text
    clearInterval(@timeout) if @timeout?
    @setState hitText: obj.text
    clearText = => @setState hitText: ''
    @timeout = setTimeout clearText, 500
  startGame: (idx) ->
    @start idx
    @setState idx: idx
  setShake: (value) ->
    guitar.setShake(value)
    localforage.getItem('config', (err, val) ->
      val.vibrate = value
      localforage.setItem('config', val, (err, res) -> )
    )
  start: (idx) ->
    elem = levelsDB.getData()[idx]
    data = 
      song: elem.path
      music:
        notes: elem.notes
        height: elem.height
        type: elem.type
        level: elem.level
      onFinish: @finishGame,
      onHit: @showText
    guitar.start data
    @setState 
      songName: elem.title
      level: elem.level
  restart: (modal)->
    modal.trigger 'closeModal'
    @start @state.idx
  openModal: ->
    console.log 'openModal'
    guitar.stop()
    @state.modalMenu.trigger 'openModal'
  finishModal: ->
    @state.modalFinish.trigger 'openModal'
  changeSong: (modal) ->
    modal.trigger 'closeModal'
    @props.changeTab('Game', 'SongList')
  resume: ->
    @state.modalMenu.trigger 'closeModal'
    guitar.resume()
  finishGame: (points)->
    data =
      points: points
      idx: @state.idx
    Dispatcher.execute 'updatePoints', data
    setTimeout @finishModal, 1000
    @setState points: points
  render: ->
    className = 'game tabs '+@props.show
    <div className = {className}>
      <div 
        ref = 'hitText'
        className = 'hit-text'>
        {@state.hitText}
      </div>
      <div className = 'pull-left song-title'>
        {@state.songName}
      </div>
      <div className = 'pull-left song-level'>
        {@state.level}
      </div>
      <div
        className = 'open-menu pull-right'
        onTouchStart = {@openModal} >
        <span className = 'icon-pause'></span>
      </div>
      <div className = 'clear'></div>
      <canvas 
        id = 'screen' 
        width = '300' 
        height = '400'>
      </canvas>
      <div
        className = 'modal finish-menu'
        id = 'modalFinish' >
        <div className = 'points'>
          Level Complete
        </div>
        <div className = 'points'>
          {@state.points} points
        </div>
        <div 
          className = 'option'
          onTouchEnd = {@changeSong.bind(null, @state.modalFinish)}>
          Songs list
        </div>
        <div 
          className = 'option'
          onTouchEnd = {@restart.bind(null, @state.modalFinish)}>
          Restart
        </div>
      </div>
      <div 
        className = 'modal menu' 
        id = 'modalMenu' >
        <div 
          className = 'option'
          onTouchEnd={@changeSong.bind(null, @state.modalMenu)}>
          Songs list
        </div>
        <div 
          className = 'option'
          onTouchEnd={@restart.bind(null, @state.modalMenu)}>
          Restart
        </div>
        <div 
          className = 'option'
          onTouchEnd={@resume}>
          Resume
        </div>
      </div>
    </div>
