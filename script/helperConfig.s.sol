// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.18;

import { Script } from "forge-std/Script.sol";

import {MockV3Aggregator} from "../test/mock/mock.sol";

contract Helperconfig is Script{
    Networkconfig public ActiveNetworkconfig;
    uint8 public constant DECIMALS =8;
    //uint256 public constant  INITIAL_PRICE = 2000e8;
    struct Networkconfig {
        address priceFeed; //eth-usd pricefeed
    
    }

    constructor (){
        if (block.chainid == 11155111){
            ActiveNetworkconfig = getSapoliEthConfig();
        }
        else if(block.chainid == 1){
            ActiveNetworkconfig =  getMainetEthConfig();
        }
        else { ActiveNetworkconfig =getAnvilConfig();
            
        }
    }
    
    function getSapoliEthConfig() public pure returns(Networkconfig memory){
     Networkconfig memory sapoliaConfig = Networkconfig({priceFeed:0x694AA1769357215DE4FAC081bf1f309aDC325306});
     return sapoliaConfig;
    }
     
    function getMainetEthConfig() public pure returns(Networkconfig memory){
     Networkconfig memory mainetConfig = Networkconfig({priceFeed:0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
     return mainetConfig;
    }

    function getAnvilConfig() public returns (Networkconfig memory) {
       if (ActiveNetworkconfig.priceFeed != address(0)) {
            return ActiveNetworkconfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, 2000e8);
        vm.stopBroadcast();

        Networkconfig memory anvilConfig = Networkconfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }
        

    }


