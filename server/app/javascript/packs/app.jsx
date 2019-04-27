import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import { ActionCableProvider } from 'react-actioncable-provider'
import { API_WS_ROOT } from '../util/constants.js'
import Game from '../components/game';

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <ActionCableProvider url={API_WS_ROOT}>
      <Game name="React" />
    </ActionCableProvider>,
    document.body.appendChild(document.createElement('div')),
  )
})
