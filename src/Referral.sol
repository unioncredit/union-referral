// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./AccessControl.sol";

/// @title Referral Contract
/// @notice This contract allows for the management of referral relationships within the UNION protocol.
/// @dev Inherits from the AccessControl contract to utilize role-based permissions.
contract Referral is AccessControl {
    /// @notice Tracks the authorized entities allowed to set referral relationships.
    mapping(address => bool) public setters;

    /// @notice Records referral relationships, mapping each recipient to their referrer.
    mapping(address => address) public referrers;

    /// Custom errors for contract-specific revert reasons.
    error NotSetter();
    error SelfReferral();

    /// Event emitted when a referral relationship is changed.
    event ReferrerChange(
        address indexed newReferrer,
        address indexed oldReferrer
    );

    /// @notice Ensures the function can only be called by an authorized setter.
    modifier onlySetter() {
        if (!setters[msg.sender]) revert NotSetter();
        _;
    }

    /// @notice Constructor to set up the initial admin and authorized setter.
    /// @param _admin The initial admin address for the AccessControl base contract.
    /// @param initialSetter The initial authorized setter.
    constructor(address _admin, address initialSetter) AccessControl(_admin) {
        setters[initialSetter] = true; // Initialize setter
    }

    /// @notice Allows the admin to change the authorization status of a setter.
    /// @param setter The address of the setter whose authorization is to be changed.
    /// @param isAuthorized The new authorization status.
    function changeSetter(address setter, bool isAuthorized) external onlyAuth {
        setters[setter] = isAuthorized;
    }

    /// @dev Internal function to set or change a referrer.
    /// @param recipient The address of the recipient for whom the referrer is being set.
    /// @param referrer The address of the referrer.
    function _setReferrer(address recipient, address referrer) internal {
        if (recipient == referrer) revert SelfReferral();
        address oldReferrer = referrers[recipient];
        referrers[recipient] = referrer;
        emit ReferrerChange(referrer, oldReferrer);
    }

    /// @notice Allows an authorized setter to set a referrer for a user.
    /// @param recipient The address of the recipient for whom the referrer is being set.
    /// @param referrer The address of the referrer.
    function setReferrer(
        address recipient,
        address referrer
    ) external onlySetter {
        _setReferrer(recipient, referrer);
    }

    /// @notice Allows users to set their own referrer.
    /// @param referrer The address of the referrer being set by the user for themselves.
    function setSelfReferrer(address referrer) external {
        _setReferrer(msg.sender, referrer);
    }
}
