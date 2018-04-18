// followed Nat's lecture notes
import React from 'react';
import { Card, CardBody } from 'reactstrap';

export default function Litecoin(params) {
    let price = params.price.current;
    return (
        <Card className="col-3">
            <CardBody>
                <div className="text-center litecoin">
                    <h2>Litecoin</h2>
                    <a href="/litecoin">{price}</a>
                </div>
            </CardBody>
        </Card>
    );
}
