// followed Nat's lecture notes
import React from 'react';
import { Card, CardBody } from 'reactstrap';

export default class Bitcoin extends React.Component {
    constructor(props) {
      super(props);
    }

    render() {
      let price = this.props.price;
      return (
        <Card className="price_card col-3">
          <CardBody>
            <div className="text-center bitcoin">
              <h2>Bitcoin</h2>
              <a href="/bitcoin">{price}</a>
            </div>
          </CardBody>
        </Card>
      );
    }
}
