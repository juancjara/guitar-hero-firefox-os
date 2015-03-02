React = require('react')
{ParseMng} = require './../DB/ParseMng.coffee'
Loader = require './/Loader.react.coffee'

CreateUser = React.createClass
  getInitialState: ->
    name: ''
    info: null
    error: ''
  handleChange: (e) ->
    @setState
      name: e.target.value
      error: ''
  onSubmit: (e)->
    e.preventDefault()
    username = @state.name

    if username == ''
      @setState error: 'Username is required'
      return

    if username.length >= 15
      @setState error: 'No more than 15 caracters'
      return

    self = @
    @setState info: <Loader step = 3 />
    ParseMng.addUser(username, (err, res) ->
      self.setState info: null
      if err?
        self.setState error: err.message
        return 
      idUser = res.id
      console.log('id', idUser)
      localforage.setItem('idUser', idUser).then self.props.updatePoints
    )
  render: ->
    <div className = 'create-user' >
      <h3 className = 'text-center' >Create a new user</h3>
      <form onSubmit = {this.onSubmit}>
        <label htmlFor = 'username'>Username</label>
        <input 
          type = 'text' 
          id = 'username'
          value = {@state.name} 
          onChange = {@handleChange} />
        <div className = 'error'>{@state.error}</div>
        <button className = 'btn green pull-right'>Create</button>
        <div className = 'clear' ></div>
      </form>
      {@state.info}
    </div>

module.exports = CreateUser