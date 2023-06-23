mod ERC20 {
    use starknet::SyscallResultTrait;
    use starknet::SyscallResultTraitImpl;


    use starknet::ContractAddress;
    use zeroable::Zeroable;
    use starknet::get_caller_address;
    use integer::BoundedInt;

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
    fn transfer(to: felt252, amount: u256) -> bool {
        let msg_sender = get_caller_address();

        _transfer(msg_sender, to, amount)

       
    }

    #[external]
    fn approve(spender: ContractAddress, amount: u256) -> bool {
        let msg_sender = get_caller_address();
        _approve(msg_sender, spender, amount);
    }


    #[external]
    fn transfer_from(from: ContractAddress, to: ContractAddress, amount: u256) -> bool {
        let msg_sender = get_caller_address();
       assert(_spend_allowance(from, msg_sender, amount), 'ERC20: Invalid Allowance');

      assert(_transfer(from, to, amount), 'ERC20: transfer failed') 
      true;
    }


    //internal functions
    #[internal]
    fn _transfer(from: ContractAddress, to:ContractAddress, amount: u256) -> bool {
        assert(!from.is_zero(), 'ERC20: Adrress zero');
        assert(!to.is_zero(), 'ERC20: Address zero');
        _balance_of::write(from, _balance_of::read(from) - amount);
        _balance_of::write(to, _balance_of::read(to) + amount);
        Transfer(msg_sender, to, amount)
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
            _approve(owner, spender, (current_allowance - amount))
        }

        true;
    }

    const TEST_CLASS_HASH: felt252 = 1560482859104150749114685548641687321168264309526474463178708584754962305024;
    
    mod _name {
        use super::ContractAddress;
        use super::Zeroable;
        use super::get_caller_address;
        use super::BoundedInt;
        use starknet::class_hash::ClassHashSerde;
        use starknet::contract_address::ContractAddressSerde;
        use starknet::storage_access::StorageAddressSerde;
        use option::OptionTrait;
        use option::OptionTraitImpl;
        use starknet::SyscallResultTrait;
        use starknet::SyscallResultTraitImpl;

        fn address() -> starknet::StorageBaseAddress {
            starknet::storage_base_address_const::<0x3a858959e825b7a94eb8d55c738f59c7bf4685267af5064bed5fd9c6bbc26de>()
        }
        fn read() -> felt252 {
            // Only address_domain 0 is currently supported.
            let address_domain = 0_u32;
            starknet::StorageAccess::<felt252>::read(
                address_domain,
                address(),
            ).unwrap_syscall()
        }
        fn write(value: felt252) {
            // Only address_domain 0 is currently supported.
            let address_domain = 0_u32;
            starknet::StorageAccess::<felt252>::write(
                address_domain,
                address(),
                value,
            ).unwrap_syscall()
        }
    }
    mod _symbol {
        use super::ContractAddress;
        use super::Zeroable;
        use super::get_caller_address;
        use super::BoundedInt;
        use starknet::class_hash::ClassHashSerde;
        use starknet::contract_address::ContractAddressSerde;
        use starknet::storage_access::StorageAddressSerde;
        use option::OptionTrait;
        use option::OptionTraitImpl;
        use starknet::SyscallResultTrait;
        use starknet::SyscallResultTraitImpl;

        fn address() -> starknet::StorageBaseAddress {
            starknet::storage_base_address_const::<0x232ee97ac3c9a49ad6aa5cea79c5f9de58bee0c617a17a4a39b222e53e87a22>()
        }
        fn read() -> felt252 {
            // Only address_domain 0 is currently supported.
            let address_domain = 0_u32;
            starknet::StorageAccess::<felt252>::read(
                address_domain,
                address(),
            ).unwrap_syscall()
        }
        fn write(value: felt252) {
            // Only address_domain 0 is currently supported.
            let address_domain = 0_u32;
            starknet::StorageAccess::<felt252>::write(
                address_domain,
                address(),
                value,
            ).unwrap_syscall()
        }
    }
    mod _decimal {
        use super::ContractAddress;
        use super::Zeroable;
        use super::get_caller_address;
        use super::BoundedInt;
        use starknet::class_hash::ClassHashSerde;
        use starknet::contract_address::ContractAddressSerde;
        use starknet::storage_access::StorageAddressSerde;
        use option::OptionTrait;
        use option::OptionTraitImpl;
        use starknet::SyscallResultTrait;
        use starknet::SyscallResultTraitImpl;

        fn address() -> starknet::StorageBaseAddress {
            starknet::storage_base_address_const::<0x2e252ace41124c8d1751071c666adf8397b337ba9110f0c502a5b3b620cc49a>()
        }
        fn read() -> u8 {
            // Only address_domain 0 is currently supported.
            let address_domain = 0_u32;
            starknet::StorageAccess::<u8>::read(
                address_domain,
                address(),
            ).unwrap_syscall()
        }
        fn write(value: u8) {
            // Only address_domain 0 is currently supported.
            let address_domain = 0_u32;
            starknet::StorageAccess::<u8>::write(
                address_domain,
                address(),
                value,
            ).unwrap_syscall()
        }
    }
    mod _total_supply {
        use super::ContractAddress;
        use super::Zeroable;
        use super::get_caller_address;
        use super::BoundedInt;
        use starknet::class_hash::ClassHashSerde;
        use starknet::contract_address::ContractAddressSerde;
        use starknet::storage_access::StorageAddressSerde;
        use option::OptionTrait;
        use option::OptionTraitImpl;
        use starknet::SyscallResultTrait;
        use starknet::SyscallResultTraitImpl;

        fn address() -> starknet::StorageBaseAddress {
            starknet::storage_base_address_const::<0x37a9774624a0e3e0d8e6b72bd35514f62b3e8e70fbaff4ed27181de4ffd4604>()
        }
        fn read() -> u256 {
            // Only address_domain 0 is currently supported.
            let address_domain = 0_u32;
            starknet::StorageAccess::<u256>::read(
                address_domain,
                address(),
            ).unwrap_syscall()
        }
        fn write(value: u256) {
            // Only address_domain 0 is currently supported.
            let address_domain = 0_u32;
            starknet::StorageAccess::<u256>::write(
                address_domain,
                address(),
                value,
            ).unwrap_syscall()
        }
    }
    mod _balance_of {
        use super::ContractAddress;
        use super::Zeroable;
        use super::get_caller_address;
        use super::BoundedInt;
        use starknet::class_hash::ClassHashSerde;
        use starknet::contract_address::ContractAddressSerde;
        use starknet::storage_access::StorageAddressSerde;
        use option::OptionTrait;
        use option::OptionTraitImpl;
        use starknet::SyscallResultTrait;
        use starknet::SyscallResultTraitImpl;

        fn address(key: ContractAddress) -> starknet::StorageBaseAddress {
            starknet::storage_base_address_from_felt252(
                hash::LegacyHash::<ContractAddress>::hash(0x28c3e1dbefa895c8ce32f20ee270d11a79d1ec61ff14a484658d0854362ecb2, key))
        }
        fn read(key: ContractAddress) -> u256 {
            // Only address_domain 0 is currently supported.
            let address_domain = 0_u32;
            starknet::StorageAccess::<u256>::read(
                address_domain,
                address(key),
            ).unwrap_syscall()
        }
        fn write(key: ContractAddress, value: u256) {
            // Only address_domain 0 is currently supported.
            let address_domain = 0_u32;
            starknet::StorageAccess::<u256>::write(
                address_domain,
                address(key),
                value,
            ).unwrap_syscall()
        }
    }
    mod _allowance {
        use super::ContractAddress;
        use super::Zeroable;
        use super::get_caller_address;
        use super::BoundedInt;
        use starknet::class_hash::ClassHashSerde;
        use starknet::contract_address::ContractAddressSerde;
        use starknet::storage_access::StorageAddressSerde;
        use option::OptionTrait;
        use option::OptionTraitImpl;
        use starknet::SyscallResultTrait;
        use starknet::SyscallResultTraitImpl;

        fn address(key: (ContractAddress, ContractAddress)) -> starknet::StorageBaseAddress {
            starknet::storage_base_address_from_felt252(
                hash::LegacyHash::<(ContractAddress, ContractAddress)>::hash(0x38be6c69485353b6475e25bcaee8da729a9caffdd02cf75aced3328de0d802d, key))
        }
        fn read(key: (ContractAddress, ContractAddress)) -> u256 {
            // Only address_domain 0 is currently supported.
            let address_domain = 0_u32;
            starknet::StorageAccess::<u256>::read(
                address_domain,
                address(key),
            ).unwrap_syscall()
        }
        fn write(key: (ContractAddress, ContractAddress), value: u256) {
            // Only address_domain 0 is currently supported.
            let address_domain = 0_u32;
            starknet::StorageAccess::<u256>::write(
                address_domain,
                address(key),
                value,
            ).unwrap_syscall()
        }
    }

    
    #[event]
    fn Transfer(from: ContractAddress, to:ContractAddress, amount:u256) {
        let mut __keys = array::array_new();
        array::array_append(ref __keys, 0x99cd8bde557814842a3121e8ddfd433a539b8c9f14bf31ebf108d12e6196e9);
        let mut __data = array::array_new();
        serde::Serde::<ContractAddress>::serialize(@from, ref __data);
        serde::Serde::<ContractAddress>::serialize(@to, ref __data);
        serde::Serde::<u256>::serialize(@amount, ref __data);
        
        starknet::syscalls::emit_event_syscall(
            array::ArrayTrait::span(@__keys),
            array::ArrayTrait::span(@__data),
        ).unwrap_syscall()
    }
            
    #[event]
    fn Approval (owner:ContractAddress, spender:ContractAddress, amount: u256) {
        let mut __keys = array::array_new();
        array::array_append(ref __keys, 0x134692b230b9e1ffa39098904722134159652b09c5bc41d88d6698779d228ff);
        let mut __data = array::array_new();
        serde::Serde::<ContractAddress>::serialize(@owner, ref __data);
        serde::Serde::<ContractAddress>::serialize(@spender, ref __data);
        serde::Serde::<u256>::serialize(@amount, ref __data);
        
        starknet::syscalls::emit_event_syscall(
            array::ArrayTrait::span(@__keys),
            array::ArrayTrait::span(@__data),
        ).unwrap_syscall()
    }
            

    trait __abi {
        #[constructor]
        fn constructor(name: felt252, symbol: felt252, decimal: u8);
        #[view]
        fn get_name() -> felt252;
        #[view]
        fn get_symbol() -> felt252;
        #[view]
        fn get_decimals() -> u8;
        #[view]
        fn get_total_supply() -> u256;
        #[view]
        fn get_balance_of(account: ContractAddress) -> u256;
        #[view]
        fn get_allowance(owner: ContractAddress, spender:ContractAddress) -> u256;
        #[external]
        fn mint(to: ContractAddress, amount: u256);
        #[external]
        fn burn(amount: u256) -> bool;
        #[external]
        fn transfer(to: felt252, amount: u256) -> bool;
        #[external]
        fn approve(spender: ContractAddress, amount: u256) -> bool;
        #[external]
        fn transfer_from(from: ContractAddress, to: ContractAddress, amount: u256) -> bool;
        
        #[event]
        fn Transfer(from: ContractAddress, to:ContractAddress, amount:u256);
        #[event]
        fn Approval (owner:ContractAddress, spender:ContractAddress, amount: u256);
        
    }

    mod __external {
        use super::ContractAddress;
        use super::Zeroable;
        use super::get_caller_address;
        use super::BoundedInt;
        use starknet::class_hash::ClassHashSerde;
        use starknet::contract_address::ContractAddressSerde;
        use starknet::storage_access::StorageAddressSerde;
        use option::OptionTrait;
        use option::OptionTraitImpl;

        #[implicit_precedence(Pedersen, RangeCheck, Bitwise, EcOp, Poseidon, SegmentArena, GasBuiltin, System)]
        fn get_name(mut data: Span::<felt252>) -> Span::<felt252> {
            internal::revoke_ap_tracking();
            gas::withdraw_gas().expect('Out of gas');
            
            if !array::SpanTrait::is_empty(data) {
                // Force the inclusion of `System` in the list of implicits.
                starknet::use_system_implicit();

                let mut err_data = array::array_new();
                array::array_append(ref err_data, 'Input too long for arguments');
                panic(err_data);
            }
            gas::withdraw_gas_all(get_builtin_costs()).expect('Out of gas');
            
            let res = super::get_name();
            let mut arr = array::array_new();
            // References.
            // Result.
            serde::Serde::<felt252>::serialize(@res, ref arr);
            array::ArrayTrait::span(@arr)
        }
        #[implicit_precedence(Pedersen, RangeCheck, Bitwise, EcOp, Poseidon, SegmentArena, GasBuiltin, System)]
        fn get_symbol(mut data: Span::<felt252>) -> Span::<felt252> {
            internal::revoke_ap_tracking();
            gas::withdraw_gas().expect('Out of gas');
            
            if !array::SpanTrait::is_empty(data) {
                // Force the inclusion of `System` in the list of implicits.
                starknet::use_system_implicit();

                let mut err_data = array::array_new();
                array::array_append(ref err_data, 'Input too long for arguments');
                panic(err_data);
            }
            gas::withdraw_gas_all(get_builtin_costs()).expect('Out of gas');
            
            let res = super::get_symbol();
            let mut arr = array::array_new();
            // References.
            // Result.
            serde::Serde::<felt252>::serialize(@res, ref arr);
            array::ArrayTrait::span(@arr)
        }
        #[implicit_precedence(Pedersen, RangeCheck, Bitwise, EcOp, Poseidon, SegmentArena, GasBuiltin, System)]
        fn get_decimals(mut data: Span::<felt252>) -> Span::<felt252> {
            internal::revoke_ap_tracking();
            gas::withdraw_gas().expect('Out of gas');
            
            if !array::SpanTrait::is_empty(data) {
                // Force the inclusion of `System` in the list of implicits.
                starknet::use_system_implicit();

                let mut err_data = array::array_new();
                array::array_append(ref err_data, 'Input too long for arguments');
                panic(err_data);
            }
            gas::withdraw_gas_all(get_builtin_costs()).expect('Out of gas');
            
            let res = super::get_decimals();
            let mut arr = array::array_new();
            // References.
            // Result.
            serde::Serde::<u8>::serialize(@res, ref arr);
            array::ArrayTrait::span(@arr)
        }
        #[implicit_precedence(Pedersen, RangeCheck, Bitwise, EcOp, Poseidon, SegmentArena, GasBuiltin, System)]
        fn get_total_supply(mut data: Span::<felt252>) -> Span::<felt252> {
            internal::revoke_ap_tracking();
            gas::withdraw_gas().expect('Out of gas');
            
            if !array::SpanTrait::is_empty(data) {
                // Force the inclusion of `System` in the list of implicits.
                starknet::use_system_implicit();

                let mut err_data = array::array_new();
                array::array_append(ref err_data, 'Input too long for arguments');
                panic(err_data);
            }
            gas::withdraw_gas_all(get_builtin_costs()).expect('Out of gas');
            
            let res = super::get_total_supply();
            let mut arr = array::array_new();
            // References.
            // Result.
            serde::Serde::<u256>::serialize(@res, ref arr);
            array::ArrayTrait::span(@arr)
        }
        #[implicit_precedence(Pedersen, RangeCheck, Bitwise, EcOp, Poseidon, SegmentArena, GasBuiltin, System)]
        fn get_balance_of(mut data: Span::<felt252>) -> Span::<felt252> {
            internal::revoke_ap_tracking();
            gas::withdraw_gas().expect('Out of gas');
            
            let __arg_account =
                serde::Serde::<ContractAddress>::deserialize(ref data).expect('Input too short for arguments');
            if !array::SpanTrait::is_empty(data) {
                // Force the inclusion of `System` in the list of implicits.
                starknet::use_system_implicit();

                let mut err_data = array::array_new();
                array::array_append(ref err_data, 'Input too long for arguments');
                panic(err_data);
            }
            gas::withdraw_gas_all(get_builtin_costs()).expect('Out of gas');
            
            let res = super::get_balance_of(__arg_account);
            let mut arr = array::array_new();
            // References.
            // Result.
            serde::Serde::<u256>::serialize(@res, ref arr);
            array::ArrayTrait::span(@arr)
        }
        #[implicit_precedence(Pedersen, RangeCheck, Bitwise, EcOp, Poseidon, SegmentArena, GasBuiltin, System)]
        fn get_allowance(mut data: Span::<felt252>) -> Span::<felt252> {
            internal::revoke_ap_tracking();
            gas::withdraw_gas().expect('Out of gas');
            
            let __arg_owner =
                serde::Serde::<ContractAddress>::deserialize(ref data).expect('Input too short for arguments');

            let __arg_spender =
                serde::Serde::<ContractAddress>::deserialize(ref data).expect('Input too short for arguments');
            if !array::SpanTrait::is_empty(data) {
                // Force the inclusion of `System` in the list of implicits.
                starknet::use_system_implicit();

                let mut err_data = array::array_new();
                array::array_append(ref err_data, 'Input too long for arguments');
                panic(err_data);
            }
            gas::withdraw_gas_all(get_builtin_costs()).expect('Out of gas');
            
            let res = super::get_allowance(__arg_owner, __arg_spender);
            let mut arr = array::array_new();
            // References.
            // Result.
            serde::Serde::<u256>::serialize(@res, ref arr);
            array::ArrayTrait::span(@arr)
        }
        #[implicit_precedence(Pedersen, RangeCheck, Bitwise, EcOp, Poseidon, SegmentArena, GasBuiltin, System)]
        fn mint(mut data: Span::<felt252>) -> Span::<felt252> {
            internal::revoke_ap_tracking();
            gas::withdraw_gas().expect('Out of gas');
            
            let __arg_to =
                serde::Serde::<ContractAddress>::deserialize(ref data).expect('Input too short for arguments');

            let __arg_amount =
                serde::Serde::<u256>::deserialize(ref data).expect('Input too short for arguments');
            if !array::SpanTrait::is_empty(data) {
                // Force the inclusion of `System` in the list of implicits.
                starknet::use_system_implicit();

                let mut err_data = array::array_new();
                array::array_append(ref err_data, 'Input too long for arguments');
                panic(err_data);
            }
            gas::withdraw_gas_all(get_builtin_costs()).expect('Out of gas');
            super::mint(__arg_to, __arg_amount);
            let mut arr = array::array_new();
            // References.
            // Result.
            array::ArrayTrait::span(@arr)
        }
        #[implicit_precedence(Pedersen, RangeCheck, Bitwise, EcOp, Poseidon, SegmentArena, GasBuiltin, System)]
        fn burn(mut data: Span::<felt252>) -> Span::<felt252> {
            internal::revoke_ap_tracking();
            gas::withdraw_gas().expect('Out of gas');
            
            let __arg_amount =
                serde::Serde::<u256>::deserialize(ref data).expect('Input too short for arguments');
            if !array::SpanTrait::is_empty(data) {
                // Force the inclusion of `System` in the list of implicits.
                starknet::use_system_implicit();

                let mut err_data = array::array_new();
                array::array_append(ref err_data, 'Input too long for arguments');
                panic(err_data);
            }
            gas::withdraw_gas_all(get_builtin_costs()).expect('Out of gas');
            
            let res = super::burn(__arg_amount);
            let mut arr = array::array_new();
            // References.
            // Result.
            serde::Serde::<bool>::serialize(@res, ref arr);
            array::ArrayTrait::span(@arr)
        }
        #[implicit_precedence(Pedersen, RangeCheck, Bitwise, EcOp, Poseidon, SegmentArena, GasBuiltin, System)]
        fn transfer(mut data: Span::<felt252>) -> Span::<felt252> {
            internal::revoke_ap_tracking();
            gas::withdraw_gas().expect('Out of gas');
            
            let __arg_to =
                serde::Serde::<felt252>::deserialize(ref data).expect('Input too short for arguments');

            let __arg_amount =
                serde::Serde::<u256>::deserialize(ref data).expect('Input too short for arguments');
            if !array::SpanTrait::is_empty(data) {
                // Force the inclusion of `System` in the list of implicits.
                starknet::use_system_implicit();

                let mut err_data = array::array_new();
                array::array_append(ref err_data, 'Input too long for arguments');
                panic(err_data);
            }
            gas::withdraw_gas_all(get_builtin_costs()).expect('Out of gas');
            
            let res = super::transfer(__arg_to, __arg_amount);
            let mut arr = array::array_new();
            // References.
            // Result.
            serde::Serde::<bool>::serialize(@res, ref arr);
            array::ArrayTrait::span(@arr)
        }
        #[implicit_precedence(Pedersen, RangeCheck, Bitwise, EcOp, Poseidon, SegmentArena, GasBuiltin, System)]
        fn approve(mut data: Span::<felt252>) -> Span::<felt252> {
            internal::revoke_ap_tracking();
            gas::withdraw_gas().expect('Out of gas');
            
            let __arg_spender =
                serde::Serde::<ContractAddress>::deserialize(ref data).expect('Input too short for arguments');

            let __arg_amount =
                serde::Serde::<u256>::deserialize(ref data).expect('Input too short for arguments');
            if !array::SpanTrait::is_empty(data) {
                // Force the inclusion of `System` in the list of implicits.
                starknet::use_system_implicit();

                let mut err_data = array::array_new();
                array::array_append(ref err_data, 'Input too long for arguments');
                panic(err_data);
            }
            gas::withdraw_gas_all(get_builtin_costs()).expect('Out of gas');
            
            let res = super::approve(__arg_spender, __arg_amount);
            let mut arr = array::array_new();
            // References.
            // Result.
            serde::Serde::<bool>::serialize(@res, ref arr);
            array::ArrayTrait::span(@arr)
        }
        #[implicit_precedence(Pedersen, RangeCheck, Bitwise, EcOp, Poseidon, SegmentArena, GasBuiltin, System)]
        fn transfer_from(mut data: Span::<felt252>) -> Span::<felt252> {
            internal::revoke_ap_tracking();
            gas::withdraw_gas().expect('Out of gas');
            
            let __arg_from =
                serde::Serde::<ContractAddress>::deserialize(ref data).expect('Input too short for arguments');

            let __arg_to =
                serde::Serde::<ContractAddress>::deserialize(ref data).expect('Input too short for arguments');

            let __arg_amount =
                serde::Serde::<u256>::deserialize(ref data).expect('Input too short for arguments');
            if !array::SpanTrait::is_empty(data) {
                // Force the inclusion of `System` in the list of implicits.
                starknet::use_system_implicit();

                let mut err_data = array::array_new();
                array::array_append(ref err_data, 'Input too long for arguments');
                panic(err_data);
            }
            gas::withdraw_gas_all(get_builtin_costs()).expect('Out of gas');
            
            let res = super::transfer_from(__arg_from, __arg_to, __arg_amount);
            let mut arr = array::array_new();
            // References.
            // Result.
            serde::Serde::<bool>::serialize(@res, ref arr);
            array::ArrayTrait::span(@arr)
        }
        
    }

    mod __l1_handler {
        use super::ContractAddress;
        use super::Zeroable;
        use super::get_caller_address;
        use super::BoundedInt;
        use starknet::class_hash::ClassHashSerde;
        use starknet::contract_address::ContractAddressSerde;
        use starknet::storage_access::StorageAddressSerde;
        use option::OptionTrait;
        use option::OptionTraitImpl;

        
    }

    mod __constructor {
        use super::ContractAddress;
        use super::Zeroable;
        use super::get_caller_address;
        use super::BoundedInt;
        use starknet::class_hash::ClassHashSerde;
        use starknet::contract_address::ContractAddressSerde;
        use starknet::storage_access::StorageAddressSerde;
        use option::OptionTrait;
        use option::OptionTraitImpl;

        #[implicit_precedence(Pedersen, RangeCheck, Bitwise, EcOp, Poseidon, SegmentArena, GasBuiltin, System)]
        fn constructor(mut data: Span::<felt252>) -> Span::<felt252> {
            internal::revoke_ap_tracking();
            gas::withdraw_gas().expect('Out of gas');
            
            let __arg_name =
                serde::Serde::<felt252>::deserialize(ref data).expect('Input too short for arguments');

            let __arg_symbol =
                serde::Serde::<felt252>::deserialize(ref data).expect('Input too short for arguments');

            let __arg_decimal =
                serde::Serde::<u8>::deserialize(ref data).expect('Input too short for arguments');
            if !array::SpanTrait::is_empty(data) {
                // Force the inclusion of `System` in the list of implicits.
                starknet::use_system_implicit();

                let mut err_data = array::array_new();
                array::array_append(ref err_data, 'Input too long for arguments');
                panic(err_data);
            }
            gas::withdraw_gas_all(get_builtin_costs()).expect('Out of gas');
            super::constructor(__arg_name, __arg_symbol, __arg_decimal);
            let mut arr = array::array_new();
            // References.
            // Result.
            array::ArrayTrait::span(@arr)
        }
        
    }
}
