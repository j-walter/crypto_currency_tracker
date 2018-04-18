import React from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter as Router, Route } from 'react-router-dom';
import FollowedCurrencies from './followed_currencies';

export default function crypto_tracker_init(root, channel) {
  ReactDOM.render(<CryptoTracker channel={channel} />, root);
}

class CryptoTracker extends React.Component {
  constructor(props) {
    super(props);
    this.channel = props.channel;
    this.state = {"btc": 0, "eth": 0, "ltc": 0};

    this.channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) });
  }

  render() {
    return (
      <div className="row">
        <FollowedCurrencies />
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
