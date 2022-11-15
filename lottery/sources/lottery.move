module geomel::lottery{

    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::sui::SUI;
    use sui::balance::{Self, Balance};
    use sui::tx_context::{Self, TxContext};

    // User holds the minimum amount to play
    const EHasMinimumAmountToPlay: u64 = 1;

    // user did not provide the correct amount of ticket price
    const EIncorrectTicketPrice: u64 = 2;

    // we don't have the minimum amount of players
    const ENotEnoughPlayers: u64 = 3;

    // not lottery owner
    const ENotLotterryOwner: u64 = 4;

    // The Lottery object
    struct Lottery has key, store{
        id: UID,
        ticket_price: u64,
        minimun_players: u64,
        lottery_balance: Balance<SUI>,
    }

    // The ownership capability of the Lottery
    struct LotteryOwnerCap has key, store{
        id: UID
    }

    /// Initialize the lottery 
    fun init(ctx: &mut TxContext){

        /// Initialize a Lottery object
        /// Make Lottery's object shared
        transfer::share_object(Lottery {
            id: object::new(ctx),
            ticket_price: 1,
            minimun_players: 3,
            lottery_balance: balance::zero()
        });

         // Assign ownership to the lottery creator
        transfer::transfer(
            LotterOwnerCap{id: object::new(ctx)}, 
            tx_context::sender(ctx)
        );
         
        transfer::share_object(lottery);
    }

    // returns Lottery'ss balance
    public fun getBalance(_: &LotteryOwnerCap, self: &Lottery): u64{
        balance::value<SUI>(&self.lottery_balance)
    }

       // returns Lotterys ticket price
    public fun getTicketPrice(self: &Lottery): u64{
       self::ticket_price
    }

    public fun getMinimumPlayers(self: &Lottery): u64{
        self::minimun_players
    }

    // Entry function for users to register the Lottery 
    public entry fun playLottery(lottery: &mut Lottery, player_wallet: &mut Coin<SUI>, ctx: &mut TxContext){

          // Get players wallet balance
        let wallet_balance = coin::balance_mut(player_wallet);

        // Checks if players has the minimum amount to pay 
        assert!(coin::value(wallet_balance)>=lottery.getTicketPrice, EHasMinimumAmountToPlay);
        
        // if user has submitted the correct price to purchase ticket
       // assert!(coin::value(wallet)==lottery.getTicketPrice, EIncorrectTicketPrice);



        
        balance::join(&mut lottery.lottery_balance, )

    }



}