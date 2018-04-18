// taken from Nat's notes to follow tokens and passwords
import React from 'react';
import { NavLink } from 'react-router-dom';
import { Form, FormGroup, NavItem, Input, Button } from 'reactstrap';

export default class Nav extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <nav class="navbar navbar-dark bg-dark navbar-expand">
        <a class="navbar-brand" href="/">
          CryptoTracker
        </a>
        <ul class="navbar-nav mr-auto">
          <li class="nav-item">
            <a class="nav-link" href="/auth">Log In With Google</a>
          </li>
        </ul>
      </nav>
    );
  }
}
