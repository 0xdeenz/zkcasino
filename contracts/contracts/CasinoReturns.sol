// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract CasinoReturns {

    function getReturns(
        uint256 betAmount,
        uint256 gameMode,
        uint256 guess,
        bytes32 rng
    ) external pure returns (uint256) {
        if (gameMode == 0) return _coinToss(betAmount, guess, rng);
        else revert("Invalid game mode");
    }

    function _coinToss(uint256 betAmount, uint256 guess, bytes32 rng) internal pure returns (uint256 payout) {
        require(guess == 0 || guess == 1, "Guess can only be 0 for heads or 1 for tails");
        uint8 draw = uint8(uint256(rng) & 1);

        if (draw == guess) return betAmount * 198 / 100;
        else return 0;
    }
}