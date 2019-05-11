import React from 'react'
import PropTypes from 'prop-types'
import { ActionCableConsumer } from 'react-actioncable-provider'


class Game extends React.Component {
  constructor(props) {
    super(props);
    this.handleGameTick = this.handleGameTick.bind(this);

    this.killMusic = new Audio('./sounds/kill.wav');
    this.foodPickupMusic = new Audio('./sounds/chomp.wav');

    this.state = {};
  }

  handleGameTick(data) {
    this.setState({game: data});

    this.playEvents()
  }

  playEvents() {
    this.state.game.events.forEach(event => {
      switch (event.type) {
        case 'kill':
          this.killMusic.play()
          break;
        case 'food_pickup':
          this.foodPickupMusic.play()
          break;
      }
    });
  }

  componentDidMount() {
    this.fetchMap();
  }

  renderRow(row, yPosition, entityProps) {
    return (
      <div key={"row" + yPosition} className="row">
        {row.map((tile, xPosition) => this.renderTile(xPosition, yPosition, tile, entityProps[yPosition][xPosition]))}
      </div>
    );
  }

  renderTile(x, y, tile, entityProps) {
    return (
      <div key={"tile" + x + "." + y} className={"tile " + (tile == "#" ? "wall" : "")}>{this.renderEntity(entityProps)}</div>
    );
  }

  calculateEntityProps() {
    let arr = new Array(this.state.map.length);
    for(let i = 0; i < arr.length; i++) {
      arr[i] = new Array(this.state.map[0].length);
    }

    const items = this.items();

    for(let i = 0; i < items.length; i ++) {
      const currentItem = items[i];

      arr[currentItem.position.y][currentItem.position.x] = {
        entityType: currentItem.itemType,
        className: currentItem.itemType,
        icon: this.iconForItem(currentItem)
      }
    }

    const aliveSnakes = this.aliveSnakes();
    for(let i = 0; i < aliveSnakes.length; i ++) {
      let currentSnake = aliveSnakes[i]
      arr[currentSnake.head.y][currentSnake.head.x] = {
        entityType: "snake",
        name: currentSnake.name,
        color: currentSnake.color,
        className: "head"
      }

      currentSnake.body.map((segment) => { arr[segment.y][segment.x] = {entityType: "snake", color: currentSnake.color, className: "body"} })
    }

    return arr;
  }

  iconForItem(item) {
    if (item.itemType == 'food') {
      return '🍕';
    } else {
      return '?';
    }
  }

  renderSnakeName(name) {
    if (name) {
      return (<div className="snake-name">{name}</div>);
    } else {
      return null;
    }
  }

  renderEntity(entityProps) {
    if (entityProps) {
      if (entityProps.entityType == "snake") {
        return (
          <div className={"snake " + entityProps.className} style={{backgroundColor: entityProps.color}}>
            {this.renderSnakeName(entityProps.name)}
          </div>
        )
      } else {
        return (
          <div className={"entity " + entityProps.className}>
            {entityProps.icon}
          </div>
        )
      }
    } else {
      return null;
    }
  }

  items() {
    if (this.state.game) {
      return this.state.game.items;
    } else {
      return [];
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
      const entityProps = this.calculateEntityProps();
      return this.state.map.map((row, index) => this.renderRow(row, index, entityProps))
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
      <li key={"leaderboard" + entry.id} className={entry.isAlive ? "alive" : "dead"}>
        <span className="name">{entry.name}</span>
        <span className="length">{entry.length}</span>
      </li>
    );
  }

  render() {
    return (
      <div className="container">
        {
          this.acc || (this.acc = <ActionCableConsumer
             channel='ClientChannel'
             onReceived={this.handleGameTick}
          />)
        }
        <div className="map">
          {this.renderMap()}
        </div>
        <div className="leaderboard">
          <h1>Snek.</h1>
          {this.renderLeaderboard()}
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
