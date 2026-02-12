// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Counter} from "../src/Counter.sol";

contract CounterScript is Script {
    Counter public counter;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        counter = new Counter(vm.envAddress("AAVE_POOL_ADDRESS"), vm.envAddress("WBTC_SEPOLIA"), vm.envAddress("USDC_ADDRESS"), vm.envAddress("EVALUATOR_ADDRESS"));

        vm.stopBroadcast();
    }
}
