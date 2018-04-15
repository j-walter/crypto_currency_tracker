// looked at http://www.ccs.neu.edu/home/ntuck/courses/2018/01/cs4550/notes/19-spa/components.txt
// to understand the component parts

import React from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter as Router, Route } from 'react-router-dom';
import { Provider, connect } from 'react-redux';

import Nav from './nav';
import FollowedCurrencies from './followed_currencies';

export default function crypto_tracker_init(store) {
  ReactDOM.render(
    <Provider store={store}>
      <CryptoTracker />
    </Provider>,
    document.getElementById('root'),
  );
}

let CryptoTracker = connect((state) => state)((props) => {
  return (
    <Router>
      <div>
        <Nav />
        <div className="container">
          <Route path="/" exact={true} render={() =>
            <div>
              {/* variable props.currencies will be  */}
              <FollowedCurrencies our_token={props.token}
                bitcoin={_.filter(props.currencies, (pp) =>
                  match.params.bitcoin == "True")
                }
                ethereum={_.filter(props.currencies, (pp) =>
                  match.params.ethereum == "True")
                }
                litecoin={_.filter(props.currencies, (pp) =>
                  match.params.litecoin == "True")
                } />
            </div>
          } />
          {/* <Route path="/users" exact={true} render={() =>
            <Users users={props.users} />
          } /> */}
          {/* <Route path="/users/:user_id" render={({ match }) =>

          } /> */}
        </div>
      </div>
    </Router>
  );
});
