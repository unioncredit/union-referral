// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {TestWrapper} from "./TestWrapper.sol";
import {Referral} from "src/Referral.sol";
import {RegisterHelper} from "src/RegisterHelper.sol";


contract TestRegisterMemberUseRegHelp is TestWrapper {
    RegisterHelper public registerHelper;
    Referral public referral;
    address public admin;
    address public comp;
    address payable public regFeeRecipient;
    uint public rebateFee;
    uint public regFee;

    function setUp() public virtual {
        admin = address(1);
        comp = address(2);
        regFeeRecipient = payable(address(3));
        rebateFee = 5e17;
        regFee = 1e18;
        deployMocks();
        referral = new Referral(admin, comp);
        registerHelper = new RegisterHelper(admin, address(unionTokenMock), address(userManagerMock), address(referral), regFeeRecipient, rebateFee, regFee);
        vm.startPrank(admin);
        referral.changeSetter(address(registerHelper),true);
        unionTokenMock.mint(1e20);
        unionTokenMock.transfer(address(registerHelper), 1e20);
        vm.stopPrank();
    }

    function testRegister(uint value) public {
        address newUser = address(4);
        address payable referrer = payable(address(5));
        vm.assume(value >= rebateFee + regFee && value < 100e18);
        registerHelper.register{value:value}(newUser, referrer);
        assertEq(regFeeRecipient.balance,value - rebateFee);
        assertEq(referrer.balance,rebateFee);
        assertEq(referral.referrers(newUser),referrer);
    }
}