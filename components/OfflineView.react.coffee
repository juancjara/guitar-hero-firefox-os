React = require 'react'

OfflineView = React.createClass
  handleClick: () ->
    @props.retry()
  render: ->
    <div className = 'offline' >
      <h1 className = 'text-center' >Internet required</h1>
      <button 
        className = 'btn green'
        onClick = {@handleClick}>
        Retry
      </button>
    </div>

module.exports = OfflineView