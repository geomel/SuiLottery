module geomel::lottery{

    use sui::object::{Self, ID, UID};
    use sui::transfer;
    use sui::sui::SUI;
    use sui::balance::{Self, Balance};
    use sui::tx_context::{Self, TxContext};

    use sui::coin::{Self, Coin};

    // User doesn't hold the minimum amount to play
    const ENotEnoughMoneyToPlay: u64 = 1;

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
        registered_players: u64,
        lottery_balance: Balance<SUI>,
    }

    // The ownership capability of the Lottery
    struct LotteryOwnerCap has key, store{
        id: UID
    }

    struct Players has key{
        id: UID,
        player_id: ID
    }

    struct WinnerEvent has copy, drop{
        id: ID,
        amount: u64,
        winner: address
    }

    /// Initialize the lottery 
    fun init(ctx: &mut TxContext){

        // Initialize a Lottery object
        // Make Lottery's object shared
        transfer::share_object(Lottery {
            id: object::new(ctx),
            ticket_price: 1,
            minimun_players: 3,
            registered_players: 0,
            lottery_balance: balance::zero()
        });

         // Assign ownership to the lottery creator
        transfer::transfer(
            LotteryOwnerCap{id: object::new(ctx)}, 
            tx_context::sender(ctx)
        );
    }

    // returns Lottery'ss balance
    public fun getBalance(self: &Lottery): u64{
        balance::value<SUI>(&self.lottery_balance)
    }

       // returns Lotterys ticket price
    public fun getTicketPrice(self: &Lottery): u64{
       self.ticket_price
    }

    public fun getMinimumPlayers(self: &Lottery): u64{
        self.minimun_players
    }

    // Entry function for users to register to the Lottery 
    public entry fun playLottery(lottery: &mut Lottery, player_wallet: &mut Coin<SUI>, _ctx: &mut TxContext){

        // Checks if players has the minimum amount to pay 
        assert!(coin::value(player_wallet) >= lottery.ticket_price, ENotEnoughMoneyToPlay);

         // Get players wallet balance
        let wallet_balance = coin::balance_mut(player_wallet);

        // if user has submitted the correct price to purchase ticket
       // assert!(coin::value(wallet)==lottery.getTicketPrice, EIncorrectTicketPrice);
        
        let ticket_payment = balance::split(wallet_balance, lottery.ticket_price);

        // add ticket_payment amount to lottery's balance
        balance::join(&mut lottery.lottery_balance,ticket_payment);

        // Create a new player Struct
       // let id = object::new(ctx);
       // let player_id = object::uid_to_inner(&id);

      //  let player = Player{id, player_id};

        // Increment total players count
        let total_players = lottery.registered_players;
        lottery.registered_players = total_players + 1;

    }

    public entry fun pickWinner(_: &LotteryOwnerCap, lottery: &mut Lottery, wallet: &mut Coin<SUI>){

        assert!(lottery.registered_players >=3, ENotEnoughPlayers);

         let lot_balance = getBalance(lottery);

         let user_balance = coin::balance_mut(wallet);

         let profits = balance::split(&mut lottery.lottery_balance, lot_balance);

         balance::join(user_balance, profits);
    }



}