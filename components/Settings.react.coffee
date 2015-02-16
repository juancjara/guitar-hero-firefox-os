React = require 'react'
{Dispatcher} = require './../dispatcher.coffee'

module.exports = Settings = React.createClass
  getInitialState: ->
    vibrate: false 
  componentDidMount: ->
    self = @
    localforage.getItem('config', (err, val) ->
      self.setState vibrate: val.vibrate
    )
  handleClick: (to) ->
    @props.changeTab('Settings', to)
  onChange: (val) ->
    @setState vibrate: val
    Dispatcher.execute 'setShake', val
  render: ->
    className = 'settings tabs '+@props.show
    vibrate = [];
    vibrate[0] = @state.vibrate == false
    vibrate[1] = !vibrate[0]
    <div className = {className}>
      <div 
        className = 'btn blue pull-left'
        onTouchEnd={@handleClick.bind(this, 'MainMenu')}>
        Menu
      </div>
      <div className = 'clear' ></div>
      <h2 className = 'text-center'>Settings</h2>
      <ul className = 'clear-list text-center'>
        <li>Vibration</li>
        <li>
            <div className = 'container'>
              <div className = 'switch white'>
                <input 
                  type = 'radio' 
                  name = 'switch' 
                  id = 'switch-off' 
                  onChange = {this.onChange.bind(this, false)}
                  checked = {vibrate[0]} />
                <input 
                  type = 'radio' 
                  name = 'switch' 
                  id = 'switch-on' 
                  onChange = {this.onChange.bind(this, true)}
                  checked = {vibrate[1]} />
                <label htmlFor = 'switch-off' >Off</label>
                <label htmlFor = 'switch-on' >On</label>
                <span className = 'toggle' />
              </div>
            </div>
        </li>
      </ul>
    </div>
