// followed Nat's lecture notes
import React from 'react';
import { Card, CardBody } from 'reactstrap';

export default function Ethereum(params) {
    let price = params.price.current;
    return (
        <Card className="col-3">
            <CardBody>
                <div className="text-center ethereum">
                    <h2>Ethereum</h2>
                    <a href="/ethereum">{price}</a>
                </div>
            </CardBody>
        </Card>
    );
}
