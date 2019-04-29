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

  renderRow(row, rowIndex) {
    return (
      <div key={"row" + rowIndex} className="row">
        {row.map((col, index) => <div key={"col" + rowIndex + index} className={"tile " + (col == "#" ? "wall" : "")}></div>)}
      </div>
    );
  }
  renderMap() {
    if (this.state && this.state.map) {
      return this.state.map.map((row, index) => this.renderRow(row, index))
    } else {
      return (<div>Waiting for data</div>);
    }
  }

  renderSnakes() {
    if (this.state.game && this.state.game.alive_snakes) {
      return this.state.game.alive_snakes.map(snake => this.renderSnake(snake))
    }
  }

  renderSnake(snake) {
    return (<div>{snake.head.x},{snake.head.y}</div>);
  }

  render() {
    return (
      <div>
        <ActionCableConsumer
          channel={{channel: 'ViewerChannel'}}
          onReceived={this.handleGameTick}
        />
        <div className="map">
          {this.renderMap()}
        </div>
        <div className="leaderboard">
          {this.renderSnakes()}
        </div>
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