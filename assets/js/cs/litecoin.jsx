// followed Nat's lecture notes
import React from 'react';
import { Card, CardBody } from 'reactstrap';

export default class Litecoin extends React.Component {
    constructor(props) {
      super(props);
    }

    render() {
      let price = this.props.price;
      return (
        <Card className="price_card col-sm">
          <CardBody>
            <div className="text-center bitcoin">
              <h2>Litecoin</h2>
              <a href="/#">{price}</a>
            </div>
          </CardBody>
        </Card>
      );
    }
}
