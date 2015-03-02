React = require 'react'
CreateUser = require './CreateUser.react.coffee'
RankingList = require './RankingList.react.coffee'
OfflineView = require './OfflineView.react.coffee'
Loader = require './Loader.react.coffee'
{ParseMng} = require './../DB/ParseMng.coffee'

module.exports = Ranking = React.createClass
  getInitialState: ->
    view: null

  componentWillUpdate: (nextProps, nextState) ->
    @manageFlow() if nextProps.show == 'show' and @props.show == ''

  manageFlow: () ->
    @verifyConection()
  
  verifyConection: () ->
    online = online = window.navigator.onLine
    if online
      @userExists()
    else
      @setState view: <OfflineView retry = {@verifyConection} />

  userExists: () ->
    @setState view: <Loader step = 0 />
    self = @
    localforage.getItem('idUser').then((val) ->
      if val
        self.updatePoints(val)
      else
        self.setState view: <CreateUser updatePoints = {self.updatePoints}/>
    )

  updatePoints: (idUser) ->
    @setState view: <Loader step = 1 />
    self = @
    localforage.getItem 'musicPoints', (err, musicPoints) ->
      points = 0
      i = 0
      while i < musicPoints.length
        points += musicPoints[i]
        i++
      ParseMng.updateUser(idUser, points, self.getDataView)

  getDataView: (err, userUpdated) ->
    return console.log(err) if err?
    user = 
      id: userUpdated.id
      points: userUpdated.get('points')
      username: userUpdated.get('username')
    @setState view: <RankingList user = {user} />

  handleClick: (to) ->
    @props.changeTab('Ranking', to)

  render: ->
    className = 'ranking tabs '+@props.show
    <div className = {className}>
      <div 
        className = 'btn blue pull-left'
        onTouchEnd={@handleClick.bind(this, 'MainMenu')}>
        Menu
      </div>
      <h2 className = 'pull-left'>Ranking</h2>
      <div className = 'clear' ></div>
      {@state.view}
    </div>
