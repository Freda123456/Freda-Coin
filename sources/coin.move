
module coin::coin;
use sui::coin::{Self, TreasuryCap};
use sui::url;

public struct COIN has drop {}

fun init(witness: COIN, ctx: &mut TxContext) {
    // Create the icon URL
    let icon_url = url::new_unsafe_from_bytes(b"https://framerusercontent.com/images/0KKocValgAmB9XHzcFI6tALxGGQ.jpg");
    let decimals: u8 = 8;
 
    // Fixed multiplier for 8 decimals (10^8)
    let multiplier = 100000000; // 10^8
 
    // Create the currency - make treasury mutable
    let (mut treasury, metadata) = coin::create_currency(
        witness,
        decimals,
        b"GOODYLILI",
        b"GOODYLILI ON SUI",
        b"Goodylili Taught Sui. Here's proof",
        option::some(icon_url),
        ctx,
    );
 
    // Mint 300 tokens (300 * 10^8 base units)
    let initial_coins = coin::mint(&mut treasury, 300 * multiplier, ctx);
    transfer::public_transfer(initial_coins, tx_context::sender(ctx));
 
    transfer::public_freeze_object(metadata);
    transfer::public_transfer(treasury, tx_context::sender(ctx));
}

public entry fun mint(
    treasury_cap: &mut TreasuryCap<COIN>,
    amount: u64,
    recipient: address,
    ctx: &mut TxContext,
) {
    let coin = coin::mint(treasury_cap, amount, ctx);
    transfer::public_transfer(coin, recipient);
}