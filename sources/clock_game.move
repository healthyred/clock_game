/// Module: clock_game
module clock_game::clock_game;

const INCREMENT_TIME_MS: u64 = 20_000;

use sui::clock::{Clock};
use sui::random::{Random};
use sui::event::emit;

public struct ClockGame has key, store {
    id: UID,
    end_time: u64
}

public struct ClockEvent has copy, drop {
    result: u64
}

public fun create_clock_game(
    end_time: u64,
    ctx: &mut TxContext,
) {
    transfer::share_object(ClockGame {
        id: object::new(ctx),
        end_time
    });
}

public fun set_clock_time(
    game: &mut ClockGame,
    end_time: u64
) {
    game.end_time = end_time;
}

entry fun roll_and_increment(
    game: &mut ClockGame,
    clock: &Clock,
    r: &Random,
    ctx: &mut TxContext,
) {
    let current_time = clock.timestamp_ms();
    assert!(current_time <= game.end_time);
    game.end_time = game.end_time + INCREMENT_TIME_MS;
    let mut generator = r.new_generator(ctx);
    let result = generator.generate_u64_in_range(1, 1000);
    emit(ClockEvent {
        result
    });
}



