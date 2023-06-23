use array::ArrayTrait;
use result::ResultTrait;

const name:felt252 = 'Meta Token';
const symbol:felt252 = 'MT';

// const decimals:u8 = 18;


fn __set__up() -> felt252 {
    let mut calldata = ArrayTrait::new();

    calldata.append(name);
    calldata.append(symbol);
    calldata.append(18);


    let address = deploy_contract('ERC20', @calldata).unwrap();
    address

}


#[test]

fn test_constructor() {
    let deployment_address = __set__up();

    let name = call(deployment_address, 'get_name', @ArrayTrait::new()).unwrap();

    let symbol = call(deployment_address, 'get_symbol', @ArrayTrait::new()).unwrap();

    assert(*name.at(0_u32) == 'Meta Token', 'Invalid name');
    assert(*symbol.at(0_u32) == 'MT', 'Invalid Symbol');
}