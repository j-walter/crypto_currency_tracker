// followed Nat's lecture notes 
import React from 'react';
import { Card, CardBody } from 'reactstrap';

export default function Bitcoin(params) {
    let price = params.price.current;
    return (
        <Card className="col-3">
            <CardBody>
                <div className="text-center bitcoin">
                    <h2>Bitcoin</h2>
                    <p>{price}</p>
                </div>
            </CardBody>
        </Card>
    );
}