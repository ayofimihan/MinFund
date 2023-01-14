//Get funds from users
//withdraw funds
//set a minimum funding value

//SPDX-License-Identifier: MIT;
pragma solidity ^0.8.7;
import "./PriceConverter.sol";

//custom errors are stated outside of the contracts

error Brokie();

contract FundMe{
    
    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 50 *1e18;
    address[] public funders;
    mapping(address=>uint256) public funderToAmount;
    address public immutable i_owner;

    constructor(){
        i_owner = msg.sender;
    }

    modifier onlyOwner(){
        require(i_owner == msg.sender, "you're not the owner dawg");
        _;
    }

    function fund() public payable{
        require(msg.value.getConversionRate() >= MINIMUM_USD, "get your money up ");
        funders.push(msg.sender);
        funderToAmount[msg.sender] = msg.value;

    }

  
    function withdraw(address _to) public payable onlyOwner{
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            funderToAmount[funder] = 0;
        }
        funders = new address[](0);
        (bool success,)=_to.call{value:address(this).balance}("");
        if(!success){
            revert Brokie();
        }
        



    }
}