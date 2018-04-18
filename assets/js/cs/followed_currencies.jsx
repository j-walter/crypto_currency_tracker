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

  getHistory(curr_id, start, end) {
    var channel = this.props.channel.push("get_currency_pricing", { "currency_id": curr_id, "start_date": start, "end_date": end });
    channel.receive("ok", state => {
      this.setState(state);
      return;
    });
  }

  getFollow(currency) {
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
  }

  edit_modal() {
    return (<Modal isOpen={this.state.edit_modal} toggle={this.toggle_edit} >
      <ModalHeader toggle={this.toggle_edit}>Choose Crypto Currencies to Follow</ModalHeader>
      <ModalBody>
        <div className="follow-cryptos">
          <div className="row">
            <Button className="follow-btc" >Follow Bitcoin</Button>
          </div>
        </div>
      </ModalBody>
      <ModalFooter>
        <Button className="btn btn-primary">Submit</Button>
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
    let coins = (
      <div className="row cryto-container">
        <Bitcoin price={bitcoin_price} onClick={() => display_modal(this.props.prices.btc, "btc")} />
        <Litecoin price={litecoin_price} onClick={() => display_modal(this.props.prices.ltc, "ltc")} />
        <Ethereum price={ethereum_price} onClick={() => display_modal(this.props.prices.eth, "eth")} />
      </div>);
    let edit = this.edit_modal();
    return (
      <div className="coins-div">
        {coins}
        <Button className="btn btn-primary" onClick={this.toggle_edit} >Edit Cryptos</Button>
        {edit}
      </div>
    );
  }
}
