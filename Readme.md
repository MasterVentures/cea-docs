# cea-exchange-test-plan-docs

## *Exchange Test Plan Documentation for Crypto Exchange Alliance Orderbook Taker and Maker*


### **Overview**

This document details the behaviour for the order book web-socket service, how to implement its methods and the expected results from the tests. 

### **Prerequisites**

Prior to sending any request to the Orderbook service, the exchange must know the following values:

**_HOST:_** Publicly accessible hostname.

**_EXCHANGE_ID:_** String specified in the URI to map the exchange interacting with the orderbook endpoints.

**_HEADER:_** Security string that have the type of security and a key provided for the administrator, must be in this form: -H “apikey: xxxxxxxxx”

### **SET ORDERBOOK:**

**Channel:** ws://${HOST}/${EXCHANGE_ID/maker/orderbook/set

**Description:** Start a web-socket connection used by the exchange to publish a symbol orderbook.

**Request:** 	Once the connection has been established, the exchange can submit the order book message, following the example:

```javascript {.line-numbers}
{
  "symbol": "BTC/USDT"
  "asks": [
    {
      "price": "9000.00",
      "qty": 1000
    },
    {
      "price": "9500.00",
      "qty": 500
    },
    {
      "price": "1000.00",
      "qty": 50
    }
  ],
  "bids": [
    {
      "price": "10250.00",
      "qty": 700
    },
    {
      "price": "10500.00",
      "qty": 600
    }    
  ]
}
```

**Response:** This web-socket channel will not send a response back, unless there is an error reading the submitted order book. 

In case of errors expect a response like the following:

```javascript {.line-numbers}
{
  "failure": {
    "errorType": "Malformed Message" | "Server error"
    "err": "could not unmarshal json message"
  },
  "originalMessage": "the orderbook message sent"
}
```

### **GET AGGREGATED ORDERBOOK:**

**Channel:** ws://${HOST}/${EXCHANGE_ID/taker/orderbook/get

**Description:** Start a web-socket connection used by the exchange to receive aggregated orderbook for the specified symbol.

**Request:** Once the connection has been established, the exchange can submit the order book prompt message, following the example:

```javascript {.line-numbers}
{
  "symbol": "BTC/USDT"
  "depth": 10, //order book depth, a depth of 0 means full book
  "subscriptionType": 1
}
```

>subscriptionType indicates if the exchange will subscribe to receive updates for the specified symbol.A subscriptionType of 1 means it will subscribe to updates and a subscriptionType of 2 means it cancels previous subscriptions >for the specified symbol.


**Response:**   This websocket channel will send updates back to the exchange, including errors:

```javascript {.line-numbers}
{
  "responseType": 1, //1 for updates, 2 for errors
  "err": { // in case of updates this property will be empty
    "prompt": "symbol..." //original message sent by the exchange
    "reason": "error description"
  },
  "book": { // in case of errors this property will be empty
    "symbol": "BTC/USDT"
    "asks": [
      {
        "price": 9000.00,
        "qty": 1000
      },
      {
        "price": 9500.00,
        "qty": 500
      },
      {
        "price": 1000.00,
        "qty": 50
      }
    ],
    "bids": [
      {
        "price": 10250.00,
        "qty": 700
      },
      {
        "price": 10500.00,
        "qty": 600
      }    
    ]
  }
}
```


### **SUBMIT NEW ORDERS**

**Channel:** ws://${HOST}/${EXCHANGE_ID/taker/order/set

**Description:** Start a web-socket connection used by the exchange to submit orders that will be resolved by the aggregated order book.

**Request:** Once the connection has been established, the exchange can submit orders,following the schema:

```javascript {.line-numbers}
{
  "orderID": "1235",
  "symbol": "BTC/USDT"
  "orderSide": 1, //1 for buy, 2 for sell
  "orderType": 2, //1 for market, 2 for limit, 3 for stop
  "orderQty": 200,
  "price": "10000.00",
  "minQty": 20 //minimn fill of legs
  "timeStamp": 1603365742, //unix time
  "priceDeviation": "0.0002" //deviation from price allowed
  "currency": "USDT"
}
```

**Response:**   This web-socket channel will not send a response back, unless there is an error reading the submitted order.

>In case of errors expect a response like the following:

