# Crypto Exchange Alliance Changelog

All notable changes to this Crypto Exchange Alliance Microservices will be documented in this file. Dates are displayed in UTC.

## v1.0.0 - 22 March 2021

* Orderbook Service
    - Centralized Orderbook aggregation based on participants.
    - Initial support for market, limit and stop trades.
    - Initial support for the following coin pairs:
        - BTCETH
        - BTCBCH
        - BTCLTC
        - BTCXRP
        - ETHBTC
        - ETHLTC
        - ETHBCH
        - ETHXRP
        - BCHBTC
        - BCHETH
        - BCHLTC
        - BCHXRP
        - LTCBTC
        - LTCETH
        - LTCBSH
        - LTCXRP
        - XRPBTC
        - XRPETH
        - XRPBCH
        - XRPLTC
    - Websocket streaming API
* Billing Service
    - Connector Dropcopy GiveUp Stream Orders from Provider
    - Serializer and backup all operations in data lake
    - Generator of tracers operations from orders and suborders legs
    - Executions  Wallet Service
        - Withdraws operations
        - Verified balances operations
    - Managements of Commissions and controls rates for exchanges
    - API Rest To recover the Metrics from a date Periods for every Symbol
    - Schedule "Tasker" to execute operations in case of failing the withdraws or connections to wallet service
    - Storage and control of tracer of Transactions executed, and record all logs of response from wallet service in every transactions leg
    - Creation Queries MongoDB Pipelines to grouping transactions left in a filtered list to optimized the Tasker function
* Wallet Service
    - SDK with provider Copper
    - Create New Exchange Account Endpoint
        - Create Copper Portfolio
        - Active Wallets
    - Control and management of wallets per Exchange
    - Movement Funds Between Exchanges (internal withdrawals)
    - Custody Funds System For External Withdrawals Per Exchange
        - Request External Withdrawals and distribute Shamir Secret Sharing Key According Custodial Configuration
        - Approve External Withdrawals Per Custodian
        - Reject External Withdrawals Per Custodian
    - API REST Transport
