// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;
pragma experimental ABIEncoderV2;

import "./Casino.sol";

interface ICasinoGames {
    function getReturns(
        uint256 betAmount,
        uint256 gameMode,
        uint256 guess,
        uint256 rng
    ) external view returns (uint256);
}

interface IRandomOracle {
    function settleBet(
        address payable _recipient,
        address payable _relayer,
        uint256 _fee,
        uint256 _betAmount,
        uint256 _gameMode,
        uint256 _guess
    ) external;
}

contract ETHCasino is Casino {
    ICasinoGames public casinoGames;
    IRandomOracle public randomOracle;

    constructor(
        address _supportedGames,
        address _randomOracle,
        address _verifier,
        uint256 _denomination,
        uint32 _merkleTreeHeight,
        address _hasher
    ) Casino (_verifier, _denomination, _merkleTreeHeight, _hasher) {
        casinoGames = ICasinoGames(_supportedGames);
        randomOracle = IRandomOracle(_randomOracle);
    }

    function changeSupportedGamesContract (address _newSupportedGames) external onlyOwner {
        casinoGames = ICasinoGames(_newSupportedGames);
    }

    function changeRandomOracleContract (address _newRandomOracle) external onlyOwner {
        randomOracle = IRandomOracle(_newRandomOracle);
    }

    function _processDeposit() internal override {
        require(
            msg.value == denomination,
            "Please send `mixDenomination` ETH along with transaction"
        );
    }

    function _processWithdraw(
        address payable _recipient,
        address payable _relayer,
        uint256 _fee,
        uint256 _betAmount,
        uint256 _gameMode,
        uint256 _guess
    ) internal override {
        // sanity check
        require(
            msg.value == 0,
            "Message value is supposed to be zero for ETH instance"
        );

        randomOracle.settleBet(
            _recipient,
            _relayer,
            _fee,
            _betAmount,
            _gameMode,
            _guess
        );
    }

    function oracleCallback(
        address payable _recipient,
        address payable _relayer,
        uint256 _fee,
        uint256 _betAmount,
        uint256 _gameMode,
        uint256 _guess,
        bytes32 _rng
    ) external {
        require(msg.sender == address(randomOracle), "Can only be called by random oracle");

        // Play the game with the generated random number
        uint256 gain = casinoGames.getReturns(
            _betAmount,
            _gameMode,
            _guess,
            _rng
        );

        if (gain > _fee) {  // enough to cover fee
            _recipient.transfer(gain - _fee);
            if (_fee > 0) {
                _relayer.transfer(_fee);
            }
        } else if (gain > 0) {  // if fee exists all earnings go to relayer as the fee is bigger than the gain
            _relayer.transfer(gain);
        }  // gain == 0 won't do anything
    }
}