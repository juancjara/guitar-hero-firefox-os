React = require 'react'
{levelsDB} = require './../DB/levelsDB.coffee'
{Dispatcher} = require './../dispatcher.coffee'
{Guitar} = require './../guitar.js'

guitar = null

module.exports = Game = React.createClass
  getInitialState: ->
    Dispatcher.subscribe 'startGame', @startGame
    idx: -1,
    modalMenu: null,
    modalFinish: null,
    points: 0,
    hitText: ''
  componentDidMount: ->
    guitar = new Guitar()
    $('.modal').easyModal {
      top: 150
      overlay: 0.2
      overlayClose: false
      closeOnEscape: false 
    }
    @setState 
      modalMenu: $('#modalMenu')
      modalFinish: $('#modalFinish')
  showText: (obj) ->
    console.log 'showText', obj.text
    clearInterval(@timeout) if @timeout?
    @setState hitText: obj.text
    clearText = => @setState hitText: ''
    @timeout = setTimeout clearText, 500
  startGame: (idx) ->
    @start idx
    @setState idx: idx
  start: (idx) ->
    elem = levelsDB.getData()[idx]
    data = 
      song: elem.path
      music: elem.easy
      onFinish: @finishGame,
      onHit: @showText
    guitar.start data
  restart: (modal)->
    modal.trigger 'closeModal'
    @start @state.idx
  openModal: ->
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
      <canvas 
        id = 'screen' 
        width = '300' 
        height = '400'>
      </canvas>
      <div 
        ref = 'hitText'
        className = 'hit-text'>
        {@state.hitText}
      </div>
      <div
        className = 'open-menu'
        onTouchEnd = {@openModal} >
        <span className = 'icon-pause'></span>
      </div>
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
