// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IERC20.sol";

import {Test, console2} from "forge-std/Test.sol";

contract ExactSwap {
    /**
     *  PERFORM AN SIMPLE SWAP WITHOUT ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1 WETH.
     *  The challenge is to swap an exact amount of WETH for 1337 USDC token using the `swap` function
     *  from USDC/WETH pool.
     *
     */
    function performExactSwap(address pool, address weth, address usdc) public {
        /**
         *     swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data);
         *
         *     amount0Out: the amount of USDC to receive from swap.
         *     amount1Out: the amount of WETH to receive from swap.
         *     to: recipient address to receive the USDC tokens.
         *     data: leave it empty.
         */
        uint256 amountOut = 1337 * 1e6;
        (uint256 r0, uint256 r1,) = IUniswapV2Pair(pool).getReserves();
        uint256 k = r0 * r1;

        uint256 new_r0 = r0 - amountOut;
        uint256 amountIn = (k / new_r0) - r1;
        ++amountIn;

        amountIn = (amountIn * 1000) / 997;
        ++amountIn;

        IERC20(weth).transfer(pool, amountIn);
        IUniswapV2Pair(pool).swap(amountOut, 0, address(this), new bytes(0));
    }
}
