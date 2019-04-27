import React from 'react'
import PropTypes from 'prop-types'
import { ActionCableConsumer } from 'react-actioncable-provider'


class Game extends React.Component {
  handleGameTick = (data) => {
    console.log(data);
    this.setState(data);
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
      </div>
    );
  }
}

export default Game;