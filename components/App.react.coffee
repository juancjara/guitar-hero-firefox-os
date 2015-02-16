React = require 'react'

MainMenu = require './MainMenu.react.coffee'
SongList = require './SongList.react.coffee'
About = require './About.react.coffee'
Game = require './Game.react.coffee'
Vote = require './Vote.react.coffee'
Settings = require './Settings.react.coffee'
{Dispatcher} = require './../dispatcher.coffee'

module.exports = App = React.createClass
  getInitialState: ->
    tabs:
      'MainMenu':
        show: 'show'
      'Settings':
        show: ''
      'Vote':
        show: '' 
      'About':
        show: ''      
      'SongList':
        show: ''
      'Game':
        show: ''
        data: null
  componentDidMount: ->
    console.log 'all'
  changeTab: (from, to) ->
    tabs = @state.tabs
    tabs[from].show = ''
    tabs[to].show = 'show'
    @setState tabs: tabs
  render: ->
    <div>
      <MainMenu 
        changeTab = {@changeTab} 
        show = @state.tabs['MainMenu'].show />
      <SongList 
        changeTab = {@changeTab} 
        show = @state.tabs['SongList'].show />
      <About 
        changeTab = {@changeTab} 
        show = @state.tabs['About'].show />
      <Vote 
        changeTab = {@changeTab} 
        show = @state.tabs['Vote'].show />
      <Settings 
        changeTab = {@changeTab} 
        show = @state.tabs['Settings'].show />
      <Game 
        changeTab = {@changeTab} 
        show = @state.tabs['Game'].show />
    </div>