import React from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter as Router, Route } from 'react-router-dom';
import socket from "./socket";
import Nav from './nav';
import FollowedCurrencies from './followed_currencies';

export default function crypto_tracker_init() {
  ReactDOM.render(
    <CryptoTracker />,
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
