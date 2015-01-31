React = require 'react'
MainMenu = require './MainMenu.react.coffee'
SongList = require './SongList.react.coffee'
Help = require './Help.react.coffee'
About = require './About.react.coffee'
Game = require './Game.react.coffee'
{Dispatcher} = require './../dispatcher.coffee'

module.exports = App = React.createClass
  getInitialState: ->
    tabs:
      'MainMenu':
        show: 'show'
      'Help':
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
      <Help 
        changeTab = {@changeTab} 
        show = @state.tabs['Help'].show />
      <About 
        changeTab = {@changeTab} 
        show = @state.tabs['About'].show />
      <Game 
        changeTab = {@changeTab} 
        show = @state.tabs['Game'].show />
    </div>