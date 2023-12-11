//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract AccessControl {
    address public admin;
    address public pendingAdmin;
    bool public paused;

    error HasPaused(bool _paused);
    error NullAddress();
    error NotAdmin();
    error NotPendingAdmin();

    event AdminChange(address newAdmin, address oldAdmin);
    event Pause(address account);
    event Unpause(address account);

    modifier onlyAuth() {
        if (msg.sender != admin) revert NotAdmin();
        _;
    }

    modifier whenNotPaused() {
        if (paused) revert HasPaused({
            _paused: true
        });
        _;
    }

    modifier whenPaused() {
        if (!paused) revert HasPaused({
            _paused: false
        });
        _;
    }

    constructor(address _admin) {
        admin = _admin;
    }

    function setPendingAdmin(address newAdmin) public onlyAuth {
        if (newAdmin == address(0)) revert NullAddress();
        pendingAdmin = newAdmin;
    }

    function acceptAdmin() public {
        if (pendingAdmin != msg.sender) revert NotPendingAdmin();
        address oldAdmin = admin;
        admin = pendingAdmin;
        pendingAdmin = address(0);
        emit AdminChange(admin, oldAdmin);
    }

    function pause() external onlyAuth whenNotPaused {
        paused = true;
        emit Pause(msg.sender);
    }

    function unpause() external onlyAuth whenPaused {
        paused = false;
        emit Unpause(msg.sender);
    }
}
