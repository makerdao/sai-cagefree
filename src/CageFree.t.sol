pragma solidity 0.5.15;

import "ds-test/test.sol";

import "./CageFree.sol";

contract CageFreeTest is DSTest, DSMath {

    CageFree cageFree;

    function setUp() public {
        address mainnetTap = address(0xbda109309f9fafa6dd6a9cb9f1df4085b27ee8ef);
        address mainnetSai = address(0x89d24a6b4ccb1b6faa2625fe562bdd9a23260359);
        address mainnetWeth = address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2);
        cageFree = new CageFree(mainnetTap, mainnetSai, mainnetWeth);
    }

}
