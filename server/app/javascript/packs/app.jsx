import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import { ActionCableProvider } from 'react-actioncable-provider'
import Game from '../components/game';

const API_WS_ROOT = "ws://" + window.snek_host + "/cable";

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <ActionCableProvider url={API_WS_ROOT}>
      <Game name="React" />
    </ActionCableProvider>,
    document.body.appendChild(document.createElement('div')),
  )
})
