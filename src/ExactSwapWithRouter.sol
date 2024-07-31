// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IERC20.sol";
import "./interfaces/IUniswapV2Pair.sol";

contract ExactSwapWithRouter {
    /**
     *  PERFORM AN EXACT SWAP WITH ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1 WETH.
     *  The challenge is to swap an exact amount of WETH for 1337 USDC token using UniswapV2 router.
     *
     */
    address public immutable router;

    constructor(address _router) {
        router = _router;
    }

    function performExactSwapWithRouter(address weth, address usdc, uint256 deadline) public {
        // your code start here
        address[] memory path = new address[](2);
        (path[0], path[1]) = (weth, usdc);
        IERC20(weth).approve(router, 1 ether);

        address pool = 0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc;
        uint256 amountOut = 1337 * 1e6;
        (uint256 r0, uint256 r1,) = IUniswapV2Pair(pool).getReserves();
        uint256 k = r0 * r1;

        uint256 new_r0 = r0 - amountOut;
        uint256 amountIn = (k / new_r0) - r1;
        ++amountIn;

        amountIn = (amountIn * 1000) / 997;
        ++amountIn;

        IUniswapV2Router(router).swapExactTokensForTokens(amountIn, amountOut, path, address(this), deadline);
    }
}

interface IUniswapV2Router {
    /**
     *     amountIn: the amount of input tokens to swap.
     *     amountOutMin: the minimum amount of output tokens that must be received for the transaction not to revert.
     *     path: an array of token addresses. In our case, WETH and USDC.
     *     to: recipient address to receive the liquidity tokens.
     *     deadline: timestamp after which the transaction will revert.
     */
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
}
