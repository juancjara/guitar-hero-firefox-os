React = require 'react'
{Dispatcher} = require './../dispatcher.coffee'

module.exports = Vote = React.createClass
  componentDidMount: ->
    console.log 'Vote'
  handleClick: (to) ->
    @props.changeTab('Vote', to)
  render: ->
    className = 'vote tabs '+@props.show
    <div className = {className}>
      <div 
        className = 'btn blue pull-left'
        onTouchEnd={@handleClick.bind(this, 'MainMenu')}>
        Menu
      </div>
      <div className = 'clear' ></div>
      <h2 className = 'text-center'>More apps</h2>
      <ul className = 'clear-list text-center'>
        <li>
          <span>Rank this app, click the start</span>
          <a className = 'rank' target = '_blank' 
            href = 'https://marketplace.firefox.com/app/guitar-heroes-2/' >
            <span className = 'icon-star' />
          </a>
        </li>        
        <li>
          If you have any idea for a new app or you want 
          an Android app on Firefox Market send me and email. 
          I will do my best.
        </li>
        <li>
          Si tienes alguna idea para alguna app o quieres una 
          aplicación de Android para tu Firefox OS envíame un email.
        </li>
        <li>juanc.jara@pucp.pe</li>
      </ul>
    </div>
