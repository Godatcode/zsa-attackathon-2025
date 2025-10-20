// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// Minimal interfaces - no dependencies
interface IAaveOracle {
    function getAssetPrice(address asset) external view returns (uint256);
    function getSourceOfAsset(address asset) external view returns (address);
}

interface IChainlinkAggregator {
    function latestAnswer() external view returns (int256);
    function latestRoundData() external view returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    );
}

// Empty contract - we only need interfaces
contract OracleTest {}
