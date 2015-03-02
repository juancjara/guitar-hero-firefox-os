React = require('react')
Loader = require './Loader.react.coffee'
{ParseMng} = require './../DB/ParseMng.coffee'

RankingItem = React.createClass
  render: ->
    item = @props.item
    <tr>
      <td>{item.position}</td>
      <td>{item.name}</td>
      <td>{item.points}</td>
    </tr>


RankingList = React.createClass
  getInitialState: ->
    people: []
    rank: null
    topMe: null
    info: <Loader step = 2 />
  updateData: ->
    self = @
    ParseMng.getUsers (err, data) ->
      arr = []
      i = 0
      while i < data.length
        arr.push
          points: data[i].get('points')
          name: data[i].get('username')
        i++
      i = data.length
      while i < 10
        arr.push
          points: '-'
          name: '-'
        i++
      self.setState 
        people: arr
        info: null

    points = @props.user.points

    ParseMng.getRank(points, (err, data) ->
      self.setState rank: data
    )

  componentDidMount: ->
    @updateData()

  render: ->
    arr = ['show', 'hide']
    idx = @state.info == null ? 0: 1   
    classTable = 'rankings ' + arr[idx]

    if @state.rank?
      viewRank = (
        <div className = 'my-data' >
          <div> Hello {@props.user.username}</div>
          <div> Your actual rank is: {@state.rank}</div>
          <div> Your points are: {@props.user.points}</div>
        </div>
      )

    <div>
      <table className = {classTable}>
        <thead>
          <tr>
            <th>Rank</th>
            <th>Name</th>
            <th>Points</th>
          </tr>
        </thead>
        <tbody>
          {@state.people.map (item, i) ->
            item.position = i + 1
            <RankingItem 
              key = {i}
              item = {item} />
          }
        </tbody>
      </table>
      {@state.info}
      {viewRank}
    </div>

module.exports = RankingList