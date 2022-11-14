module geomel:lottery{


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

    // Initialize the lottery
    fun init(ctx: &mut TxConttext){
        transfer::transfer(LotteryOwnership{id: object::new(ctx)}, tx_context::sender(ctx));
    }


}