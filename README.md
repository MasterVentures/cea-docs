# cea-exchange-test-plan-docs
Exchange Test Plan Documentation for Crypto Exchange Alliance Orderbook Taker and Maker


- Overview

This document details the behaviour for the order book web-socket service, how to implement its methods and the expected results from the tests. 

- Prerequisites

Prior to sending any request to the Orderbook service, the exchange must know the following values:

HOST: Publicly accessible hostname.

EXCHANGE_ID: String specified in the URI to map the exchange interacting with the orderbook endpoints.

HEADER: Security string that have the type of security and a key provided for the administrator. must be in this form: -H “apikey: xxxxxxxxx”
