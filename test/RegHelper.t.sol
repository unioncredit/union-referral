pragma solidity 0.8.19;

import {TestWrapper} from "./TestWrapper.sol";
import {Referral} from "src/Referral.sol";
import {RegHelper} from "src/RegHelper.sol";
import {AccessControl} from "src/AccessControl.sol";

contract TestRegHelper is TestWrapper {
    RegHelper public regHelper;
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
        regHelper = new RegHelper(admin, address(unionTokenMock), address(userManagerMock), address(referral), regFeeRecipient, rebateFee, regFee);
        vm.prank(admin);
        referral.changeSetter(address(regHelper),true);
    }

    function testCannotSetRegFeeRecipientNonAdmin() public {
        vm.expectRevert(AccessControl.NotAdmin.selector);
        regHelper.setRegFeeRecipient(payable(address(4)));
    }

    function testCannotSetRegFeeRecipientWhenZeroAddress() public {
        vm.prank(admin);
        vm.expectRevert(AccessControl.NullAddress.selector);
        regHelper.setRegFeeRecipient(payable(address(0)));
    }

    function testSetRegFeeRecipient(address payable newRecipient) public {
        vm.prank(admin);
        regHelper.setRegFeeRecipient(newRecipient);
        assertEq(regHelper.regFeeRecipient(), newRecipient);
    }

    function testCannotSetRebateFeeNonAdmin() public {
        vm.expectRevert(AccessControl.NotAdmin.selector);
        regHelper.setRebateFee(2e18);
    }

    function testSetRebateFee(uint newRebateFee) public {
        vm.prank(admin);
        regHelper.setRebateFee(newRebateFee);
        assertEq(regHelper.rebateFee(), newRebateFee);
    }
    
    function testCannotSetRegFeeNonAdmin() public {
        vm.expectRevert(AccessControl.NotAdmin.selector);
        regHelper.setRegFee(2e18);
    }

    function testSetRegFee(uint newRegFee) public {
        vm.prank(admin);
        regHelper.setRegFee(newRegFee);
        assertEq(regHelper.regFee(), newRegFee);
    }

    function testCannotRegisterWhenNotPaused() public {
        vm.prank(admin);
        regHelper.pause();
        vm.expectRevert(abi.encodeWithSelector(AccessControl.HasPaused.selector, true));
        regHelper.register(address(4), payable(address(5)));
    }

    function testCannotRegisterWhenNotEnoughBalance() public {
        vm.expectRevert(RegHelper.NotEnoughBalance.selector);
        regHelper.register(address(4), payable(address(5)));
    }
    
    function testCannotRegisterWhenNotEnoughFee() public {
        vm.startPrank(admin);
        unionTokenMock.mint(1e20);
        unionTokenMock.transfer(address(regHelper), 1e20);
        vm.stopPrank();
        vm.expectRevert(abi.encodeWithSelector(RegHelper.NotEnoughFee.selector, 0));
        regHelper.register(address(4), payable(address(5)));
    }

    function testRegisterWhenReferrerIsZero(address newUser) public {
        vm.assume(newUser != address(0));
        vm.startPrank(admin);
        unionTokenMock.mint(1e20);
        unionTokenMock.transfer(address(regHelper), 1e20);
        vm.stopPrank();
        regHelper.register{value: 2e18}(newUser, payable(address(0)));
        assertEq(regFeeRecipient.balance,2e18);
    }

    function testRegister(address newUser, address payable referrer) public {
        vm.assume(newUser != referrer && referrer != address(0));
        vm.startPrank(admin);
        unionTokenMock.mint(1e20);
        unionTokenMock.transfer(address(regHelper), 1e20);
        vm.stopPrank();
        regHelper.register{value: 2e18}(newUser, referrer);
        assertEq(regFeeRecipient.balance,1e18);
        assertEq(referrer.balance,1e18);
    }
}
