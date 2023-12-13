// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./AccessControl.sol";

/// @title User Manager Interface
/// @notice Interface for user management operations.
interface IUserManager {
    function registerMember(address) external;

    function newMemberFee() external view returns (uint256);
}

/// @title ERC20 Token Interface
/// @notice Interface for basic ERC20 token operations.
interface IErc20 {
    function balanceOf(address) external view returns (uint256);

    function approve(address, uint256) external returns (bool);
}

/// @title Referral Interface
/// @notice Interface for managing referral relationships.
interface IReferral {
    function setReferrer(address user, address referrer) external;
}

/// @title UNION Member Registration Helper Contract
/// @notice This contract facilitates user registration and referral in the UNION protocol.
/// @dev Extends from the AccessControl contract for role-based permissions.
contract RegHelper is AccessControl {
    address public union;
    address public userManager;
    address public referral;
    address payable public regFeeRecipient;

    uint public rebateFee;
    uint public regFee;

    /// Custom errors for specific revert cases.
    error NotEnoughBalance();
    error NotEnoughFee(uint256 fee);

    /// Events for logging state changes and operations.
    event RegFeeRecipientChange(address newRecipient, address oldRecipient);
    event RebateFeeChange(uint newRebateFee, uint oldRebateFee);
    event RegFeeChange(uint newRegFee, uint oldRegFee);
    event Register(
        address newUser,
        address regFeeRecipient,
        address referrer,
        uint fee,
        uint rebateFee
    );

    /// @notice Constructor to initialize the contract with necessary addresses.
    /// @param _admin Address of the initial admin.
    /// @param _union Address of the UNION token.
    /// @param _userManager Address of the user manager contract.
    /// @param _referral Address of the referral contract.
    constructor(
        address _admin,
        address _union,
        address _userManager,
        address _referral,
        address payable _regFeeRecipient,
        uint _rebateFee,
        uint _regFee
    ) AccessControl(_admin) {
        if(_regFeeRecipient == address(0)) revert NullAddress();
        union = _union;
        userManager = _userManager;
        referral = _referral;
        IErc20(union).approve(userManager, type(uint256).max);
        regFeeRecipient = _regFeeRecipient;
        rebateFee = _rebateFee;
        regFee = _regFee;
        emit RegFeeRecipientChange(regFeeRecipient, address(0));
        emit RebateFeeChange(rebateFee, 0);
        emit RegFeeChange(regFee, 0);
    }

    /// @notice Fallback receive function to accept ETH.
    receive() external payable {}

    /// @notice Sets the recipient for registration fees.
    /// @param newRecipient The address of the new fee recipient.
    function setRegFeeRecipient(
        address payable newRecipient
    ) external onlyAuth {
        if(newRecipient == address(0)) revert NullAddress();
        address payable oldRecipient = regFeeRecipient;
        regFeeRecipient = newRecipient;
        emit RegFeeRecipientChange(newRecipient, oldRecipient);
    }

    /// @notice Sets the rebate fee amount.
    /// @param newRebateFee The new rebate fee amount.
    function setRebateFee(uint newRebateFee) external onlyAuth {
        uint oldRebateFee = rebateFee;
        rebateFee = newRebateFee;
        emit RebateFeeChange(newRebateFee, oldRebateFee);
    }

    /// @notice Sets the registration fee amount.
    /// @param newRegFee The new registration fee amount.
    function setRegFee(uint newRegFee) external onlyAuth {
        uint oldRegFee = regFee;
        regFee = newRegFee;
        emit RegFeeChange(newRegFee, oldRegFee);
    }

    /// @notice Registers a new user, sets their referrer, and handles fees.
    /// @param newUser The address of the user to be registered.
    /// @param referrer The address of the referrer.
    function register(
        address newUser,
        address payable referrer
    ) external payable whenNotPaused {
        IReferral(referral).setReferrer(newUser, referrer);
        if (
            IErc20(union).balanceOf(address(this)) <
            IUserManager(userManager).newMemberFee()
        ) revert NotEnoughBalance();


        if (msg.value < regFee + rebateFee) revert NotEnoughFee(msg.value);

        if (msg.value > 0) {
            // only register member when the registrant supplies fees
            if (rebateFee > 0 && referrer != address(0)) {
                referrer.transfer(rebateFee);
                regFeeRecipient.transfer(msg.value - rebateFee);
            } else {
                regFeeRecipient.transfer(msg.value);
            }    
        }

        IUserManager(userManager).registerMember(newUser);
        emit Register(
            newUser,
            regFeeRecipient,
            referrer,
            msg.value,
            rebateFee
        );
    }
}
