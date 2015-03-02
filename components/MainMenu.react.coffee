React = require 'react'

module.exports = MainMenu = React.createClass
  handleClick: (to) ->
    console.log('ggwp')
    @props.changeTab('MainMenu', to)
  render: ->
    className = 'main-menu tabs '+@props.show
    <div className = {className}>
      <h1>Guitar Heroes</h1>
      <div 
        className = 'btn blue'
        onTouchEnd = {@handleClick.bind(this, 'SongList')} >
        Start
      </div>
      <span
        className = 'btn-icon blue icon-trophy'
        onTouchEnd = {@handleClick.bind(this, 'Ranking')} >
      </span>
      <span
        className = 'btn-icon blue icon-settings'
        onTouchEnd = {@handleClick.bind(this, 'Settings')} >
      </span>
      <span 
        className = 'btn-icon blue icon-info'
        onTouchEnd = {@handleClick.bind(this, 'About')} >
      </span>
      <div
        className = 'btn green'
        onTouchEnd = {@handleClick.bind(this, 'Vote')} >
        Vote
      </div>
    </div>
