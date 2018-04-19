// followed from Nat Tuck's lecture notes
import React from 'react';
import { Button, Modal, ModalBody, Form, FormGroup, Label, Input, ModalFooter, ModalHeader, ModalProps } from 'reactstrap';
import Bitcoin from './bitcoin';
import Ethereum from './ethereum';
import Litecoin from './litecoin';

export default class FollowedCurrencies extends React.Component {
  constructor(props) {
    super(props);
    this.my_channel = this.props.channel;
    this.state = {
      edit_modal: false,
      display_modal: false,
      alert_modal: false,
      high_val: 0,
      low_val: 0,
      user: this.props.prices.user
    };
    this.toggle_edit = this.toggle_edit.bind(this);
    this.toggle_disp = this.toggle_disp.bind(this);
    this.toggle_alerts = this.toggle_alerts.bind(this);
    this.handleHighChange = this.handleHighChange.bind(this);
    this.handleLowChange = this.handleLowChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  toggle_alerts() {
    this.setState({ alert_modal: !this.state.alert_modal });
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

  getHistory(curr_id, start, end) {
    var channel = this.props.channel.push("get_currency_pricing", { "currency_id": curr_id, "start_date": start, "end_date": end });
    channel.receive("ok", resp => {
      return resp;
    });
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
    if (this.state.user) {
      let user = this.state.user;
      if (curr_id == "btc") {
        if (user.follow_btc) {
          return true;
        } else {
          return false;
        }
      } else if (curr_id == "ltc") {
        if (user.follow_ltc) {
          return true;
        } else {
          return false;
        }
      } else {
        if (user.follow_eth) {
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
    let end_date = new Date(str(curr_month) + "-" + str(curr_date) + "-" + curr_year);
    let start_date = new Date(str(curr_month) + "-" + str(curr_date) + "-" + curr_year);
    start_date.setDate(curr_date - 7);

    let history = this.getHistory(curr_id, start_date, end_date);

    // putting modal info here alert_modal(curr_id)
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

  handleHighChange(event) {
    this.setState({ high_val: event.target.value });
  }

  handleLowChange(event) {
    this.setState({ low_val: event.target.value });
  }

  handleSubmit(event) {
    let curr_id = event.target.curr_id;
    var channel = this.props.channel.push("enable_currency_alerts", { "currency_id": curr_id, "thresholds": { "threshold1": this.state.high_val, "threshold2": this.state.low_val } });
    channel.receive("ok", resp => {
      console.log(resp);
    });
    event.preventDefault();
  }

  alert_modal(curr_id) {
    return (
      <Modal className="alert-modal" isOpen={this.state.alert_modal} toggle={this.toggle_alert} >
        <ModalHeader toggle={this.toggle_alert}>Get Email Alerts When Prices Pass a Set Threshold</ModalHeader>
        <ModalBody>
          <div className="alert-cryptos text-center">
            <Form onSubmit={this.handleSubmit}>
              <FormGroup>
                <Label for="high">High Threshold</Label>
                <Input className="num-input" type="number" name="number" id="high" value={this.state.high_val} onChange={this.handleHighChange} placeholder="Enter a number..." />
              </FormGroup>
              <FormGroup>
                <Label for="low">Low Threshold</Label>
                <Input className="num-input" type="number" name="number" value={this.state.low_val} id="low" onChange={this.handleLowChange} placeholder="Enter a number..." />
              </FormGroup>
              <Input type="submit" value="Submit" curr_id={curr_id} />
            </Form>
          </div>
        </ModalBody>
        <ModalFooter>
          {/* <Button color="primary" onClick={() => }>Submit</Button> */}
          <Button color="secondary" onClick={this.toggle_alerts}>Cancel</Button>
        </ModalFooter>
      </Modal>);
  }

  render() {
    // here we need to get the list from params and find out what cryptos the
    // user is tracking, then make a call through the api
    let bitcoin_price = this.getPrice(this.props.prices.btc);
    let ethereum_price = this.getPrice(this.props.prices.eth);
    let litecoin_price = this.getPrice(this.props.prices.ltc);

    // TODO: only display followed currencies for a signed in user
    let coins = (
      <div className="row cryto-container">
        <Bitcoin price={bitcoin_price} onClick={() => display_modal(this.props.prices.btc, "btc")} />
        <Litecoin price={litecoin_price} onClick={() => display_modal(this.props.prices.ltc, "ltc")} />
        <Ethereum price={ethereum_price} onClick={() => display_modal(this.props.prices.eth, "eth")} />
      </div>);
    
    let edit = this.edit_modal();
    let alerting = this.alert_modal("btc");

    if (this.state.user != null) {
      return (
        <div className="coins-div">
          {coins}
          <Button className="btn btn-primary" onClick={this.toggle_edit}>Edit Cryptos</Button>
          <Button className="btn-secondary btn" onClick={this.toggle_alerts}>Manage Alerts</Button>
          {edit}
          {alerting}
        </div>
      );
    } else {
      return (
        <div className="coins-div">
          {coins}
        </div>
      );
    }
  }
}
