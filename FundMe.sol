// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

error notOwner();
contract FundMe {

    using PriceConverter for uint256;

     uint256 public constant  MINIMUM_USD = 5e18;
     address[] public funders;
    address public immutable i_owner;
     mapping(address funder => uint256 amountFunded) public adressToAmountFunded;

     constructor(){
        i_owner = msg.sender;
     }

    function fundMe() public payable {

        require(msg.value.getConversionRate() >= MINIMUM_USD, "didn't send minimum eth");
        funders.push(msg.sender);
        adressToAmountFunded[msg.sender] = adressToAmountFunded[msg.sender] + msg.value;
        
    }

    function withdraw() public onlyOwner {
                

        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            adressToAmountFunded[funder] = 0;
        }
        //reset the array
        funders = new address[](0);
        //actually withdraw the balance

        //transfer
        payable(msg.sender).transfer(address(this).balance);

        //send
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "Send failed");

        //call
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");

    }

     modifier onlyOwner(){
        // require(msg.sender == i_owner, "Must be owner!");
       if(msg.sender != i_owner){
        revert notOwner();
       }
        _;
    }

    
}