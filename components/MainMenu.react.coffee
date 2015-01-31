React = require 'react'

module.exports = MainMenu = React.createClass
  componentDidMount: ->
    console.log 'MainMenu'
  handleClick: (to) ->
    @props.changeTab('MainMenu', to)
  render: ->
    className = 'main-menu tabs '+@props.show
    <div className = {className}>
      <h1>Guitar Hero</h1>
      <div 
        className = 'btn blue'
        onTouchEnd = {@handleClick.bind(this, 'SongList')} >
        Start
      </div>
      <div 
        className = 'btn blue'
        onTouchEnd = {@handleClick.bind(this, 'Help')} >
        Help
      </div>
      <div 
        className = 'btn blue'
        onTouchEnd = {@handleClick.bind(this, 'About')} >
        About
      </div>
    </div>
