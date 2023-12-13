pragma solidity 0.8.19;

import {TestWrapper} from "./TestWrapper.sol";
import {Referral} from "src/Referral.sol";
import {RegisterHelper} from "src/RegisterHelper.sol";
import {AccessControl} from "src/AccessControl.sol";

contract TestRegisterHelper is TestWrapper {
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
        rebateFee = 1e18;
        regFee = 1e18;
        deployMocks();
        referral = new Referral(admin, comp);
        registerHelper = new RegisterHelper(admin, address(unionTokenMock), address(userManagerMock), address(referral), regFeeRecipient, rebateFee, regFee);
        vm.prank(admin);
        referral.changeSetter(address(registerHelper),true);
    }

    function testCannotSetRegFeeRecipientNonAdmin() public {
        vm.expectRevert(AccessControl.NotAdmin.selector);
        registerHelper.setRegFeeRecipient(payable(address(4)));
    }

    function testCannotSetRegFeeRecipientWhenZeroAddress() public {
        vm.prank(admin);
        vm.expectRevert(AccessControl.NullAddress.selector);
        registerHelper.setRegFeeRecipient(payable(address(0)));
    }

    function testSetRegFeeRecipient(address payable newRecipient) public {
        vm.prank(admin);
        registerHelper.setRegFeeRecipient(newRecipient);
        assertEq(registerHelper.regFeeRecipient(), newRecipient);
    }

    function testCannotSetRebateFeeNonAdmin() public {
        vm.expectRevert(AccessControl.NotAdmin.selector);
        registerHelper.setRebateFee(2e18);
    }

    function testSetRebateFee(uint newRebateFee) public {
        vm.prank(admin);
        registerHelper.setRebateFee(newRebateFee);
        assertEq(registerHelper.rebateFee(), newRebateFee);
    }
    
    function testCannotSetRegFeeNonAdmin() public {
        vm.expectRevert(AccessControl.NotAdmin.selector);
        registerHelper.setRegFee(2e18);
    }

    function testSetRegFee(uint newRegFee) public {
        vm.prank(admin);
        registerHelper.setRegFee(newRegFee);
        assertEq(registerHelper.regFee(), newRegFee);
    }

    function testCannotRegisterWhenNotPaused() public {
        vm.prank(admin);
        registerHelper.pause();
        vm.expectRevert(abi.encodeWithSelector(AccessControl.HasPaused.selector, true));
        registerHelper.register(address(4), payable(address(5)));
    }

    function testCannotRegisterWhenNotEnoughBalance() public {
        vm.expectRevert(RegisterHelper.NotEnoughBalance.selector);
        registerHelper.register(address(4), payable(address(5)));
    }
    
    function testCannotRegisterWhenNotEnoughFee() public {
        vm.startPrank(admin);
        unionTokenMock.mint(1e20);
        unionTokenMock.transfer(address(registerHelper), 1e20);
        vm.stopPrank();
        vm.expectRevert(abi.encodeWithSelector(RegisterHelper.NotEnoughFee.selector, 0));
        registerHelper.register(address(4), payable(address(5)));
    }

    function testRegisterWhenFeeIsZero() public {
        address newUser = address(4);
        address payable referrer = payable(address(5));
        vm.startPrank(admin);
        registerHelper.setRegFee(0);
        registerHelper.setRebateFee(0);
        unionTokenMock.mint(1e20);
        unionTokenMock.transfer(address(registerHelper), 1e20);
        vm.stopPrank();
        registerHelper.register(newUser, referrer);
        assertEq(regFeeRecipient.balance,0);
        assertEq(referrer.balance,0);
    }

    function testRegisterWhenReferrerIsZero(address newUser) public {
        vm.assume(newUser != address(0));
        vm.startPrank(admin);
        unionTokenMock.mint(1e20);
        unionTokenMock.transfer(address(registerHelper), 1e20);
        vm.stopPrank();
        registerHelper.register{value: 2e18}(newUser, payable(address(0)));
        assertEq(regFeeRecipient.balance,2e18);
    }

    function testRegisterWhenRebateFeeIsZero() public {
        address newUser = address(4);
        address payable referrer = payable(address(5));
        vm.startPrank(admin);
        registerHelper.setRebateFee(0);
        unionTokenMock.mint(1e20);
        unionTokenMock.transfer(address(registerHelper), 1e20);
        vm.stopPrank();
        registerHelper.register{value: 2e18}(newUser, referrer);
        assertEq(regFeeRecipient.balance,2e18);
        assertEq(referrer.balance,0);
    }

    function testRegister() public {
        address newUser = address(4);
        address payable referrer = payable(address(5));
        vm.startPrank(admin);
        unionTokenMock.mint(1e20);
        unionTokenMock.transfer(address(registerHelper), 1e20);
        vm.stopPrank();
        registerHelper.register{value: 2e18}(newUser, referrer);
        assertEq(regFeeRecipient.balance,1e18);
        assertEq(referrer.balance,1e18);
    }
}
