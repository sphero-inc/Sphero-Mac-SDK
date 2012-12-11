//
//  MyWindowController.m
//  KeyDrive
//
//  Created by Michael DePhillips on 10/18/12.
//  Copyright (c) 2012 Orbotix Inc. All rights reserved.
//

#import "MyWindowController.h"
#import <RobotKit/RobotKit.h>

@implementation MyWindowController

- (id)initWithPath:(NSString *)newPath
{
    return [super initWithWindowNibName:@"Window"];
}

- (void)dealloc
{
	[super dealloc];
}

- (BOOL)keyWasDown:(unsigned int)mask
{
    return (keyMask & mask) == mask;
}

- (BOOL)isMask:(unsigned long)newMask upEventForModifierMask:(unsigned int)mask
{
    return [self keyWasDown:mask] && ((newMask & mask) == 0x0000);
}

- (BOOL)isMask:(unsigned long)newMask downEventForModifierMask:(unsigned int)mask
{
    return ![self keyWasDown:mask] && ((newMask & mask) == mask);
}

- (void)flagsChanged:(NSEvent *)theEvent
{
    // Modifier keyboard events are keys like shift
    // They can be processed while other keys like arrow keys are clicked too
    if(([theEvent modifierFlags] & NSShiftKeyMask) == NSShiftKeyMask)
    {
        isCalibrating = YES;
        keyMask |= NSShiftKeyMask;
        // Turn on tail light
        [RKBackLEDOutputCommand sendCommandWithBrightness:1.0f];
    }
    else if([self isMask:[theEvent modifierFlags] upEventForModifierMask:NSShiftKeyMask])
    {
        isCalibrating = NO;
        keyMask ^= NSShiftKeyMask;
        // Turn off tail light and send calibrate command at 0 heading
        [RKBackLEDOutputCommand sendCommandWithBrightness:0.0f];
        [RKCalibrateCommand sendCommandWithHeading:0.0f];
    }
}

- (void)keyDown:(NSEvent *)theEvent {
    NSString *keyPressed = [theEvent charactersIgnoringModifiers];
    unichar keyChar = [keyPressed characterAtIndex:0];
    
    // if pressed any arrow
    if(keyChar == NSUpArrowFunctionKey) {
        if( !isCalibrating ) [RKRollCommand sendCommandWithHeading:0.0 velocity:0.6];
    }
    else if(keyChar == NSDownArrowFunctionKey) {
        if( !isCalibrating ) [RKRollCommand sendCommandWithHeading:180.0 velocity:0.6];
    }
    else if(keyChar == NSLeftArrowFunctionKey) {
        // Drive when shift is not active
        if( !isCalibrating ) {
            [RKRollCommand sendCommandWithHeading:270.0 velocity:0.6];
        }
        // Start Calibrate animation when shift is active
        else {
            if( theEvent.type ==  NSKeyDown ) {
                noArrowsPressed = NO;
                calibrateDirection = YES;
                [self calibrateEvent];
            }
            else if( theEvent.type ==  NSKeyUp ) {
                noArrowsPressed = YES;
            }
        }
    }
    else if(keyChar == NSRightArrowFunctionKey) {
        if( !isCalibrating ) {
            [RKRollCommand sendCommandWithHeading:90.0 velocity:0.6];
        }
        else {
            // Drive when shift is not active
            if( theEvent.type ==  NSKeyDown ) {
                noArrowsPressed = NO;
                calibrateDirection = NO;
                [self calibrateEvent];
            }
            // Start Calibrate animation when shift is active
            else if( theEvent.type ==  NSKeyUp ) {
                noArrowsPressed = YES;
            }
        }
    }
    // Space bar pressed stop
    else if( [keyPressed isEqualToString:@" "] ) {
        [RKRollCommand sendStop];
      [super keyDown:theEvent];
    }
}
 
-(void)calibrateEvent {
    if( noArrowsPressed || !isCalibrating ) return;
    int newAngle = [RKRollCommand currentHeading];
    // rotate counter-clockwise
    if( calibrateDirection ) {
        newAngle -= 5;
        if( newAngle < 0 ) newAngle = 359;
    }
    // rotate clockwise
    else {
        newAngle += 5;
        if( newAngle >359 ) newAngle = 0;
    }
    [RKRollCommand sendCommandWithHeading:newAngle velocity:0.0f stopped:YES];
    [self performSelector:@selector(calibrateEvent) withObject:nil afterDelay:0.2];
}

@end
