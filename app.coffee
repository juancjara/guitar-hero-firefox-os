React = require 'react'
App = require './components/App.react.coffee'

initialize = (value) ->
  React.initializeTouchEvents(true);
  React.render <App />, document.getElementById('react-app')
  return

initData = (value) ->
  musicPoints = [0, 0]
  localforage.setItem('musicPoints', musicPoints).then initialize

checkFirstTime = (value) ->
  if value
    console.log 'hay'
    initialize()
  else
    console.log 'no hay'
    localforage.clear () ->
      localforage.setItem('firstTime', 'done').then initData
  return

localforage.getItem('firstTime').then checkFirstTime


