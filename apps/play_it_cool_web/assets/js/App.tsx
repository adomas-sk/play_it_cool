import React from 'react';
import {
	Router,
	Switch,
	Route,
} from 'react-router-dom';
import { createBrowserHistory } from 'history';

const history = createBrowserHistory({basename: '/web'});

const App: React.FC = () => {
	return (
		<Router history={history}>
			<Switch>
				<Route exact path="/">
					Hello
				</Route>
				<Route exact path="/login">
					Login
				</Route>
                <Route>
                    NONO
                </Route>
			</Switch>
		</Router>
	);
};

export default App;
