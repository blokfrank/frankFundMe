// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol"; // Use correct casing
import {DeployFundMeScript} from "../../script/DeployFundMeScript.s.sol";


contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 10 ether;
    uint256 constant MINIMUM_USD = 5e18; // 5 USD in wei
    
    
    function setUp() public {
         DeployFundMeScript  deployFundMeScript = new  DeployFundMeScript();
        fundMe = deployFundMeScript.run();  // instantiation syntax
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), MINIMUM_USD); // Access constant correctly
    }

     function testOwnerIsCorrect() public view {
        console.log(fundMe.i_owner());
        console.log(msg.sender);
        assertEq(fundMe.i_owner(), msg.sender); // Check that the deployed contract's owner is the correct address
    }

    function testPriceFeedVersionIsAccurate() public view {
        
        uint256 version = fundMe.getVersion();
        assertEq(version,4 );
         
    }

    function testFundTransferFailedwithoutenoughEth() public {
        vm.expectRevert();
        fundMe.fund{value: 0}(); // Expect revert when funding with less than minimum USD
    }

    function testFundTransferSuccess() public {  
        vm.deal(USER, SEND_VALUE); // Send 10 ether to this contract
        fundMe.fund{value: SEND_VALUE}(); // Fund the contract with 10 ether
        assertEq(fundMe.getAddressToAmountFunded(address(this)), SEND_VALUE ); // Check that the amount funded is correct
    }

    function addFundersToarrayofFunders() public {
       vm.prank((USER));
        fundMe.fund{value: SEND_VALUE}(); // Fund the contract with 10 ether
        assertEq(fundMe.getAddressToAmountFunded(USER), SEND_VALUE ); // 
    }

    function testonlyOwnerCanWithdraw() public {
        vm.deal(USER, SEND_VALUE);
        fundMe.fund{value: SEND_VALUE}(); // Fund the contract with 10 ether
        vm.expectRevert(); // Expect revert when non-owner tries to withdraw
        vm.prank(USER);
        fundMe.withdraw();
    }

    function testwithdrawwithZeroBalance() public {
        vm.expectRevert(); // Expect revert when trying to withdraw with zero balance
        fundMe.withdraw();
    }

    function testwithdrawWithasinleFunder() public {
        vm.deal(USER, SEND_VALUE);
        fundMe.fund{value: SEND_VALUE}(); // Fund the contract with 10 ether
        uint256 initialContractBalance = address(fundMe).balance;
        console.log("initialContractBalance", initialContractBalance);
        uint256 initialOwnerBalance = fundMe.getowner().balance;
        console.log("initialOwnerBalance", initialOwnerBalance);
        vm.prank(fundMe.getowner());
        fundMe.withdraw();
        uint256 finalContractBalance = address(fundMe).balance;
        console.log("finalContractBalance", finalContractBalance);
        assertEq(finalContractBalance, 0); // Check that the contract balance is zero
        uint256 finalOwnerBalance = fundMe.getowner().balance;
        console.log("finalOwnerBalance", finalOwnerBalance);
        assertApproxEqAbs(finalOwnerBalance, initialOwnerBalance + initialContractBalance, 1); 
    }
    

    function testwithdrawWithMultipleFunders() public {
        uint160 numberOfFunders = 10;
        uint160 startingIndex = 1; 
        uint256 initialOwnerBalance = fundMe.getowner().balance;
        console.log("initialOwnerBalance", initialOwnerBalance);
        for (uint160 i = startingIndex; i < numberOfFunders; i++) {
            vm.deal(address(i), SEND_VALUE);
            vm.prank(address(i));
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 initialContractBalance = address(fundMe).balance;
        console.log("initialContractBalance", initialContractBalance);
       
        vm.prank(fundMe.getowner());
        fundMe.withdraw();
        uint256 finalContractBalance = address(fundMe).balance;
        console.log("finalContractBalance", finalContractBalance);
        assertEq(finalContractBalance, 0); // Check that the contract balance is zero
        uint256 finalOwnerBalance = fundMe.getowner().balance;
        console.log("finalOwnerBalance", finalOwnerBalance);
        assertApproxEqAbs(finalOwnerBalance, initialOwnerBalance + initialContractBalance, 1); 
    }

   
}
