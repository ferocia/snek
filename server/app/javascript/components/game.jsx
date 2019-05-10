import React from 'react'
import PropTypes from 'prop-types'
import { ActionCableConsumer } from 'react-actioncable-provider'


class Game extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  handleGameTick = (data) => {
    this.setState({game: data});
  }

  componentDidMount() {
    this.fetchMap();
  }

  renderRow(row, yPosition, snakeProps) {
    return (
      <div key={"row" + yPosition} className="row">
        {row.map((tile, xPosition) => this.renderTile(xPosition, yPosition, tile, snakeProps[yPosition][xPosition]))}
      </div>
    );
  }

  renderTile(x, y, tile, snakeProps) {
    return (
      <div key={"tile" + x + "." + y} className={"tile " + (tile == "#" ? "wall" : "")}>
        {this.renderSnakeSegment(snakeProps)}
      </div>
    );
  }

  calculateSnakeProps() {
    let arr = new Array(this.state.map.length);
    for(let i = 0; i < arr.length; i++) {
      arr[i] = new Array(this.state.map[0].length);
    }

    const aliveSnakes = this.aliveSnakes();
    for(let i = 0; i < aliveSnakes.length; i ++) {
      let currentSnake = aliveSnakes[i]
      arr[currentSnake.head.y][currentSnake.head.x] = {
        name: currentSnake.name,
        color: currentSnake.color,
        className: "head"
      }

      currentSnake.body.map((segment) => { arr[segment.y][segment.x] = {color: currentSnake.color, className: "body"} })
    }
    return arr;
  }

  renderSnakeName(name) {
    if (name) {
      return (<div className="snake-name">{name}</div>);
    } else {
      return null;
    }
  }

  renderSnakeSegment(snakeProps) {
    if (snakeProps) {
      return (
        <div className={"snake " + snakeProps.className} style={{backgroundColor: snakeProps.color}}>
          {this.renderSnakeName(snakeProps.name)}
        </div>
      )
    } else {
      return null;
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
      const snakeProps = this.calculateSnakeProps();
      return this.state.map.map((row, index) => this.renderRow(row, index, snakeProps))
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