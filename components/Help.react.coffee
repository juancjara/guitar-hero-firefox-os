React = require 'react'

module.exports = Help = React.createClass
  handleClick: (to) ->
    @props.changeTab('Help', to)
  render: ->
    className = 'help tabs '+@props.show
    <div className = {className}>
      <div 
        className = 'btn blue pull-left'
        onTouchEnd={@handleClick.bind(this, 'MainMenu')}>
        Menu
      </div>
      <div className = 'clear' ></div>
      <h2>Help</h2>
    </div>
