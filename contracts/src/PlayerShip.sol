pragma solidity ^0.8;

import 'hardhat/console.sol';
import './Ship.sol';

contract PlayerShip is Ship {
    uint private x;
    uint private y;
    uint private width;
    uint private height;
    uint private lastX;
    uint private lastY;
    uint private lastFireX;
    uint private lastFireY;
    //list of ints
    uint[] private xs;
    uint[] private ys;

    function update(uint _x, uint _y) public override {
        // check if its the same x and y 
        // if not then update the x and y
        // if yes then do nothing
        if (x != _x) {
            x = _x;
            xs.push(x);
        }

        if (y != _y) {
            y = _y;
            ys.push(y);
        }

        console.log('Updated with x: %s, y: %s', x, y);
        console.log('Updated at address %s with sender %s', address(this), msg.sender);
    }

    function fire() public override returns (uint, uint) {
        // check if list of xs and ys is empty
        if (xs.length == 0) {
            // if yes then return the last x and y
            lastFireX = lastX;
            lastFireY = lastY;
            lastX++;

            if(lastX > width) {
                lastX = 0;
                lastY++;
                lastFireX = lastX;
                lastFireY = lastY;
            }
        } else {
            // if no then return the first x and y
            lastFireX = xs[0];
            lastFireY = ys[0];
        }

        console.log('Fired at x: %s, y: %s', lastFireX, lastFireY);
        console.log('Fired with address %s with sender %s', address(this), msg.sender);

        return (lastFireX, lastFireY);
    }

    function place(uint _width, uint _height) public override returns (uint, uint) {
        width = _width;
        height = _height;
        lastX = 0;
        lastY = 0;
        lastFireX = 0;
        lastFireY = 0;
        //random value for x from 0 to width
        //log the address msg.sender
        
        x = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % width;
        //random value for y from 0 to height
        y = uint(keccak256(abi.encodePacked(block.timestamp + 10, block.difficulty))) % height;

        console.log('Placed ship with x: %s, y: %s', x, y);
        console.log('Placed ship at address %s with sender %s', address(this), msg.sender);

        return (x, y);
    }
}
