React = require 'react'
{levelsDB} = require './../DB/levelsDB.coffee'
{Dispatcher} = require './../dispatcher.coffee'

SongItem = React.createClass
  handleClick: (idx)->
    this.props.handleClick('Game',idx)
  render: ->
    <li 
      className = 'song-item'
      key = {@props.key}>
      <span className = 'icon-music' ></span>
      <span className = 'title' onTouchEnd={@handleClick.bind(this, @props.idx)} >
        {@props.item.title}
      </span>
      <span className = 'level'>
        {@props.item.level}
      </span>
      <div className = 'points' >
        {@props.item.points} points
      </div>
    </li>


module.exports = SongList = React.createClass
  getInitialState: ->
    Dispatcher.subscribe 'updatePoints', @updatePoints

    points: 0
    songs : levelsDB.getData()
  back: (to) ->
    @props.changeTab 'SongList', to
  handleClick: (to, data) ->
    @back to
    Dispatcher.execute 'startGame', data
  updatePoints: (data) ->
    songs = @state.songs
    points = @state.points
    points = points - songs[data.idx].points + data.points
    songs[data.idx].points = data.points
    localforage.getItem('musicPoints').then (musicPoints) ->
      musicPoints[data.idx] = data.points
      localforage.setItem('musicPoints', musicPoints).then (value) ->
        return
    @setState 
      songs: songs
      points: points
    return
  componentDidMount: ->
    songs = @state.songs
    points = 0
    self = @
    localforage.getItem 'musicPoints', (err, musicPoints) ->
      console.log 'songlist localforage', musicPoints
      i = 0
      while i < musicPoints.length
        points += musicPoints[i]
        songs[i].points = musicPoints[i]
        i++
      if self.isMounted()
        self.setState 
          songs: songs
          points: points
    return
  render: ->
    className = 'song-list tabs '+@props.show
    <div className = {className}>
      <div 
        className = 'btn blue pull-left'
        onTouchEnd={@back.bind(@, 'MainMenu')}>
        Menu
      </div>
      <div className = 'pull-right total-points' >
        Points: {@state.points}
      </div>
      <div className = 'clear' ></div>
      <h2 className = 'text-center'>
        Songs
      </h2>
      <ul 
        className = 'clear-list songs' >
        {@state.songs.map((item, i) ->
          <SongItem 
            key = {i}
            idx = {i}
            item = {item}
            handleClick = {@handleClick} />
        , @)}
      </ul>
    </div>
