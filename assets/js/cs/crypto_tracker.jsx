import React from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter as Router, Route } from 'react-router-dom';
import FollowedCurrencies from './followed_currencies';
import Nav from './nav';

export default function crypto_tracker_init(root, channel, state) {
  ReactDOM.render(<CryptoTracker channel={channel} state={state} />, root);
}

class CryptoTracker extends React.Component {
  constructor(props) {
    super(props);
    this.channel = this.props.channel;
    this.state = this.props.state;
    this.props.channel.on("update", state => {
      var newState = this.state;
      newState.btc = state.btc;
      newState.eth = state.eth;
      newState.ltc = state.ltc;
      this.setState(newState);
    });
  }

  updateUser(user) {
    this.setState({user: user.user});
  }

  refresh() {
    var channel = this.props.channel.push("get_currency", {"currency_id": null});
    channel.receive("ok", state => {
      this.setState(state);
    });
  }

  render() {
    return (
      <div>
        <Nav user={this.state.user}/>
        <div className="row">
          <div className="col-lg">
            <FollowedCurrencies prices={this.state} channel={this.channel} updateUser={this.updateUser.bind(this)}/>
          </div>
        </div>
      </div>
    );
  }
}
