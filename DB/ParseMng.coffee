ParseMng = (() ->
  Parse.initialize("YiujpEcIch86xDgsFFjQIsps3jvCimK9jarh4VBf", "GVuyJ8WqfzX8Wl2M4PCeXLiJujQvSMHpIYO260OI");

  UserSchema = Parse.Object.extend 'UserSchema'

  handler = (cb) ->
    res = 
      success: (obj) -> cb(null, obj)
      error: (obj, err) -> cb(err)

  handlerQuery = (cb) ->
    res = 
      success: (obj) -> cb(null, obj)
      error: (err) -> cb(err)

  addUser = (name, cb) ->
    query = new Parse.Query UserSchema
    query.equalTo 'username', name
    query.count(
      success: (obj) -> 
        if obj > 0
          err = 
            code: '9999'
            message: 'Name already used'
          return cb(err)

        user = new UserSchema()
        data = 
          username: name,
          points: 0
        user.save(data, handler(cb))

      error: (err) ->
        return cb(err)
    ) 

  updateUser = (id, points, cb) ->
    query = new Parse.Query(UserSchema)

    update = (err, user) ->
      return cb(err) if err
      user.set('points', points)
      console.log('updateUser')
      user.save(null, handler(cb))

    query.get(id, handlerQuery(update))  

  getRank = (points, cb) ->
    query = new Parse.Query(UserSchema)
    query.descending('points')
    query.greaterThan('points', points)
    query.count handlerQuery(cb)

  getUsers = (cb) ->
    query = new Parse.Query(UserSchema)
    query.limit(10)
    query.descending('points')
    query.find handlerQuery(cb)

  getTopPlayer = (points, cb) ->
    query = new Parse.Query(UserSchema)
    query.limit(1)
    query.greaterThan('points', points)
    query.ascending('points')
    query.find handlerQuery(cb)

  return {
    addUser: addUser
    updateUser: updateUser
    getUsers: getUsers
    getRank: getRank
    getTopPlayer: getTopPlayer
  }
)()

module.exports.ParseMng = ParseMng