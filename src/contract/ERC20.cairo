#[contract]

mod ERC20 {

    use starknet::ContractAddress;
    use zeroable::Zeroable;
    use starknet::get_caller_address;
    use integer::BoundedInt;

    ///Storage
    struct Storage {
        _name: felt252,
        _symbol: felt252,
        _decimal: u8,
        _total_supply: u256,
        _balance_of: LegacyMap::<ContractAddress, u256>,
        _allowance: LegacyMap::<(ContractAddress, ContractAddress), u256>,
    }

    //Events
    #[event]
    fn Transfer(from: ContractAddress, to:ContractAddress, amount:u256){}

    #[event]
    fn Approval (owner:ContractAddress, spender:ContractAddress, amount: u256) {}

    // constructor 
    #[constructor]
    fn constructor(name: felt252, symbol: felt252, decimal: u8) {
        _name::write(name);
        _symbol::write(symbol);
        _decimal::write(decimal)
    }


    //view function
    #[view]
    fn get_name() -> felt252 {
        // return _name::read();
        _name::read()
    }

    #[view]
    fn get_symbol() -> felt252 {
        _symbol::read()
    }

    #[view]
    fn get_decimals() -> u8 {
        _decimal::read()
    }

    #[view]
    fn get_total_supply() -> u256 {
        _total_supply::read()
    }

    #[view]
    fn get_balance_of(account: ContractAddress) -> u256 {
        _balance_of::read(account)
    }

    #[view]
    fn get_allowance(owner: ContractAddress, spender:ContractAddress) -> u256 {
        _allowance::read((owner, spender))
    }


    //external functions
    #[external]
    fn mint(to: ContractAddress, amount: u256)  {
        assert(!to.is_zero(), 'ERC20: Adddress zero');

        _balance_of::write(to, _balance_of::read(to) + amount);
        _total_supply::write(_total_supply::read() + amount);

        Transfer(Zeroable::zero(), to, amount);
    }

    #[external]
    fn burn(amount: u256) -> bool {
        let msg_sender = get_caller_address();

        _balance_of::write(msg_sender, _balance_of::read(msg_sender) - amount);

        Transfer(msg_sender, Zeroable::zero(), amount);

        true
    }

    #[external]
    fn transfer(to: ContractAddress, amount: u256) -> bool {
        let msg_sender = get_caller_address();

        _transfer(msg_sender, to, amount);

       true
    }

    #[external]
    fn approve(spender: ContractAddress, amount: u256) -> bool {
        let msg_sender = get_caller_address();
        _approve(msg_sender, spender, amount);
        true
    }


    #[external]
    fn transfer_from(from: ContractAddress, to: ContractAddress, amount: u256) -> bool {
        let msg_sender = get_caller_address();
       assert(_spend_allowance(from, msg_sender, amount), 'ERC20: Invalid Allowance');

      assert(_transfer(from, to, amount), 'ERC20: transfer failed');
      true
    }


    //internal functions
    #[internal]
    fn _transfer(from: ContractAddress, to:ContractAddress, amount: u256) -> bool {
        assert(!from.is_zero(), 'ERC20: Adrress zero');
        assert(!to.is_zero(), 'ERC20: Address zero');
        _balance_of::write(from, _balance_of::read(from) - amount);
        _balance_of::write(to, _balance_of::read(to) + amount);
        Transfer(from, to, amount);
        true
        
    }

    #[internal]
    fn _approve(owner: ContractAddress, spender:ContractAddress, amount: u256) -> bool {
        assert(!owner.is_zero(), 'ERC20: Address Zero');
        assert(!spender.is_zero(), 'ERC20: Address Zero');

        _allowance::write((owner, spender), amount);

        Approval(owner, spender, amount);

        true
    }

    #[internal]
    fn _spend_allowance(owner: ContractAddress, spender: ContractAddress, amount: u256) -> bool {
        let current_allowance = _allowance::read((owner, spender));
        
        if current_allowance != BoundedInt::max() {
            _approve(owner, spender, (current_allowance - amount));
        }

        true
    }



}
