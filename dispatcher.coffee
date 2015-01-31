queue = {}
val = 'gg'

module.exports.Dispatcher = {
  subscribe: (name, fun) ->
    queue[name] = fun
  execute: (name, params) ->
    queue[name](params)
}