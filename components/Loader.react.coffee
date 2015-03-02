React = require 'react'

Loader = React.createClass
  getInitialState: ->
    msgs: ['Finding user', 'Updating points', 'Getting leaderboard','Creating user']
  render: ->
    if @props.step?
      info = <div className = 'info' >{@state.msgs[@props.step]}</div>
    <div className= 'loader'>
      <div className = 'container'>
        <img src= "svg/loader.svg" />
        {info}
      </div>
    </div>

module.exports = Loader
