module your_addr::supra_coin_fa_converter {
    use std::signer;
    use std::error;
    use supra_framework::coin;
    use supra_framework::primary_fungible_store;
    use supra_framework::event;
    use supra_framework::supra_coin;

    const E_INSUFFICIENT_BALANCE: u64 = 1;
    #[event]
    struct CoinToFAConverted has drop, store {
        user: address,
        amount: u64,
    }
    #[event]
    struct AccountMigrated has drop, store {
        user: address,
        total_amount: u64,
    }

    /// Convert specific amount of SUPRA coins to SUPRA Fungible Assets
    public entry fun convert_coin_to_fa(
        account: &signer,
        amount: u64,
    ) {
        let user_addr = signer::address_of(account);
        assert!(coin::balance<supra_coin::SupraCoin>(user_addr) >= amount, error::invalid_argument(E_INSUFFICIENT_BALANCE));
        let supra_coins = coin::withdraw<supra_coin::SupraCoin>(account, amount);
        let supra_fa = coin::coin_to_fungible_asset<supra_coin::SupraCoin>(supra_coins);
        primary_fungible_store::deposit(user_addr, supra_fa);
        event::emit(CoinToFAConverted {
            user: user_addr,
            amount,
        });
    }

    /// Migrate entire SUPRA coin balance & coin store to Fungible Asset BUT this destroys the CoinStore and converts all coins to FA
    public entry fun migrate_account_to_fa(
        account: &signer,
    ) {
        let user_addr = signer::address_of(account);
        let total_balance = coin::balance<supra_coin::SupraCoin>(user_addr);
        assert!(total_balance > 0, error::invalid_argument(E_INSUFFICIENT_BALANCE));
        coin::migrate_to_fungible_store<supra_coin::SupraCoin>(account);
        event::emit(AccountMigrated {
            user: user_addr,
            total_amount: total_balance,
        });
    }

    /// Convert all remaining SUPRA coins to FA without destroying coin store
    public entry fun convert_all_coins_to_fa(
        account: &signer,
    ) {
        let user_addr = signer::address_of(account);
        let total_balance = coin::balance<supra_coin::SupraCoin>(user_addr);
        
        if (total_balance > 0) {
            convert_coin_to_fa(account, total_balance);
        };
    }

    /// Batch convert coins to FA in chunks (useful for large amounts)
    public entry fun batch_convert_coins_to_fa(
        account: &signer,
        chunk_size: u64,
        max_chunks: u8,
    ) {
        let user_addr = signer::address_of(account);
        let remaining_balance = coin::balance<supra_coin::SupraCoin>(user_addr);
        let chunks_processed: u8 = 0;
        
        while (remaining_balance > 0 && chunks_processed < max_chunks) {
            let convert_amount = if (remaining_balance >= chunk_size) {
                chunk_size
            } else {
                remaining_balance
            };
            
            convert_coin_to_fa(account, convert_amount);
            
            remaining_balance = coin::balance<supra_coin::SupraCoin>(user_addr);
            chunks_processed = chunks_processed + 1;
        };
    }

    /// Get total balance (coin + FA combined)
    #[view]
    public fun get_total_supra_balance(account: address): u64 {
        coin::balance<supra_coin::SupraCoin>(account)
    }

    /// Check if account is registered to receive SUPRA
    #[view]
    public fun is_account_registered(account: address): bool {
        coin::is_account_registered<supra_coin::SupraCoin>(account)
    }
}