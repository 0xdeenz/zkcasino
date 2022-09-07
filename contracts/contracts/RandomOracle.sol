// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

interface IETHCasino {
    function oracleCallback(
        address payable _recipient,
        address payable _relayer,
        uint256 _fee,
        uint256 _betAmount,
        uint256 _gameMode,
        uint256 _guess,
        uint256 _rng
    ) external;
}

// Could be updated in the future to incorporate proper VRF. Until then, we use on-chain data as source of randomness
contract RandomOracle {

    IETHCasino public casino;

    constructor (address _casino) {
        casino = IETHCasino(_casino);
    }

    function settleBet(
        address payable _recipient,
        address payable _relayer,
        uint256 _fee,
        uint256 _betAmount,
        uint256 _gameMode,
        uint256 _guess
    ) external {
        require(msg.sender == address(casino), "Can only be called by the casino contract");

        casino.oracleCallback(
            _recipient,
            _relayer,
            _fee,
            _betAmount,
            _gameMode,
            _guess,
            keccak256(abi.encodePacked(block.timestamp))        
        );
    }
}