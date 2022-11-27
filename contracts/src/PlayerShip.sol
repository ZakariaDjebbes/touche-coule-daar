pragma solidity ^0.8;

import 'hardhat/console.sol';
import './Ship.sol';

contract PlayerShip is Ship {
    uint private x; // Current x position
    uint private y; // Current y position
    uint private width; // Width of the board
    uint private height; // Height of the board
    uint private lastX; // Last x position
    uint private lastY; // Last y position
    uint private lastFireX; // Last position x at which we fired
    uint private lastFireY; // Last position y at which we fired
    //list of ints
    uint[] private xs; // List of x positions of previous ships, since update is called when the provided x and y are taken, we can keep track of those and fire directly at them since we know they are occupied
    uint[] private ys; // List of y position of previous ships

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
        // My strategy is quite simple, I fire from 0, 0 to width, height incrementally
        // However if I know that a ship is at a certain position, I will fire at it directly (From the update function)
        // check if list of xs and ys is empty
        if (xs.length == 0) {
            // if yes then return the last x and y

            // Avoid firing on my self
            if (lastX == x && lastY == y) {
                lastX++;
            }

            // If we reach the end of the board, we reset the x and increment the y
            if(lastX > width) {
                lastX = 0;
                lastY++;
                lastFireX = lastX;
                lastFireY = lastY;
            }

            lastFireX = lastX;
            lastFireY = lastY;
            
            lastX++;
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
        // Place ships at a random position
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
