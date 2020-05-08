// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import '../css/app.scss';

// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import 'phoenix_html';

import React from 'react';
import ReactDOM from 'react-dom';

import App from './App';

const app = document.getElementById('app');
if (app) {
    ReactDOM.render(React.createElement(App), app);
}
