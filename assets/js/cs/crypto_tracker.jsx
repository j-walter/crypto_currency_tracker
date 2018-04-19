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
  }

  updateUser(user) {
    console.log("Set user: " + user);
    this.setState(Object.assign({}, user), () => console.log(this.state));
    console.log(this.state.user);
    // this.refresh();
  }

  refresh() {
    var channel = this.props.channel.push("get_currency", {"currency_id": null});
    channel.receive("ok", state => {
      this.setState(state);
      // return;
    });
  }

  render() {
    console.log("STATE", this.state);
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
