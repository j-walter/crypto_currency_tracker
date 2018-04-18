// followed Nat's lecture notes
import React from 'react';
import { Card, CardBody } from 'reactstrap';

export default function Bitcoin(params) {
    let price = params.price;
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
