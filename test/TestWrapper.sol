pragma solidity 0.8.19;

import "forge-std/Test.sol";
import {UnionTokenMock} from "src/mocks/UnionTokenMock.sol";
import {UserManagerMock} from "src/mocks/UserManagerMock.sol";
import {GnosisSafeProxyMock} from "src/mocks/GnosisSafeProxyMock.sol";

contract TestWrapper is Test {
    UnionTokenMock public unionTokenMock;
    UserManagerMock public userManagerMock;
    GnosisSafeProxyMock public gnosisSafeProxyMock;

    function deployMocks() public {
        unionTokenMock = new UnionTokenMock();
        userManagerMock = new UserManagerMock(address(unionTokenMock));
        gnosisSafeProxyMock = new GnosisSafeProxyMock(address(11));
    }
}