// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "../AccessControl.sol";

contract AccessControlMock is AccessControl {
    constructor(address _admin) AccessControl(_admin) {}
}
