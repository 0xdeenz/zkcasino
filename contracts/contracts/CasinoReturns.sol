// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract CasinoReturns {

    function getReturns(
        uint256 betAmount,
        uint256 gameMode,
        uint256 guess,
        uint256 rng
    ) external view returns (uint256) {
        if (gameMode == 0) return _coinToss(betAmount, guess, rng);
        else if (gameMode == 1) return _lottery(betAmount, guess, rng);
        else if (gameMode == 2) return _roulette(betAmount, guess, rng);
        else if (gameMode == 3) return _twoDice(betAmount, guess, rng);
    }

    function _coinToss(uint256 betAmount, uint256 guess, uint256 rng) internal returns (uint256 payout) {

    }

    function _lottery(uint256 betAmount, uint256 guess, uint256 rng) internal returns (uint256 payout) {

    }

    function _roulette(uint256 betAmount, uint256 guess, uint256 rng) internal returns (uint256 payout) {

    }

    function _twoDice(uint256 betAmount, uint256 guess, uint256 rng) internal returns (uint256 payout) {

    }
}