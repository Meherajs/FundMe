// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

// MockV3Aggregator constant mockFeed;

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 TO_SEND = 0.1 ether;
    uint256 STARTING_BALANCE = 1 ether;

    function setUp() external {
        DeployFundMe deployer = new DeployFundMe();
        (fundMe, helperConfig) = deployer.deployFundMe();
    }

    function testMinimumUsdIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    // function testIsMsgSender() public view {
    //     console.log("msg.sender:", msg.sender);
    //     // assertEq(
    //     //     msg.sender,
    //     //     address(this),
    //     //     "msg.sender should be this contract"
    //     // );
    // }

    function testPrintAddresses() public view {
        console.log("msg.sender:", msg.sender);
        console.log("test contract:", address(this));
        // fundMe = new FundMe();
        console.log("FundMe contract:", address(fundMe));
    }

    // function testIsVersionAccurate() public view {
    //     assertEq(fundMe.getVersion(), 4);
    // }

    function testFundFailsNotEnoughETH() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundUpdatesAfterSuccess() public {
        vm.prank(USER);
        fundMe.fund{value: TO_SEND}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, TO_SEND);
    }

    function testAddFunderToArray() public {
        vm.prank(USER);
        fundMe.fund{value: TO_SEND}();

        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }
}
