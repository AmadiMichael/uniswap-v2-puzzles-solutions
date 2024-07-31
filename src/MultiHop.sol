// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IERC20.sol";

contract MultiHop {
    /**
     *  PERFORM A MULTI-HOP SWAP WITH ROUTER EXERCISE
     *
     *  The contract has an initial balance of 10 MKR.
     *  The challenge is to swap the contract entire MKR balance for ELON token, using WETH as the middleware token.
     *
     */
    address public immutable router;

    constructor(address _router) {
        router = _router;
    }

    function performMultiHopWithRouter(address mkr, address weth, address elon, uint256 deadline) public {
        // your code start here
        address[] memory path = new address[](3);
        (path[0], path[1], path[2]) = (mkr, weth, elon);

        IERC20(mkr).approve(router, 10 ether);
        IUniswapV2Router(router).swapExactTokensForTokens(10 ether, 0, path, address(this), deadline);
    }
}

interface IUniswapV2Router {
    /**
     *     amountIn: the amount of input tokens to swap.
     *     amountOutMin: the minimum amount of output tokens that must be received for the transaction not to revert.
     *     path: an array of token addresses.
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
