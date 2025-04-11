// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.18;

import {Script, console} from "forge-std/script.sol";
import {FundMe} from "../src/FundMe.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";

contract fundfundMe is Script {
    uint256 constant FUND_VALUE = 2 ether;
   
    function run() external {
        vm.startBroadcast();
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        vm.stopBroadcast();
        address funder = makeAddr("funder");
        funFundMe(mostRecentDeployed, funder);
        
    }

    function funFundMe(address mostRecentDeployed,  address funder) public payable {
        FundMe fundMe = FundMe(payable(mostRecentDeployed));
        vm.deal(funder, FUND_VALUE);
        vm.startPrank(funder);
        fundMe.fund{value: FUND_VALUE}();
        vm.stopPrank();
        console.log("Funded contract with 0.1 ether");
    }

}

contract withdrawfundMe is Script {
    function run() external {
        vm.startBroadcast();
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        vm.stopBroadcast();    
         withdrawFundMe(mostRecentDeployed);}

     function  withdrawFundMe(address mostRecentDeployed) public payable {
        FundMe fundMe = FundMe(payable(mostRecentDeployed));
        vm.startPrank(fundMe.getowner()); // or whoever is allowed
        fundMe.withdraw();
        vm.stopPrank();

   
        
    }




}
    

    