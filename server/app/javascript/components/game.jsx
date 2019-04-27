import React from 'react'
import PropTypes from 'prop-types'
import { ActionCableConsumer } from 'react-actioncable-provider'


class Game extends React.Component {
  handleGameTick(data) {
    console.log("YAYAYAY", data);
  }
  render() {
    return (
      <div>
        <ActionCableConsumer
          channel={{channel: 'ViewerChannel'}}
          onReceived={this.handleGameTick}
        />
        <div>Hello Game</div>
      </div>
    );
  }
}

export default Game;