// taken from Nat's notes to follow tokens and passwords
import React from 'react';
import { NavLink } from 'react-router-dom';
import { Form, FormGroup, NavItem, Input, Button } from 'reactstrap';

export default class Nav extends React.Component {
  constructor(props) {
    super(props);
  }

  getUser(user) {
    if (user && user.first_name) {
      return(<a className="nav-link disabled">Welcome { user.first_name }!</a>);
    } else {
      return(<a className="nav-link" href="/auth">Log In With Google</a>);
    }
  }

  render() {
    let user_name = this.getUser(this.props.user);
    return (
      <nav className="navbar navbar-dark bg-dark navbar-expand">
        <a className="navbar-brand" href="/">
          CryptoTracker
        </a>
        <ul className="navbar-nav mr-auto">
          <li className="nav-item">
            { user_name }
          </li>
        </ul>
      </nav>
    );
  }
}
