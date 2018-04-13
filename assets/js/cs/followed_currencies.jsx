// followed from Nat Tuck's lecture notes
import React from 'react';
import Bitcoin from './bitcoin';
import Ethereum from './ethereum';
import Litecoin from './litecoin';

export default function FollowedCurrencies(params) {
    //   let tasks = _.map(params.tasks, (pp) => (<Task key={pp.id} task={pp} />));
    let bitcoin_price = TODO;
    let ethereum_price = TODO;
    let litecoin_price = TODO;
    let coins = <Bitcoin price={bitcoin_price}  />;
    return (
        <div className="coins-div">
            {coins}
        </div>
    );
}
