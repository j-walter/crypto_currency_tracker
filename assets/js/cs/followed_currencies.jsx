// followed from Nat Tuck's lecture notes
import React from 'react';
import Bitcoin from './bitcoin';
import Ethereum from './ethereum';
import Litecoin from './litecoin';

export default function FollowedCurrencies(params) {
  let prices = params.prices;
  //   let tasks = _.map(params.tasks, (pp) => (<Task key={pp.id} task={pp} />));
  // here we need to get the list from params and find out what cryptos the
  // user is tracking, then make a call through the api
  console.log("BTC", params.prices.btc.sell);
  let bitcoin_price = params.prices.btc.sell;
  let ethereum_price = params.prices.eth.sell;
  let litecoin_price = params.prices.ltc.sell;
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
