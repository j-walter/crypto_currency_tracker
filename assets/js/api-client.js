import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default class ApiClient extends React.Component {
  constructor(props) {
    super(props);
    this.state = this.props.state;
    var check = this.check.bind(this);
  }

  refresh() {
   this.props.channel.push("get_currency", {}).receive("ok", state => {
      this.setState(state)
    });
  }

  render() {
    var toggle = this.toggle.bind(this);
    return (
      <div>
      </div>
    )
  }

}