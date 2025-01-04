// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {

    using PriceConverter for uint256;

     uint256 public  minimumUSD = 5e18;
     address[] public funders;
     mapping(address funder => uint256 amountFunded) public adressToAmountFunded;

    function fundMe() public payable {

        require(msg.value.getConversionRate() >= minimumUSD, "didn't send minimum eth");
        funders.push(msg.sender);
        adressToAmountFunded[msg.sender] = adressToAmountFunded[msg.sender] + msg.value;
        
    }

    function withdraw() public {
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            adressToAmountFunded[funder] = 0;
        }
    }

    
}