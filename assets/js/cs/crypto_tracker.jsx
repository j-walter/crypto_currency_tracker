import React from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter as Router, Route } from 'react-router-dom';
import FollowedCurrencies from './followed_currencies';

export default function crypto_tracker_init(root, channel, state) {
  ReactDOM.render(<CryptoTracker channel={channel} state={state} />, root);
}

class CryptoTracker extends React.Component {
  constructor(props) {
    super(props);
    this.channel = this.props.channel;
    this.state = this.props.state;
  }

  refresh() {
    var channel = this.props.channel.push("get_currency", {"currency_id": null});
    channel.receive("ok", state => {
      this.setState(state);
      return;
    });
  }

  render() {
    console.log("STATE", this.state);
    return (
      <div className="row">
        <FollowedCurrencies prices={this.state}/>
      </div>
    );
  }
}

// let CryptoTracker = connect((state) => state)((props) => {
//   return (
//     <Router>
//       <div>
//         <Nav />
//         <div className="container">
//           <Route path="/" exact={true} render={() =>
//             <div>
//               {/* variable props.currencies will be  */}
//               <FollowedCurrencies our_token={props.token}
//                 bitcoin={_.filter(props.currencies, (pp) =>
//                   match.params.bitcoin == "True")
//                 }
//                 ethereum={_.filter(props.currencies, (pp) =>
//                   match.params.ethereum == "True")
//                 }
//                 litecoin={_.filter(props.currencies, (pp) =>
//                   match.params.litecoin == "True")
//                 } />
//             </div>
//           } />
//           {/* <Route path="/users" exact={true} render={() =>
//             <Users users={props.users} />
//           } /> */}
//           {/* <Route path="/users/:user_id" render={({ match }) =>
//
//           } /> */}
//         </div>
//       </div>
//     </Router>
//   );
// });