```javascript {.line-numbers}
{
  "originalMessage": "submitted order..",
  "errorType": "NEW ORDER REQUEST: Malformed Request"
  "errorMessage": "missing property orderID"
}
```

### **ORDER UPDATES**

**Channel:** ws://${HOST}/${EXCHANGE_ID/taker/order/set/update

**Description:** This channel allows an exchange to submit update or cancel request for active orders. 

**Request:** Once the connection has been established, the exchange can submit update requests on a previously submitted order:

```javascript {.line-numbers}
{
  "orderID": "1235",
  "updateType": 1 | 2,
  "requestID": "12455", //unique numeric id
  "requestTime": 1603365742 //unix time
}
```

>updateType: 1 for requesting updates, 2 for cancel order.

**Response:**   This web-socket channel will respond synchronous messages  with the update:

```javascript {.line-numbers}
{
  "responseType": 1 | 2,  
  "err": {
    "prompt": "[string] original request",
    "reason": "bad request"
  },
  "update": {
    "orderId": "123456",
    "status": 1 | 2 | 3 | 4 | 5,
    "executionId": "123456", //unique id
    "fillQty": 100, 
    "fillPrice" "0.0265" 
    "missingQty": 30, 
    "execQty": 200, 
    "avgPrice": "0.027", 
    "settleDate": "20201022", //date in yyyymmdd format
    "transactTime": 1603365742 //unix time
    "currency": "USD" currency of the deal
  }
}
```

>***status:***
>
>-Order is “new“ status.
>
>-Order rejected
>
>-Order filled
>
>-Order partially filled
>
>-Order cancelled

*Fields executionId, fillQty, fillPrice, missingQty, execQty, avgPrice, settleDate, transactTime, and currency should only be filled for status 3 or 4.*


### **EXECUTE ORDERS**

**Channel:** ws://${HOST}/${EXCHANGE_ID/maker/order/get

**Description:** Start a web-socket connection used by the exchange to receive orders that need to be executed accordingly with the submitted order book .

**Request:** Once the connection has been established, the exchange will receive order request, following the schema:

```javascript {.line-numbers}
{
  "orderId": "123456",
  "status": 1 | 2 | 3 | 4 | 5,
  "executionId": "123456", //unique id
  "fillQty": 100, 
  "fillPrice" "0.0265" 
  "missingQty": 30, 
  "execQty": 200, 
  "avgPrice": "0.027", 
  "settleDate": "20201022", //date in yyyymmdd format
  "transactTime": 1603365742 //unix time
  "currency": "USD" currency of the deal
}
```

*Fields executionId, fillQty, fillPrice, missingQty, >execQty, avgPrice, settleDate,transactTime, and currency >should only be filled for status 3 or 4.*

**Response:** No response is required.

### **EXECUTE ORDERS UPDATE**

**Channel:** ws://${HOST}/${EXCHANGE_ID/maker/order/get/update

**Description:** Start a web-socket connection used by the to submit order execution updates.

**Request:** Once the connection has been established, the exchange can submit update following the schema:

```javascript {.line-numbers}
{
  "orderID": "1235",
  "symbol": "BTC/USDT"
  "orderSide": 1, //1 for buy, 2 for sell
  "orderType": 2, //1 for market, 2 for limit, 3 for stop
  "orderQty": 200,
  "price": "10000.00",
  "minQty": 20 //minimn fill of legs
  "timeStamp": 1603365742, //unix time
  "priceDeviation": "0.0002" //deviation from price allowed
  "currency": "USDT"
}
```

**Response:**   This web-socket channel will not send a response back unless there is an error reading the submitted update.

```javascript {.line-numbers}
{
  "failure": {
    "errorType": "Malformed Message" | "Server error"
    "err": "could not unmarshal json message"
  },
  "originalMessage": "the orderbook message sent"
}
```

Link 
https://master.ventures/wp-content/uploads/2020/09/MasterVenturesHorizontal.png
Copy image to root /assets folder
Click me to browse image file

Upload
Click me to browse image file

use 
imgur
 to upload images
Show history
Please join us in Discord, specifically to our #ceatestnet channel, a place where we will interact with our Exchange community! Here's the invite: https://discord.gg/6xzYRTJGNf




