// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {TestWrapper} from "./TestWrapper.sol";
import {AccessControl, AccessControlMock} from "src/mocks/AccessControlMock.sol";

contract TestAccessControl is TestWrapper {
    AccessControlMock public accessControl;
    address public admin;

    function setUp() public virtual {
        admin = address(1);
        deployMocks();
        accessControl = new AccessControlMock(admin);
    }

    function testCannotSetPendingAdminNonAdmin() public {
        vm.expectRevert(AccessControl.NotAdmin.selector);
        accessControl.setPendingAdmin(address(2));
    }

    function testCannotSetPendingAdminNullAddress() public {
        vm.startPrank(admin);
        vm.expectRevert(AccessControl.NullAddress.selector);
        accessControl.setPendingAdmin(address(0));
        vm.stopPrank();
    }

    function testSetPendingAdmin(address newAdmin) public {
        vm.assume(newAdmin!= address(0));
        vm.startPrank(admin);
        accessControl.setPendingAdmin(newAdmin);
        assertEq(accessControl.pendingAdmin(), newAdmin);
        vm.stopPrank();
    }

    function testCannotAcceptAdminNotPendingAdmin() public {
        vm.prank(admin);
        accessControl.setPendingAdmin(address(2));
        vm.prank(address(3));
        vm.expectRevert(AccessControl.NotPendingAdmin.selector);
        accessControl.acceptAdmin();
    }
    
    function testAcceptAdmin() public {
        vm.prank(admin);
        accessControl.setPendingAdmin(address(2));
        vm.prank(address(2));
        accessControl.acceptAdmin();
        assertEq(accessControl.admin(), address(2));
    }

    function testCannotPauseNotAdmin() public {
        vm.expectRevert(AccessControl.NotAdmin.selector);
        accessControl.pause();
    }

    function testCannotPauseWhenPaused() public {
        vm.startPrank(admin);
        accessControl.pause();
        vm.expectRevert(abi.encodeWithSelector(AccessControl.HasPaused.selector, true));
        accessControl.pause();
        vm.stopPrank();
    }

    function testPause() public {
        vm.prank(admin);
        accessControl.pause();
        assertTrue(accessControl.paused());
    }

    function testCannotUnpauseNotAdmin() public {
        vm.expectRevert(AccessControl.NotAdmin.selector);
        accessControl.unpause();
    }

    function testCannotUnpauseWhenNotPaused() public {
        vm.prank(admin);
        vm.expectRevert(abi.encodeWithSelector(AccessControl.HasPaused.selector, false));
        accessControl.unpause();
    }

    function testUnpause() public {
        vm.startPrank(admin);
        accessControl.pause();
        assertTrue(accessControl.paused());
        accessControl.unpause();
        assertFalse(accessControl.paused());
        vm.stopPrank();
    }
}