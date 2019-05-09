import React from 'react'
import PropTypes from 'prop-types'
import { ActionCableConsumer } from 'react-actioncable-provider'


class Game extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  handleGameTick = (data) => {
    console.log(data)
    this.setState({game: data});
  }

  componentDidMount() {
    this.fetchMap();
  }

  renderRow(row, yPosition) {
    return (
      <div key={"row" + yPosition} className="row">
        {row.map((tile, xPosition) => this.renderTile(xPosition, yPosition, tile))}
      </div>
    );
  }

  renderTile(x, y, tile) {
    return (
      <div key={"tile" + x + "." + y} className={"tile " + (tile == "#" ? "wall" : "")}>
        {this.renderSnakeSegment(x, y)}
      </div>
    );
  }

  snakeProps() {
    let arr = new Array(this.state.map.length);
    for(let i = 0; i < arr.length; i++) {
      arr[i] = new Array(this.state.map[0].length);
    }
  }

  renderSnakeSegment(x, y) {
    let snake = this.aliveSnakes().find(snake =>  snake.head.x == x && snake.head.y == y)

    if (snake) {
      return (
        <div className="snake head" style={{backgroundColor: snake.color}}><div className="snake-name">{snake.name}</div></div>
      );
    } else {
      snake = this.aliveSnakes().find(snake => snake.body.find(segment => segment.x == x && segment.y == y))

      if (snake) {
        return (<div className="snake body" style={{backgroundColor: snake.color}}></div>);
      } else {
        return null;
      }
    }
  }

  aliveSnakes() {
    if (this.state.game) {
      return this.state.game.alive_snakes;
    } else {
      return [];
    }
  }


  renderMap() {
    if (this.state.map) {
      return this.state.map.map((row, index) => this.renderRow(row, index))
    } else {
      return (<div>Waiting for data</div>);
    }
  }

  renderLeaderboard() {
    if (this.state.game) {
      const entries = this.state.game.leaderboard.map((entry) => this.renderLeaderboardEntry(entry));
      return (
        <ol>
          {entries}
        </ol>
      );
    } else {
      return null;
    }
  }

  renderLeaderboardEntry(entry) {
    return (
      <li>
        <span className="name">{entry.name}</span>
        <span className="length">{entry.length}</span>
      </li>
    );
  }

  render() {
    return (
      <div className="container">
        <ActionCableConsumer
          channel={{channel: 'ClientChannel'}}
          onReceived={this.handleGameTick}
        >
          <div className="map">
            {this.renderMap()}
          </div>
          <div className="leaderboard">
            <h1>Snek.</h1>
            {this.renderLeaderboard()}
          </div>
        </ActionCableConsumer>
      </div>
    );
  }

  fetchMap = () => {
    let xhr = new XMLHttpRequest();
    xhr.open('GET', 'map')
    xhr.onload = () => {
      const map = JSON.parse(xhr.responseText)
      if (map["message"]){
        // No map available - try again later
        console.log("No map available yet", map)
        setTimeout(fetchMap, 5000);
      }
      else {
        this.setState({map: map})
      }
    }

    xhr.send()
  }
}

export default Game;