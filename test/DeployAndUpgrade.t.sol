// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";

contract DeployAndUpgrade is Test {
    DeployBox public deployBox;
    UpgradeBox public upgradeBox;
    address public OWNER = makeAddr("OWNER");
    address public proxy;

    function setUp() public {
        deployBox = new DeployBox();
        upgradeBox = new UpgradeBox();
        proxy = deployBox.run();
    }

    function testProxyStartsAsBoxV1() public {
        vm.expectRevert();
        BoxV2(proxy).setNumber(100);
        assertEq(BoxV1(proxy).version(), 1);
    }

    function testUpgradeBox() public {
        BoxV2 box2 = new BoxV2();
        address proxy = upgradeBox.upgradeBox(proxy, address(box2));
        assertEq(BoxV2(proxy).version(), 2);

        BoxV2(proxy).setNumber(100);
        assertEq(BoxV2(proxy).getNumber(), 100);
    }
}