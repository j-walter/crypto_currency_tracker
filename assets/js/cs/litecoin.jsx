// followed Nat's lecture notes 
import React from 'react';
import { Card, CardBody } from 'reactstrap';

export default function Litecoin(params) {
    let price = params.price;
    return (
        <Card className="col-3">
            <CardBody>
                <div className="text-center litecoin">
                    <h2>Litecoin</h2>
                    <p>{price}</p>
                </div>
            </CardBody>
        </Card>
    );
}