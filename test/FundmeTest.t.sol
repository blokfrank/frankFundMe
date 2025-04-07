// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol"; // Use correct casing
import {DeployFundMeScript} from "../script/DeployFundMeScript.s.sol";


contract FundMeTest is Test {
    FundMe fundMe;
    
    function setUp() public {
         DeployFundMeScript  deployFundMeScript = new  DeployFundMeScript();
        fundMe = deployFundMeScript.run();  // instantiation syntax
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18); // Access constant correctly
    }

     function testOwnerIsCorrect() public view {
        console.log(fundMe.i_owner());
        console.log(msg.sender);
        assertEq(fundMe.i_owner(), msg.sender); // Check that the deployed contract's owner is the correct address
    }

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
         
    }
}
