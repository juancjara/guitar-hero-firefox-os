React = require 'react'

module.exports = About = React.createClass
  componentDidMount: ->
    console.log 'About'
  handleClick: (to) ->
    @props.changeTab('About', to)
  render: ->
    className = 'about tabs '+@props.show
    <div className = {className}>
      <div 
        className = 'btn blue pull-left'
        onTouchEnd={@handleClick.bind(this, 'MainMenu')}>
        Menu
      </div>
      <div className = 'clear' ></div>
      <h2 className = 'text-center'>About</h2>
      <ul className = 'clear-list text-center'>
        <li>Developed by JCJ</li>
        <li>Report bugs or suggestions to my email</li>
        <li>juanc.jara@pucp.pe</li>
      </ul>
    </div>
