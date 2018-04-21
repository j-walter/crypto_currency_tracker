import React from 'react';
import { Button, Modal, ModalBody, Form, FormGroup, Label, Input, ModalFooter, ModalHeader, ModalProps, Card, CardBody } from 'reactstrap';

export default class CryptoCard extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      display_modal: false,
      high_val: 0,
      low_val: 0,
      week_history: {}
    }

    this.toggle_alerts = this.toggle_alerts.bind(this);
    this.handleHighChange = this.handleHighChange.bind(this);
    this.handleLowChange = this.handleLowChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  getPrice() {
    if (this.props.currency && this.props.currency.sell && this.props.currency.sell.current) {
      return this.props.currency.sell.current;
    } else {
      return 0;
    }
  }

  getHistory(start, end, cb) {
    var channel = this.props.channel.push("get_currency_pricing", { "currency_id": this.props.curr_id, "start_date": start, "end_date": end });
    channel.receive("ok", cb);
  }

  toggle_alerts() {
    this.setState({ alert_modal: !this.state.alert_modal });
  }

  handleHighChange(event) {
    this.setState({ high_val: event.target.value });
  }

  handleLowChange(event) {
    this.setState({ low_val: event.target.value });
  }

  handleSubmit(event) {
    var channel = this.props.channel.push("enable_currency_alerts", { "currency_id": this.props.curr_id, "thresholds": { "threshold1": this.state.high_val, "threshold2": this.state.low_val } });
    channel.receive("ok", resp => {
      console.log(resp);
    });
    event.preventDefault();
  }

  alert_modal() {
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
              <Input type="submit" value="Submit" className="submit-crypto btn-primary" onClick={this.toggle_alerts} />
            </Form>
          </div>
        </ModalBody>
        <ModalFooter>
          <Button color="secondary" onClick={this.toggle_alerts}>Cancel</Button>
        </ModalFooter>
      </Modal>);
  }

  display_crypto_modal() {
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
    this.getHistory(this.props.curr_id, String(start_date_str), String(end_date_str), (history) => {
      this.setState(week_history, Object.keys(history).map((key) => ({ date: key, price: history[key] })));
    });

    console.log(this.state.week_history);

    // let chart = (<Line history={history} />);
    // return (<div>{chart}</div>);
  }

  render() {
    let price = "$" + this.getPrice();
    let alert_me = (<div></div>);
    let history = (<div></div>);

    if (this.props.ifUser) {
      alert_me = (
        <div className="set-alert">
          <Button className="btn-secondary btn" onClick={this.toggle_alerts}>Set Alert</Button>
          {this.alert_modal()}
        </div>
      );

      // history = (
      //   <div>
      //     <Button onClick={() => this.display_crypto_modal(this.props.currency, this.props.curr_id)} > History </Button>
      //   </div>
      // );
    }

    return (
      <Card className="price_card col-sm">
        <CardBody>
          <div className="text-center litecoin">
            <h2>{this.props.cryptoName}</h2>
            <h5 className="crypto-price">{price}</h5>
          </div>
          {alert_me}
        </CardBody>
      </Card>
    );
  }
}
