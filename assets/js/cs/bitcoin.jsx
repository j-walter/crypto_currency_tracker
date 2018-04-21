// followed Nat's lecture notes
import React from 'react';
import { Button, Modal, ModalBody, Form, FormGroup, Label, Input, ModalFooter, ModalHeader, ModalProps, Card, CardBody } from 'reactstrap';

export default class Bitcoin extends React.Component {
    constructor(props) {
      super(props);
      this.state = {
        display_modal: false,
        high_val: 0,
        low_val: 0
      }

      this.toggle_alerts = this.toggle_alerts.bind(this);
      this.handleHighChange = this.handleHighChange.bind(this);
      this.handleLowChange = this.handleLowChange.bind(this);
      this.handleSubmit = this.handleSubmit.bind(this);
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
      let curr_id = "btc";
      var channel = this.props.channel.push("enable_currency_alerts", { "currency_id": curr_id, "threshold1": this.state.high_val, "threshold2": this.state.low_val });
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
      let price = this.props.price;
      let alerting = this.alert_modal("btc");
      return (
        <Card className="price_card col-sm">
          <CardBody>
            <div className="text-center bitcoin">
              <h2>Bitcoin</h2>
              <a href="/#">{price}</a>
            </div>
            <Button className="btn-secondary btn" onClick={this.toggle_alerts}>Manage Alerts</Button>
            {alerting}
          </CardBody>
        </Card>
      );
    }
}
