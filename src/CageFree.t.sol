pragma solidity 0.5.15;

import "ds-test/test.sol";
import "ds-math/math.sol";

import "./CageFree.sol";

contract Hevm { function warp(uint) public; }

contract CageFreeTest is DSTest, DSMath {

    CageFree cageFree;
    Hevm hevm;

    // CHEAT_CODE = 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D
    bytes20 constant CHEAT_CODE =
        bytes20(uint160(uint256(keccak256('hevm cheat code'))));

    function setUp() public {
        hevm = Hevm(address(CHEAT_CODE));
        address mainnetTap = address(0xBda109309f9FafA6Dd6A9CB9f1Df4085B27Ee8eF);
        address mainnetSai = address(0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359);
        address mainnetWeth = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
        cageFree = new CageFree(mainnetTap, mainnetSai, mainnetWeth);
    }

    function vote() private {
        if (chief.hat() != address(spell)) {
            gov.approve(address(chief), uint256(-1));
            chief.lock(sub(gov.balanceOf(address(this)), 1 ether));

            assertTrue(!spell.done());

            address[] memory yays = new address[](1);
            yays[0] = address(spell);

            chief.vote(yays);
            chief.lift(address(spell));
        }
        assertEq(chief.hat(), address(spell));
    }

    function scheduleWaitAndCast() public {
        spell.schedule();
        hevm.warp(add(now, pause.delay()));
        spell.cast();
    }

}
