// followed from Nat Tuck's lecture notes
import React from 'react';
import Bitcoin from './bitcoin';
import Ethereum from './ethereum';
import Litecoin from './litecoin';

export default class FollowedCurrencies extends React.Component {
  constructor(props) {
    super(props);
  }

  getPrice(currency) {
    if (currency && currency.sell && currency.sell.current) {
      return currency.sell.current;
    } else {
      return 0;
    }
  }

  render() {
    console.log(this.props.prices);
    //   let tasks = _.map(params.tasks, (pp) => (<Task key={pp.id} task={pp} />));
    // here we need to get the list from params and find out what cryptos the
    // user is tracking, then make a call through the api
    console.log("BTC", this.props.prices.btc);
    let bitcoin_price = this.getPrice(this.props.prices.btc);
    let ethereum_price = this.getPrice(this.props.prices.eth);
    let litecoin_price = this.getPrice(this.props.prices.ltc);
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
}
