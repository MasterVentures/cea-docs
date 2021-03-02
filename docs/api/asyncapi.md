# CEA Orderbook API 1.0.0 documentation

## Table of Contents

* [Channels](#channels)

## Channels

### **maker/orderbook/set** Channel

#### `publish` Operation

*Exchanges can use this channel to stream symbols orderbook*

##### Message

*Current asks and bids for the specified symbol*

###### Payload

| Name | Type | Description | Accepted values |
|-|-|-|-|
| symbol | string | pair symbol | _Any_ |
| bids | arrayobject | - | _Any_ |
| bids.price | string | price of bid or ask | _Any_ |
| bids.qty | integer | total bid or ask for this price | _Any_ |
| asks | arrayobject | - | _Any_ |
| asks.price | string | price of bid or ask | _Any_ |
| asks.qty | integer | total bid or ask for this price | _Any_ |

> Examples of payload _(generated)_

```json
{
  "symbol": "ETHBTC",
  "bids": [
    {
      "price": "1400.00",
      "qty": 2300
    }
  ],
  "asks": [
    {
      "price": "1400.00",
      "qty": 2300
    }
  ]
}
```



#### `subscribe` Operation

*When there are errors in the Orderbook message, this channel will return an error*

##### Message

*When something's wrong with the Orderbook message*

###### Payload

| Name | Type | Description | Accepted values |
|-|-|-|-|
| failure | string | type of error been throw | Malformed Message, Server error |
| err | string | posible cause of the error | _Any_ |

> Examples of payload _(generated)_

```json
{
  "failure": "Malformed Message",
  "err": "Validation error, field 'symbol' is required"
}
```




### **taker/orderbook/get** Channel

#### `publish` Operation

*Start a WebSocket connection used by the exchange to receive aggregated orderbook for the specified symbol*

##### Message

*Aggregated orderbook for a symbol*

###### Payload

| Name | Type | Description | Accepted values |
|-|-|-|-|
| symbol | string | pair symbol | _Any_ |
| depth | integer | order book depth, a depth of 0 means full book. | _Any_ |
| subscriptionType | integer | 1 - To subscribe to aggregated orderbook for the specified symbol. 2 - To unsubscribe or request once | 1, 2 |

> Examples of payload _(generated)_

```json
{
  "symbol": "ETHBTC",
  "depth": 6,
  "subscriptionType": 1
}
```



#### `subscribe` Operation

##### Message

*Aggregated result for the specified symbol*

###### Payload

| Name | Type | Description | Accepted values |
|-|-|-|-|
| responseType | integer | 1 - Orderbook update. 2 - Request error. | 1, 2 |
| err | oneOf | this will be null in case there are no error | _Any_ |
| err.0 | object | - | _Any_ |
| err.0.prompt | string | original message submited to channel | _Any_ |
| err.0.reason | string | description of error | _Any_ |
| err.1 | null | - | _Any_ |
| book | object | - | _Any_ |
| book.symbol | string | pair symbol | _Any_ |
| book.bids | arrayobject | - | _Any_ |
| book.bids.price | string | price of bid or ask | _Any_ |
| book.bids.qty | integer | total bid or ask for this price | _Any_ |
| book.asks | arrayobject | - | _Any_ |
| book.asks.price | string | price of bid or ask | _Any_ |
| book.asks.qty | integer | total bid or ask for this price | _Any_ |

> Examples of payload _(generated)_

```json
{
  "responseType": 1,
  "err": {
    "prompt": "{asks: '',bids: '', symbol: ''}",
    "reason": "field symbol can't be blank"
  },
  "book": {
    "symbol": "ETHBTC",
    "bids": [
      {
        "price": "1400.00",
        "qty": 2300
      }
    ],
    "asks": [
      {
        "price": "1400.00",
        "qty": 2300
      }
    ]
  }
}
```




### **taker/order/set** Channel

#### `publish` Operation

##### Message

*Start a WebSocket connection used by the exchange to submit orders that will be resolved by the aggregated order book*

###### Payload

| Name | Type | Description | Accepted values |
|-|-|-|-|
| orderID | string | OrderID is a unique alphanumemric identifier for the order. | _Any_ |
| symbol | string | order symbol | _Any_ |
| orderSide | integer | 1 - Buy Order 2 - Sell Order | 1, 2 |
| orderType | integer | 1 - Market Order 2 - Limit Order 3 - Stop Order | 1, 2, 3 |
| orderQty | string | Decimal quantity of the order. | _Any_ |
| price | string | Required for Limit or Stop orders. | _Any_ |
| minQty | string | Minimum fill size for the oder. | _Any_ |
| timeStamp | integer | Epoc time of the order | _Any_ |
| priceDeviation | string | How much the fill price can deviate from the order price. | _Any_ |

> Examples of payload _(generated)_

```json
{
  "orderID": "49a58c4c-7b43",
  "symbol": "ETHBTC",
  "orderSide": 1,
  "orderType": 1,
  "orderQty": "0.56",
  "price": "2.56",
  "minQty": "0.5",
  "timeStamp": 1614682480,
  "priceDeviation": "0.02"
}
```



#### `subscribe` Operation

##### Message

*This channel will not return any response, unless there is an error with a submited Order.*

###### Payload

| Name | Type | Description | Accepted values |
|-|-|-|-|
| originalMessage | string | Original submited order message | _Any_ |
| errorType | string | - | NEW ORDER REQUEST: Malformed Request, NEW ORDER REQUEST: Server Error |
| errorMessage | string | Description of error. | _Any_ |

> Examples of payload _(generated)_

```json
{
  "originalMessage": "{\"orderID\": \"2541a-52as5-1as25\", \"orderQty\": \"a\"}",
  "errorType": "NEW ORDER REQUEST: Malformed Request",
  "errorMessage": "field orderQty does not contain a numeric value"
}
```




