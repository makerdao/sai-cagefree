// Copyright (C) 2020 Maker Ecosystem Growth Holdings, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

pragma solidity 0.5.15;

// https://github.com/makerdao/sai/blob/master/src/tap.sol
contract SaiTapInterface {
    function sai() public view returns (address);
    function cash(uint256) public;
}

contract TokenInterface {
    function approve(address, uint256) public;
    function transferFrom(address, address, uint256) public returns (bool);
    function withdraw(uint256) public;
    function balanceOf(address) public view returns (uint256);
}

// User must approve() this contract on Sai prior to calling.
contract CageFree {

    address public tap;
    address public sai;
    address public weth;

    event FreeCash(address sender, uint256 amount);

    constructor(address _tap, address _weth) public {
        tap  = _tap;
        sai  = SaiTapInterface(tap).sai();
        weth = _weth;
        TokenInterface(sai).approve(tap, uint256(-1));
    }

    function freeCash(uint256 wad) public returns (uint256 cashoutBalance) {
        TokenInterface(sai).transferFrom(msg.sender, address(this), wad);
        SaiTapInterface(tap).cash(wad);
        cashoutBalance = TokenInterface(weth).balanceOf(address(this));
        require(cashoutBalance > 0, "Zero ETH value");
        TokenInterface(weth).withdraw(cashoutBalance);
        msg.sender.transfer(cashoutBalance);
        emit FreeCash(msg.sender, cashoutBalance);
    }

    function() external payable {
        require(msg.sender == weth, "Only WETH can send ETH");
    }
}
