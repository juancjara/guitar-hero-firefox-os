React = require 'react'
App = require './components/App.react.coffee'
{levelsDB} = require './DB/levelsDB.coffee'

initialize = (value) ->
  React.initializeTouchEvents(true);
  React.render <App />, document.getElementById('react-app')
  return

initData = (value) ->
  len = levelsDB.getData().length
  musicPoints = []
  i = 0
  while i < len
    musicPoints.push(0)
    i++
  localforage.setItem('musicPoints', musicPoints).then initialize

checkFirstTime = (value) ->
  if value
    initialize()
  else
    localforage.clear () ->
      localforage.setItem('firstTime', 'done').then initData
  return

localforage.getItem('firstTime').then checkFirstTime


