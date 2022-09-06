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

// Used for testing bet settlement
contract RandomOracle {

    uint256 nrn;
    IETHCasino public casino;

    constructor (address _casino) {
        casino = IETHCasino(_casino);
    }

    function setNRN(uint _nrn) external {
        nrn = _nrn;
    }

    function settleBet(
        address payable _recipient,
        address payable _relayer,
        uint256 _fee,
        uint256 _betAmount,
        uint256 _gameMode,
        uint256 _guess
    ) external {
        casino.oracleCallback(
            _recipient,
            _relayer,
            _fee,
            _betAmount,
            _gameMode,
            _guess,
            nrn
        );
    }
}