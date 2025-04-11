// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol"; // Use correct casing
import {DeployFundMeScript} from "../../script/DeployFundMeScript.s.sol";
import {fundfundMe,withdrawfundMe} from "../../script/interactions.s.sol";

contract interationTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 10 ether;
    uint256 constant MINIMUM_USD = 5e18; // 5 USD in wei

    function setUp() public {
        DeployFundMeScript deployFundMeScript = new DeployFundMeScript();
        fundMe = deployFundMeScript.run(); // instantiation syntax
    }

    function testUsercaninteratewithfunfundMe() public {
        
        fundfundMe FundFundMe = new fundfundMe();
        vm.deal(USER, SEND_VALUE);
        FundFundMe.funFundMe(address(fundMe),  USER);
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);

        withdrawfundMe withdrawFundMe = new withdrawfundMe();
        vm.startPrank((fundMe.getowner()));
        withdrawFundMe.withdrawFundMe(address(fundMe));
        vm.stopPrank();
        assertEq(address(fundMe).balance, 0); 
    }
}
