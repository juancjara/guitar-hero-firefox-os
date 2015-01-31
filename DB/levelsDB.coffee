data = 
  [
    {
      'title': 'Otherside'
      'path': 'music/otherside.ogg'
      'easy' :
        'height': 50
        'notes': [
          {x: 44, y: 0}
          {x: 38, y: 1}
          {x: 35, y: 1}
          {x: 30, y: 1}
          {x: 40, y: 3}
        ]
      'medium':
        'height': 50
        'notes': [
          {x: 38, y: 0}
          {x: 30, y: 1}
          {x: 40, y: 3}
        ]
    },
    {
      'title': 'another'
      'path': 'music/another.ogg'
      'easy': 
        'height': 10
        'notes': [
          {x: 5, y: 0}
        ]
      'medium': 
        'height': 50
        'notes': [
          {x: 38, y: 0}
          {x: 30, y: 1}
          {x: 40, y: 3}
        ]
    } 
  ]


levelsDB  = (() ->
  getData: ->
    return data)()

module.exports.levelsDB = levelsDB;