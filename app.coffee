React = require 'react'
App = require './components/App.react.coffee'
{levelsDB} = require './DB/levelsDB.coffee'
{ParseMng} = require './DB/ParseMng.coffee'

checkLocalForage = (field, defValue, cb) ->
  setValue = (res) ->
    if res
      cb()
    else
      localforage.setItem(field, defValue). then cb
  localforage.getItem(field).then setValue

initData = () ->
  len = levelsDB.getData().length
  musicPoints = []
  i = 0
  while i < len
    musicPoints.push(0)
    i++
  return musicPoints

initialize = (value) ->
  React.initializeTouchEvents(true);
  React.render <App />, document.getElementById('react-app')
  return

setConfig = () ->
  checkLocalForage('config', {vibrate: false}, initialize)

checkLocalForage('musicPoints', initData(), setConfig)

