import '../css/app.scss';

import 'phoenix_html';

import React from 'react';
import ReactDOM from 'react-dom';

import App from './App';

const app = document.getElementById('app');
if (app) {
  ReactDOM.render(React.createElement(App), app);
}
