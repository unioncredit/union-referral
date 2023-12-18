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
    address payable public sender;
    address payable public regFeeRecipient;
    uint public rebate;
    uint public regFee;

    function setUp() public virtual {
        admin = address(1);
        comp = address(2);
        regFeeRecipient = payable(address(3));
        sender = payable(address(4));//The default sender for testing is a contract and cannot accept eth, so we need to change the address.
        vm.deal(sender, 100 ether);
        rebate = 1e18;
        regFee = 1e18;
        deployMocks();
        referral = new Referral(admin, comp);
        registerHelper = new RegisterHelper(
            admin,
            address(unionTokenMock),
            address(userManagerMock),
            address(referral),
            regFeeRecipient,
            rebate,
            regFee
        );
        vm.prank(admin);
        referral.changeSetter(address(registerHelper), true);
    }

    function testCannotSetRegFeeRecipientNonAdmin() public {
        vm.expectRevert(AccessControl.NotAdmin.selector);
        registerHelper.setRegFeeRecipient(payable(address(5)));
    }

    function testCannotSetRegFeeRecipientWhenZeroAddress() public {
        vm.prank(admin);
        vm.expectRevert(AccessControl.NullAddress.selector);
        registerHelper.setRegFeeRecipient(payable(address(0)));
    }

    function testSetRegFeeRecipient(address payable newRecipient) public {
        vm.assume(newRecipient != address(0));
        vm.prank(admin);
        registerHelper.setRegFeeRecipient(newRecipient);
        assertEq(registerHelper.regFeeRecipient(), newRecipient);
    }

    function testCannotSetRebateNonAdmin() public {
        vm.expectRevert(AccessControl.NotAdmin.selector);
        registerHelper.setRebate(2e18);
    }

    function testSetRebate(uint newRebate) public {
        vm.prank(admin);
        registerHelper.setRebate(newRebate);
        assertEq(registerHelper.rebate(), newRebate);
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
        registerHelper.register(address(5), payable(address(6)));
    }

    function testCannotRegisterWhenNotEnoughBalance() public {
        vm.expectRevert(RegisterHelper.NotEnoughBalance.selector);
        registerHelper.register(address(5), payable(address(6)));
    }

    function testCannotRegisterWhenNotEnoughFee() public {
        vm.startPrank(admin);
        unionTokenMock.mint(1e20);
        unionTokenMock.transfer(address(registerHelper), 1e20);
        vm.stopPrank();
        vm.expectRevert(abi.encodeWithSelector(RegisterHelper.NotEnoughFee.selector, 0));
        registerHelper.register(address(5), payable(address(6)));
    }

    function testRegisterWhenFeeIsZero() public {
        address newUser = address(5);
        address payable referrer = payable(address(6));
        vm.startPrank(admin);
        registerHelper.setRegFee(0);
        registerHelper.setRebate(0);
        unionTokenMock.mint(1e20);
        unionTokenMock.transfer(address(registerHelper), 1e20);
        vm.stopPrank();
        registerHelper.register(newUser, referrer);
        assertEq(regFeeRecipient.balance, 0);
        assertEq(referrer.balance, 0);
    }

    function testRegisterWhenReferrerIsZero(address newUser) public {
        vm.assume(newUser != address(0));
        vm.startPrank(admin);
        unionTokenMock.mint(1e20);
        unionTokenMock.transfer(address(registerHelper), 1e20);
        vm.stopPrank();
        uint balBef = address(sender).balance;//default sender
        vm.prank(sender);
        registerHelper.register{value: 3e18}(newUser, payable(address(0)));
        uint balEnd = address(sender).balance;
        assertEq(regFeeRecipient.balance, 2e18);
        assertEq(balBef - balEnd, 2e18);//actual use rebate + regFee = 2e18, 1e18 will return
    }

    function testRegisterWhenRebateIsZero() public {
        address newUser = address(5);
        address payable referrer = payable(address(6));
        vm.startPrank(admin);
        registerHelper.setRebate(0);
        unionTokenMock.mint(1e20);
        unionTokenMock.transfer(address(registerHelper), 1e20);
        vm.stopPrank();
        vm.prank(sender);
        registerHelper.register{value: 2e18}(newUser, referrer);
        assertEq(regFeeRecipient.balance, 1e18);
        assertEq(referrer.balance, 0);
    }

    function testRegisterWhenRegFeeIsZero() public {
        address newUser = address(5);
        address payable referrer = payable(address(6));
        vm.startPrank(admin);
        registerHelper.setRegFee(0);
        unionTokenMock.mint(1e20);
        unionTokenMock.transfer(address(registerHelper), 1e20);
        vm.stopPrank();
        vm.prank(sender);
        registerHelper.register{value: 2e18}(newUser, referrer);
        assertEq(regFeeRecipient.balance, 0);
        assertEq(referrer.balance, 1e18);
    }

    function testRegister() public {
        address newUser = address(5);
        address payable referrer = payable(address(6));
        vm.startPrank(admin);
        unionTokenMock.mint(1e20);
        unionTokenMock.transfer(address(registerHelper), 1e20);
        vm.stopPrank();
        vm.prank(sender);
        registerHelper.register{value: 2e18}(newUser, referrer);
        assertEq(regFeeRecipient.balance, 1e18);
        assertEq(referrer.balance, 1e18);
    }

    function testCannotClaimTokenNonAdmin() public {
        vm.expectRevert(AccessControl.NotAdmin.selector);
        registerHelper.claimToken(admin);
    }
    
    function testCannotClaimTokenWhenZeroAddress() public {
        vm.prank(admin);
        vm.expectRevert(AccessControl.NullAddress.selector);
        registerHelper.claimToken(address(0));
    }

    function testClaimToken() public {
        vm.startPrank(admin);
        unionTokenMock.mint(1e20);
        unionTokenMock.transfer(address(registerHelper), 1e20);
        uint balBef = unionTokenMock.balanceOf(admin);
        registerHelper.claimToken(admin);
        uint balEnd = unionTokenMock.balanceOf(admin);
        assertEq(balEnd - balBef, 1e20);
        vm.stopPrank();
    }
}
