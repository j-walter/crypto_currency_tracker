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

  getPrice(currency) {
    if (currency && currency.sell && currency.sell.current) {
      return currency.sell.current;
    } else {
      return 0;
    }
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
    console.log("In getFollow: ", this.props.prices);
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

  display_crypto_modal(currency, curr_id) {
    let d = new Date();
    let curr_date = d.getDate();
    let curr_month = d.getMonth() + 1;
    let curr_year = d.getFullYear();
    let end_date = new Date(curr_month + "-" + curr_date + "-" + curr_year);
    let start_date = new Date(curr_year + "-" + curr_month + "-" + curr_date);
    start_date.setDate(curr_date - 7);
    let end_month = curr_month;
    let start_month = start_date.getMonth() + 1;
    if (end_month < 10) {
      end_month = "0" + curr_month;
    }
    if (start_month < 10) {
      start_month = "0" + start_month;
    }
    let start_date_str = start_date.getFullYear() + "-" + start_month + "-" + (start_date.getDate());
    let end_date_str = curr_year + "-" + end_month + "-" + curr_date;

    let properHistory = {}
    this.getHistory(curr_id, String(start_date_str), String(end_date_str), (history) => {
      properHistory = Object.keys(history).map((key) => ({ date: key, price: history[key] }));
    });
    
    console.log(properHistory);

    // let chart = (<Line history={history} />);
    // return (<div>{chart}</div>);
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
    // here we need to get the list from params and find out what cryptos the
    // user is tracking, then make a call through the api
    let bitcoin_price = this.getPrice(this.props.prices.btc);
    let ethereum_price = this.getPrice(this.props.prices.eth);
    let litecoin_price = this.getPrice(this.props.prices.ltc);

    let user_exist = false;

    if (this.props.prices.user) {
      user_exist = true;
    } else {
      user_exist = false;
    }

    // TODO: only display followed currencies for a signed in user
    let coins = (
      <div className="row cryto-container">
        <CryptoCard price={bitcoin_price} curr_id="btc" cryptoName="Bitcoin" channel={this.props.channel} ifUser={user_exist} onClick={() => display_modal(this.props.prices.btc, "btc")} />
        <CryptoCard price={litecoin_price} curr_id="ltc" cryptoName="Litecoin" channel={this.props.channel} ifUser={user_exist} onClick={() => display_modal(this.props.prices.ltc, "ltc")} />
        <CryptoCard price={ethereum_price} curr_id="eth" cryptoName="Ethereum" channel={this.props.channel} ifUser={user_exist} onClick={() => display_modal(this.props.prices.eth, "eth")} />
      </div>);

    let edit = (<div></div>);

    if (this.props.prices.user != null) {
      edit = (
        <div>
          <Button className="btn btn-primary" onClick={this.toggle_edit}>Edit Cryptos</Button>
          <Button onClick={() => this.display_crypto_modal(this.props.prices.btc, "btc")} > History </Button>
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
