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




