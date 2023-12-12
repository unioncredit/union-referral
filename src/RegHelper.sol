//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./AccessControl.sol";

interface IUserManager {
    function registerMember(address) external;

    function newMemberFee() external view returns (uint256);
}

interface IErc20 {
    function balanceOf(address) external view returns (uint256);

    function approve(address, uint256) external returns (bool);
}

interface IReferral {
    function setReferrer(address user, address referrer) external;
}

contract RegHelper is AccessControl {
    address public union;
    address public userManager;
    address public referral;
    address payable public regFeeRecipient;

    uint public rebateFee;
    uint public regFee;

    error NotEnoughBalance();
    error NotEnoughFee(uint256 fee);

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

    receive() external payable {}

    function setRegFeeRecipient(
        address payable newRecipient
    ) external onlyAuth {
        if(newRecipient == address(0)) revert NullAddress();
        address payable oldRecipient = regFeeRecipient;
        regFeeRecipient = newRecipient;
        emit RegFeeRecipientChange(regFeeRecipient, oldRecipient);
    }

    function setRebateFee(uint newRebateFee) external onlyAuth {
        uint oldRebateFee = rebateFee;
        rebateFee = newRebateFee;
        emit RebateFeeChange(rebateFee, oldRebateFee);
    }

    function setRegFee(uint newRegFee) external onlyAuth {
        uint oldRegFee = regFee;
        regFee = newRegFee;
        emit RegFeeChange(regFee, oldRegFee);
    }

    function register(
        address newUser,
        address payable referrer
    ) external payable whenNotPaused {
        IReferral(referral).setReferrer(newUser, referrer);
        if (
            // make sure we have enough UNION tokens to pay for the member registration
            IErc20(union).balanceOf(address(this)) <
            IUserManager(userManager).newMemberFee()
        ) revert NotEnoughBalance();
        // make sure the new user has enough ETH
        if (msg.value < regFee + rebateFee) revert NotEnoughFee({fee: msg.value});
        if (regFee > 0 || rebateFee > 0) {
            if (referrer != address(0) && rebateFee > 0) {
                // send the rebate to the referrer
                referrer.transfer(rebateFee);
                // send the rest to the fee recipient
                regFeeRecipient.transfer(msg.value - rebateFee);
            } else {
                // send all to the fee recipient if no referrer
                regFeeRecipient.transfer(msg.value);
            }
        }

        IUserManager(userManager).registerMember(newUser);

        emit Register(newUser, regFeeRecipient, referrer, msg.value, rebateFee);
    }
}
