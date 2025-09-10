# $SUPRA Coin to Fungible Asset Module

A Move module for converting SUPRA Coin standard tokens to SUPRA Fungible Asset (FA) standard tokens on Supra testnet.

## Prerequisites

- [Supra IDE](https://ide.supra.com/)
- SUPRA [testnet tokens](https://supra.com/faucet) in your account

## Setup

#### 1. Import or Copy Paste the `Source.move` in an IDE Project.

#### 2. Deploy the Module via IDE's Publish button.

> Check [This Tutorial](https://youtu.be/0Na8clbvn5U?si=m7Oyn96iwpmcZL6x) on how to deploy your Move Module using Supra IDE.

## Functions Available

> **NOTE**: You can Interact with Any of the Below Functions via IDE itself, Check Above Tutorial if you want to learn how.

### RUN Functions

#### `convert_coin_to_fa(amount)`
Converts a specific amount of SUPRA coins to fungible assets while keeping your coin store.

#### `migrate_account_to_fa()`
Migrates your entire SUPRA coin balance to fungible assets and destroys your coin store completely.

#### `convert_all_coins_to_fa()`
Converts all your SUPRA coins to fungible assets without destroying the coin store.

#### `batch_convert_coins_to_fa(chunk_size, max_chunks)`
Converts coins to FA in batches. Useful for large amounts.

### VIEW Functions

#### `get_total_supra_balance(address)`
Returns the total SUPRA balance (coins + fungible assets combined).

#### `is_account_registered(address)`
Checks if an account is registered to receive SUPRA tokens.

## Conversion Strategy Guide

**Choose `convert_coin_to_fa(amount)` if:**
- You want to convert only part of your balance
- You want to keep using both coin and FA formats
- You're testing the conversion process

**Choose `migrate_account_to_fa()` if:**
- You want to fully switch to the FA standard
- You want to convert everything at once
- You don't need the coin store anymore

**Choose `convert_all_coins_to_fa()` if:**
- You want to convert everything but keep the coin store
- You might receive more coins later

## Getting SUPRA Testnet Tokens

- You can Click on "Faucet" Button in IDE or in your Starkey Wallet to directly get 5 Test $SUPRA.

OR

- Via Using HTTP request

```bash
curl "https://rpc-testnet.supra.com/rpc/v1/wallet/faucet/YOUR_ADDRESS"
```

**Note:** This module is for Supra testnet only. Always test thoroughly before using on mainnet.