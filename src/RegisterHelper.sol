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

    function transfer(address, uint256) external returns (bool);
}

/// @title Referral Interface
/// @notice Interface for managing referral relationships.
interface IReferral {
    function setReferrer(address user, address referrer) external;
}

/// @title UNION Member Registration Helper Contract
/// @notice This contract facilitates user registration and referral in the UNION protocol.
/// @dev Extends from the AccessControl contract for role-based permissions.
contract RegisterHelper is AccessControl {
    address public immutable union;
    address public immutable userManager;
    address public immutable referral;
    address payable public regFeeRecipient;

    uint public rebate;
    uint public regFee;

    /// Custom errors for specific revert cases.
    error NotEnoughBalance();
    error NotEnoughFee(uint256 fee);

    /// Events for logging state changes and operations.
    event RegFeeRecipientChange(address newRecipient, address oldRecipient);
    event RebateChange(uint newRebate, uint oldRebate);
    event RegFeeChange(uint newRegFee, uint oldRegFee);
    event Register(address newUser, address regFeeRecipient, address referrer, uint fee, uint regFee, uint rebate);

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
        uint _rebate,
        uint _regFee
    ) AccessControl(_admin) {
        if (_regFeeRecipient == payable(address(0))) revert NullAddress();
        union = _union;
        userManager = _userManager;
        referral = _referral;
        IErc20(union).approve(userManager, type(uint256).max);
        regFeeRecipient = _regFeeRecipient;
        rebate = _rebate;
        regFee = _regFee;
        emit RegFeeRecipientChange(regFeeRecipient, address(0));
        emit RebateChange(rebate, 0);
        emit RegFeeChange(regFee, 0);
    }

    /// @notice Fallback receive function to accept ETH.
    receive() external payable {}

    /// @notice Sets the recipient for registration fees.
    /// @param newRecipient The address of the new fee recipient.
    function setRegFeeRecipient(address payable newRecipient) external onlyAuth {
        if (newRecipient == address(0)) revert NullAddress();
        address payable oldRecipient = regFeeRecipient;
        regFeeRecipient = newRecipient;
        emit RegFeeRecipientChange(newRecipient, oldRecipient);
    }

    /// @notice Sets the rebate amount.
    /// @param newRebate The new rebate amount.
    function setRebate(uint newRebate) external onlyAuth {
        uint oldRebate = rebate;
        rebate = newRebate;
        emit RebateChange(newRebate, oldRebate);
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
    function register(address newUser, address payable referrer) external payable whenNotPaused {
        IReferral(referral).setReferrer(newUser, referrer);
        if (IErc20(union).balanceOf(address(this)) < IUserManager(userManager).newMemberFee())
            revert NotEnoughBalance();

        if (msg.value < regFee + rebate) revert NotEnoughFee(msg.value);
        
        uint diff = msg.value - regFee - rebate;
        if(referrer != address(0)) {
            if(regFee > 0)sendCall(regFeeRecipient, regFee);
            if(rebate > 0)sendCall(referrer, rebate); 
        } else {
            if(regFee > 0 || rebate > 0)sendCall(regFeeRecipient,regFee + rebate);
        }
        if(diff > 0)sendCall(payable(msg.sender), diff);

        IUserManager(userManager).registerMember(newUser);
        emit Register(newUser, regFeeRecipient, referrer, msg.value, regFee, rebate);
    }

    function claimToken(address recipient) external onlyAuth {
        if (recipient== address(0)) revert NullAddress();
        IErc20 token = IErc20(union);
        uint256 balance = token.balanceOf(address(this));
        token.transfer(recipient, balance);
    } 

    function sendCall(address payable to, uint amount) public payable {
        (bool sent, ) = to.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
}
