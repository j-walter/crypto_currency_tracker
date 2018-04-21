// followed from Nat Tuck's lecture notes
import React from 'react';
import { Button, Modal, ModalBody, Form, FormGroup, Label, Input, ModalFooter, ModalHeader, ModalProps } from 'reactstrap';
import CryptoCard from './crypto_card';
// import Line from './line';

export default class FollowedCurrencies extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      edit_modal: false,
      display_modal: false
    };
    this.toggle_edit = this.toggle_edit.bind(this);
    this.toggle_disp = this.toggle_disp.bind(this);
  }

  toggle_edit() {
    this.setState({ edit_modal: !this.state.edit_modal });
  }

  toggle_disp() {
    this.setState({ display_modal: !this.state.display_modal });
  }

  followCurrency(curr_id) {
    var channel = this.props.channel.push("follow_currency", { "currency_id": curr_id });
    channel.receive("ok", resp => {
      console.log(resp);
      this.props.updateUser(resp);
    });
  }

  unfollowCurrency(curr_id) {
    var channel = this.props.channel.push("unfollow_currency", { "currency_id": curr_id });
    channel.receive("ok", resp => {
      console.log(resp);
      this.props.updateUser(resp);
    });
  }

  getFollow(curr_id) {
    if (this.props.prices.user != null) {
      if (curr_id == "btc") {
        if (this.props.prices.user.follow_btc) {
          return true;
        } else {
          return false;
        }
      } else if (curr_id == "ltc") {
        if (this.props.prices.user.follow_ltc) {
          return true;
        } else {
          return false;
        }
      } else {
        if (this.props.prices.user.follow_eth) {
          return true;
        } else {
          return false;
        }
      }
    }
  }

  getFollowBtn(currency, curr_id) {
    let curr = "";
    if (curr_id == "btc") {
      curr = "Bitcoin";
    } else if (curr_id == "ltc") {
      curr = "Litecoin";
    } else {
      curr = "Ethereum";
    }

    if (this.getFollow(curr_id)) {
      return (<Button className="unfollow" onClick={() => this.unfollowCurrency(curr_id)}>Unfollow {curr}</Button>);
    } else {
      return (<Button className="follow" onClick={() => this.followCurrency(curr_id)}>Follow {curr}</Button>);
    }
  }

  edit_modal() {
    let bitcoin_state = this.getFollowBtn(this.props.prices.btc, "btc");
    let litecoin_state = this.getFollowBtn(this.props.prices.ltc, "ltc");
    let ethereum_state = this.getFollowBtn(this.props.prices.eth, "eth");

    return (<Modal isOpen={this.state.edit_modal} toggle={this.toggle_edit} >
      <ModalHeader toggle={this.toggle_edit}>Choose Crypto Currencies to Follow</ModalHeader>
      <ModalBody>
        <div className="follow-cryptos text-center">
          <div className="col-10 crypto-btn">
            {bitcoin_state}
          </div>
          <div className="col-10 crypto-btn">
            {litecoin_state}
          </div>
          <div className="col-10 crypto-btn">
            {ethereum_state}
          </div>
        </div>
      </ModalBody>
      <ModalFooter>
        <Button color="secondary" onClick={this.toggle_edit}>Cancel</Button>
      </ModalFooter>
    </Modal>);
  }

  render() {
    let user_exist = false;
    let edit = (<div></div>);
    if (this.props.prices.user) {
      user_exist = true;
      if (!this.props.prices.user.follow_btc) {
        btc = (<div></div>);
      }
      if (!this.props.prices.user.follow_ltc) {
        ltc = (<div></div>);
      }
      if (!this.props.prices.user.follow_eth) {
        eth = (<div></div>);
      }
    } else {
      user_exist = false;
    }

    let btc = (<CryptoCard currency={this.props.prices.btc} curr_id="btc" cryptoName="Bitcoin" channel={this.props.channel} ifUser={user_exist} />);
    let ltc = (<CryptoCard currency={this.props.prices.ltc} curr_id="ltc" cryptoName="Litecoin" channel={this.props.channel} ifUser={user_exist} />);
    let eth = (<CryptoCard currency={this.props.prices.eth} curr_id="eth" cryptoName="Ethereum" channel={this.props.channel} ifUser={user_exist} />);

    let coins = (
      <div className="row cryto-container">
        {btc}
        {ltc}
        {eth}
      </div>);

    if (this.props.prices.user != null) {
      edit = (
        <div>
          <Button className="btn btn-primary" onClick={this.toggle_edit}>Edit Cryptos</Button>
          {this.edit_modal()}
        </div>
      );
    }

    return (
      <div className="coins-div">
        {coins}
        {edit}
      </div>
    );
  }
}
