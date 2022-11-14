module geomel::lottery{

    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::sui::SUI;
    use sui::balance::{Self, Balance};
    use sui::tx_context::{Self, TxContext};


    // user did not provide the correct amount of ticket price
    const EIncorrectTicketPrice: u64 = 1;

    // we don't have the minimum amount of players
    const ENotEnoughPlayers: u64 = 2;

    // not lottery owner
    const ENotLotterryOwner: u64 = 3;


    struct Lottery has key, store{
        id: UID,
        lottery_balance: Balance<SUI>

    }

    struct LotteryOwnership has key, store{
        id: UID
    }

    // Initialize the lottery and transfer ownership
    fun init(ctx: &mut TxContext){
        transfer::transfer(LotteryOwnership{id: object::new(ctx)}, tx_context::sender(ctx));

        transfer::share_object(Lottery {
            id: object::new(ctx),
            lottery_balance: balance::zero()
        });
    }


}