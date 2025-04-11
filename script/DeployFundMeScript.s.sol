// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.18;

import { Script } from "forge-std/Script.sol";
import {FundMe } from "../src/FundMe.sol";
import {Helperconfig} from "./helperConfig.s.sol";

contract DeployFundMeScript is Script {
    function run() external returns(FundMe) {
       Helperconfig helperconfig =new Helperconfig();
        address ethusdpricefeed =  helperconfig.ActiveNetworkconfig();
        vm.startBroadcast();
          FundMe fundME = new FundMe(ethusdpricefeed);
        vm.stopBroadcast();
        return(fundME);
    }
}
