//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./AccessControl.sol";

contract Referral is AccessControl {
    mapping(address comp => bool authed) public setters; // authorized referral setters
    mapping(address recipient => address referrer) public referrers; // referral giver addresses

    error SelfReferral();

    event ReferrerChange(address newReferrer, address oldReferrer);

    modifier onlySetter() {
        require(setters[msg.sender]);
        _;
    }

    constructor(address _admin, address comp) AccessControl(_admin) {
        setters[comp] = true; // init setter
    }

    function changeSetter(address setter, bool auth) external onlyAuth {
        setters[setter] = auth;
    }

    function _setReferrer(address user, address referrer) internal {
        if (user == referrer) revert SelfReferral();
        address oldReferrer = referrers[user];
        referrers[user] = referrer;
        emit ReferrerChange(referrer, oldReferrer);
    }

    /** @dev For the authed 3rd party to set users' referrers */
    function setReferrer(address user, address referrer) external onlySetter {
        _setReferrer(user, referrer);
    }

    /** @dev Only for the users to set their own referrers */
    function setSelfReferrer(address referrer) external {
        _setReferrer(msg.sender, referrer);
    }
}
