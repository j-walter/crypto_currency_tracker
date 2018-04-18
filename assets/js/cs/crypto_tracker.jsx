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
    this.state = {};

    this.channel.join()
    .receive("ok", this.setPrices.bind(this))
    .receive("error", resp => { console.log("Unable to join", resp) });
  }

  setPrices(prices) {
    console.log("Received prices", prices);
    this.setState(_.extend(this.state, prices));
    //console.log("STATE", this.state["btc"]["sell"]["current"]); //TODO: take this out

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
