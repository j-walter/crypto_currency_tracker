// followed from Nat Tuck's lecture notes
import React from 'react';
import Bitcoin from './bitcoin';
import Ethereum from './ethereum';
import Litecoin from './litecoin';

export default function FollowedCurrencies(params) {
  let btc = params.state.btc;
    //   let tasks = _.map(params.tasks, (pp) => (<Task key={pp.id} task={pp} />));
    // here we need to get the list from params and find out what cryptos the
    // user is tracking, then make a call through the api
    let bitcoin_price = btc.buy.current;
    let ethereum_price = 0;
    let litecoin_price = 0;
    let coins = (
        <div className="row cryto-container">
            <Bitcoin price={bitcoin_price} />
            <Litecoin price={litecoin_price} />
            <Ethereum price={ethereum_price} />
        </div>);
    return (
        <div className="coins-div">
            {coins}
        </div>
    );
}
