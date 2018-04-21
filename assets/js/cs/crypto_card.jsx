import React from 'react';
import { Button, Modal, ModalBody, Form, FormGroup, Label, Input, ModalFooter, ModalHeader, ModalProps, Card, CardBody } from 'reactstrap';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ReferenceLine } from 'recharts';

export default class CryptoCard extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      alert_modal: false,
      history_modal: false,
      high_val: 0,
      low_val: 0,
      week_history: [],

    }

    this.toggle_history = this.toggle_history.bind(this);
    this.toggle_alerts = this.toggle_alerts.bind(this);
    this.handleHighChange = this.handleHighChange.bind(this);
    this.handleLowChange = this.handleLowChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.getHistory = this.getHistory.bind(this);
  }

  toggle_history() {
    this.setState({ history_modal: !this.state.history_modal });
  }

  getPrice() {
    if (this.props.currency && this.props.currency.sell && this.props.currency.sell.current) {
      return this.props.currency.sell.current;
    } else {
      return 0;
    }
  }

  graph() {
    let newData = this.state.week_history;

    return (
      <div className="text-center">
        <LineChart width={600} height={300} data={newData}
          margin={{ top: 5, right: 30, left: 20, bottom: 5 }}>
          <XAxis dataKey="date" />
          <YAxis domain={[this.props.thresholds.threshold2, this.props.thresholds.threshold1]} />
          <CartesianGrid strokeDasharray="3 3" />
          <Tooltip />
          <Line type="monotone" dataKey="price" stroke="#8884d8" activeDot={{ r: 8 }} />
          <ReferenceLine y={this.props.thresholds.threshold1} label="High" stroke="black" />
          <ReferenceLine y={this.props.thresholds.threshold2} label="Low" stroke="red" />
        </LineChart>
      </div>
    );
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
    var channel = this.props.channel.push("enable_currency_alerts", { "currency_id": this.props.curr_id, "threshold1": this.state.high_val, "threshold2": this.state.low_val });
    channel.receive("ok", resp => {
      console.log(resp);
    });
    event.preventDefault();
  }

  alertModal() {
    return (
      <Modal className="alert-modal" isOpen={this.state.alert_modal} toggle={this.toggle_alerts} >
        <ModalHeader toggle={this.toggle_alerts}>Get Email Alerts When Prices Pass a Set Threshold</ModalHeader>
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

  setupHistory() {
    let d = new Date();
    let curr_date = d.getDate();
    let curr_month = d.getMonth() + 1;
    let curr_year = d.getFullYear();
    let end_date = new Date(curr_month + "-" + curr_date + "-" + curr_year);
    let start_date = new Date(curr_year + "-" + curr_month + "-" + curr_date);
    start_date.setDate(curr_date - 6);
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
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    let properHistory = {};
    this.getHistory(String(start_date_str), String(end_date_str), (history) => {
      properHistory = Object.keys(history).map((key) => {
        let newDate = new Date(String(key));
        let disp = months[newDate.getMonth()] + " " + newDate.getDate();
        return { date: disp, price: history[key] };
      });
      this.setState({ week_history: properHistory.reverse() }, this.toggle_history.bind(this));
    });
  }

  historyModal() {

    return (
      <Modal className="history-modal modal-lg" isOpen={this.state.history_modal} toggle={this.toggle_history} >
        <ModalHeader toggle={this.toggle_history}>
          <span className="text-center">Week at a Glance for {this.props.cryptoName}</span>
        </ModalHeader>
        <ModalBody>
          <div>
            {this.graph()}
          </div>
        </ModalBody>
        <ModalFooter>
          <Button color="secondary" onClick={this.toggle_history}>Cancel</Button>
        </ModalFooter>
      </Modal>);
  }

  render() {
    let price = "$" + this.getPrice();
    let alert_me = (<div></div>);
    let history = (<div></div>);

    if (this.props.ifUser) {
      alert_me = (
        <div className="set-alert">
          <Button className="btn-secondary btn" onClick={this.toggle_alerts}>Set Alert</Button>
          {this.alertModal()}
        </div>
      );

      history = (
        <div>
          <Button className="btn-secondary btn" onClick={() => {
            this.setupHistory();
          }} > History </Button>
          {this.historyModal()}
        </div>
      );
    }

    return (
      <Card className="price_card col-3">
        <CardBody>
          <div className="text-center litecoin">
            <h2>{this.props.cryptoName}</h2>
            <h5 className="crypto-price">{price}</h5>
          </div>
          {alert_me}
          {history}
        </CardBody>
      </Card>
    );
  }
}
