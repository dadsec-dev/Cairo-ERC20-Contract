#[contract]


mod ERC20 {

    ///////////////////////////////
    ////imports
    //////////////////////////////
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use straknet::Zeroable;

    //////////////////////////////
    /// state variable
    /////////////////////////////
    struct Storage{
        name:felt252,
        symbol:felt252,
        decimal: u18,
        total_supply: u256,
        balanceOf: LeagacyMap::<ContractAddress, u256>,
        allowance: LeagacyMap::<(ContractAddress, ContractAddress), u256>

    }

    
    #[constructor]
    fn constructor(_name:felt252, _symbol:felt252, _decimal:u8, _total_supply:u256) {
        let msgSnder = get_caller_address();
        // mutate state
        name::write(_name);
        symbol::write(_symbol);
        decimal::write(_decimal);
        total_supply::write(_total_supply);
    
    
    }

    #[event]
    fn Transfer(from: ContractAddress, to: ContractAddress, value: u256) {}

    #[event]
    fn Approval(owner: ContractAddress, spender: ContractAddress, value: u256) {}

    //////////////////////////////////////////
    ///////////// view functions
    /////////////////////////////////////////
    #[view]
    fn get_name() -> felt256 {
       return name::read();
    }

    #[view]
    fn get_symbol() -> felt256 {
       return symbol::read();
    }

    #[view]
    fn get_total_supply() -> u256 {
       return total_supply::read();

    }

    #[view]
    fn get_decimal() -> u8 {
        return decimal::read();
    
    }

    #[view]
    fn get_balance_of(_account:ContractAddress) -> u256 {
        return balanceOf::read(_account);

    }

    fn _mint(_amount:u256) {
        let caller = get_caller_address();
        let prev_total_supply = total_supply::read();
        let prevBal = balanceOf::read(caller);

        balanceOf::write(caller, prevBal + _amount);

        total_supply::write(prev_total_supply + _amount);
    
    
    }


#[external]
fn transfer(recipient: ContractAddress, amount: u256) {
    let sender = get_caller_address();
    transfer_helper(sender, recipient, amount);
}

fn transfer_helper(sender: ContractAddress, recipient: ContractAddress, amount: u256) {
    assert(!sender.is_zero(), 'ERC20: transfer from 0');
    assert(!recipient.is_zero(), 'ERC20: transfer to 0');
    balances::write(sender, balances::read(sender) - amount);
    balances::write(recipient, balances::read(recipient) + amount);
    Transfer(sender, recipient, amount);
}

#[external]
fn approve(spender: ContractAddress, amount: u256) {
    let owner = get_caller_address();
    approve_helper(owner, spender, amount);
}

fn approve_helper(owner: ContractAddress, spender: ContractAddress, amount: u256) {
    assert(!owner.is_zero(), 'ERC20: approve from 0');
    assert(!spender.is_zero(), 'ERC20: approve to 0');
    allowances::write((owner, spender), amount);
    Approval(owner, spender, amount);
}

#[external]
fn allowance(owner: ContractAddress, spender: ContractAddress) -> (u256) {
    return allowances::read((owner, spender));
}

#[external]
fn transferFrom(sender: ContractAddress, recipient: ContractAddress, amount: u256) {
    let caller = get_caller_address();
    let allowance = allowances::read((sender, caller));
    assert(!sender.is_zero(), 'ERC20: transfer from 0');
    assert(!recipient.is_zero(), 'ERC20: transfer to 0');
    assert(amount <= allowance, 'ERC20: transfer amount exceeds allowance');
    balances::write(sender, balances::read(sender) - amount);
    balances::write(recipient, balances::read(recipient) + amount);
    allowances::write((sender, caller), allowance - amount);
    Transfer(sender, recipient, amount);
}

#[external]
fn mint(recipient: ContractAddress, amount: u256) {
    assert(!recipient.is_zero(), 'ERC20: mint to the 0 address');
    let current_total_supply = total_supply::read();
    total_supply::write(current_total_supply + amount);
    balances::write(recipient, balances::read(recipient) + amount);
    Transfer(contract_address_const::<0>(), recipient, amount);
}

#[external]
fn burn(amount: u256) {
    let caller = get_caller_address();
    let caller_balance = balances::read(caller);
    assert(amount <= caller_balance, 'ERC20: burn amount exceeds balance');
    balances::write(caller, caller_balance - amount);
    total_supply::write(total_supply::read() - amount);
    Transfer(caller, contract_address_const::<0>(), amount);
}




}
