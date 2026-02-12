// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { IExerciseSolution } from "../Interfaces/IExerciceSolution.sol";
import { IFlashLoanSimpleReceiver } from "../Interfaces/IFlashLoanSimpleReceiver.sol";
import { IPool } from "../Interfaces/IPool.sol";
import { IPoolAddressesProvider } from "../lib/aave-v3-origin/src/contracts/interfaces/IPoolAddressesProvider.sol";

contract Counter is IExerciseSolution {
    IPool public pool;
    IERC20 public wbtcAddress;
    IERC20 public USDC;
    IERC20 public aUSDC;
    uint256 public borrowedAmount;
    address public evaluator;

    constructor(address _aavePool, address _wbtcAddress, address _usdc, address _evaluator) {
        pool = IPool(_aavePool);
        wbtcAddress = IERC20(_wbtcAddress);
        USDC = IERC20(_usdc);
        aUSDC = IERC20(0x16dA4541aD1807f4443d92D26044C1147406EB80);
        evaluator = _evaluator;
    }

    function depositSomeTokens() external override {
        uint256 amount = wbtcAddress.balanceOf(address(this));
        wbtcAddress.approve(address(pool), amount);
        pool.supply(
            address(wbtcAddress), 
            amount, 
            address(this), 
            0
        );
    }

    function withdrawSomeTokens() external override {
        pool.withdraw(
            address(wbtcAddress),
            1,
            address(this)
        );
       
     
    }

    function borrowSomeTokens() external override {
        uint256 availableLiquidity = USDC.balanceOf(address(aUSDC));
        uint256 borrowAmount = (availableLiquidity * 80) / 100;
        borrowedAmount = borrowAmount;
        pool.borrow(
            address(USDC),
            borrowAmount,
            2, 
            0,
            address(this)
        );
      
    }

    function repaySomeTokens() external override {
        uint256 repayAmount = borrowedAmount > 0 ? borrowedAmount : 1e6;
        
        USDC.approve(address(pool), repayAmount);
        pool.repay(
            address(USDC),
            repayAmount,
            2,
            address(this)
        );
       
    }

    function doAFlashLoan() external override {
        pool.flashLoanSimple(
            evaluator,
            address(USDC),
            1_000_000e6,
            "",
            0
        );
        
    }

    function repayFlashLoan() external override {
       
    }
    
    receive() external payable {}
   
}
