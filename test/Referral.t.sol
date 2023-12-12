pragma solidity 0.8.19;

import {TestWrapper} from "./TestWrapper.sol";
import {Referral} from "src/Referral.sol";
import {AccessControl} from "src/AccessControl.sol";

contract TestReferral is TestWrapper {
    Referral public referral;
    address public admin;
    address public comp;
    function setUp() public virtual {
        admin = address(1);
        comp = address(2);
        deployMocks();
        referral = new Referral(admin, comp);
    }

    function testCannotChangeSetterNonAdmin() public {
        vm.expectRevert(AccessControl.NotAdmin.selector);
        referral.changeSetter(address(3), true);
    }

    function testChangeSetter(address newSetter) public {
        vm.assume(newSetter!= comp);
        vm.startPrank(admin);
        assertFalse(referral.setters(newSetter));
        referral.changeSetter(newSetter, true);
        assertTrue(referral.setters(newSetter));
        vm.stopPrank();
    }

    function testCannotSetReferrerNonAdmin() public {
        vm.expectRevert(Referral.NotSetter.selector);
        referral.setReferrer(address(3), address(4));
    }

    function testCannotSetReferrerWhenSelfReferral() public {
        vm.prank(comp);
        vm.expectRevert(Referral.SelfReferral.selector);
        referral.setReferrer(address(3), address(3));
    }

    function testSetReferrer(address user, address referrer) public {
        vm.assume(user!= referrer);
        vm.prank(comp);
        referral.setReferrer(user, referrer);
        assertEq(referral.referrers(user), referrer);
    }

    function testCannotSetSelfReferrerWhenSelfReferral() public {
        vm.prank(address(3));
        vm.expectRevert(Referral.SelfReferral.selector);
        referral.setSelfReferrer(address(3));
    }

    function testSetSelfReferrer(address user, address referrer) public {
        vm.assume(user!= referrer);
        vm.prank(user);
        referral.setSelfReferrer(referrer);
        assertEq(referral.referrers(user), referrer);
    }
}