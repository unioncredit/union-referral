// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/// @title Access Control Contract
/// @notice This contract provides basic access control with an admin role, pause functionality, and pending admin transfer.
/// @dev The contract uses role-based permissioning for administrative actions and pausing functionality.
contract AccessControl {
    /// @notice Address of the current admin
    address public admin;

    /// @notice Address of the pending admin, to be accepted as new admin
    address public pendingAdmin;

    /// @notice Indicates whether the contract is paused
    bool public paused;

    /// Custom errors for contract-specific revert reasons
    error HasPaused(bool _paused);
    error NullAddress();
    error NotAdmin();
    error NotPendingAdmin();

    /// Events for logging state changes
    event AdminChange(address newAdmin, address oldAdmin);
    event Pause(address account);
    event Unpause(address account);

    /// @notice Ensures only the admin can perform certain actions
    modifier onlyAuth() {
        if (msg.sender != admin) revert NotAdmin();
        _;
    }

    /// @notice Ensures certain actions can only be performed when the contract is not paused
    modifier whenNotPaused() {
        if (paused) revert HasPaused({_paused: true});
        _;
    }

    /// @notice Ensures certain actions can only be performed when the contract is paused
    modifier whenPaused() {
        if (!paused) revert HasPaused({_paused: false});
        _;
    }

    /// @notice Constructor to set the initial admin of the contract
    /// @param _admin The initial admin address
    constructor(address _admin) {
        admin = _admin;
    }

    /// @notice Sets a new pending admin
    /// @dev Can only be called by the current admin
    /// @param newAdmin The address of the proposed new admin
    function setPendingAdmin(address newAdmin) public onlyAuth {
        if (newAdmin == address(0)) revert NullAddress();
        pendingAdmin = newAdmin;
    }

    /// @notice Accepts the role of admin by the pending admin
    /// @dev Transfers the admin role from the current admin to the pending admin
    function acceptAdmin() public {
        if (pendingAdmin != msg.sender) revert NotPendingAdmin();
        address oldAdmin = admin;
        admin = pendingAdmin;
        pendingAdmin = address(0);
        emit AdminChange(admin, oldAdmin);
    }

    /// @notice Pauses the contract
    /// @dev Can only be called by the current admin when the contract is not paused
    function pause() external onlyAuth whenNotPaused {
        paused = true;
        emit Pause(msg.sender);
    }

    /// @notice Unpauses the contract
    /// @dev Can only be called by the current admin when the contract is paused
    function unpause() external onlyAuth whenPaused {
        paused = false;
        emit Unpause(msg.sender);
    }
}
