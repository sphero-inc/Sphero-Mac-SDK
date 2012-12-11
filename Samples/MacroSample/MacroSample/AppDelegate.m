//
//  AppDelegate.m
//  MacroSample
//  This Application sets up a connection to Sphero and runs macros with button presses
//
//  Created by Michael DePhillips on 6/21/12.
//  Copyright (c) 2012 Orbotix Inc. All rights reserved.
//

#import "AppDelegate.h"
#import <RobotKit/RobotKit.h>

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(appWillTerminate:)
												 name:NSApplicationWillTerminateNotification
											   object:nil];
    
    robotOnline = NO;
    
    /* Insert code here to initialize your application */
    [self setupRobotConnection];
}

- (void)appWillTerminate:(NSNotification *)notification {
    
    if( !robotOnline ) return;
    
    /* When the application is entering the background we need to close the connection to the robot*/
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RKDeviceConnectionOnlineNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationWillTerminateNotification object:nil];
    
    // Close the connection
    [[RKRobotProvider sharedRobotProvider] closeRobotConnection];
    
    robotOnline = NO;
}

-(void)setupRobotConnection {
    /*Try to connect to the robot*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRobotOnline) name:RKDeviceConnectionOnlineNotification object:nil];
    [[RKRobotProvider sharedRobotProvider] openRobotConnection];
}

- (void)handleRobotOnline {
    /*The robot is now online, we can begin sending commands*/
    if(!robotOnline) {
        /* Send commands to Sphero Here: */
        robotOnline = YES;
    }
}

-(IBAction)squarePressed:(id)sender {
    
    // Get drive speed
    float driveSpeed = speedSlider.intValue / 10.0f;
    
    // Create a new macro object to send to Sphero
    RKMacroObject* squareMacro = [[RKMacroObject alloc]init];

    // Change color immediately to blue
    [squareMacro addCommand:[RKMCRGB commandWithRed:0 green:0 blue:1.0 delay:0]];
    // Start driving ball ( this is not a blocking command, so you need to delay seperate)
    [squareMacro addCommand:[RKMCRoll commandWithSpeed:driveSpeed
                                               heading:0
                                                 delay:0]];
    // Delay for a certain time period
    [squareMacro addCommand:[RKMCDelay commandWithDelay:delaySlider.intValue]];
    // Have ball come to a stop (important that you keep the same heading)
    [squareMacro addCommand:[RKMCRoll commandWithSpeed:0.0f
                                               heading:0
                                                 delay:255]];
    
    // Change color immediately to green
    [squareMacro addCommand:[RKMCRGB commandWithRed:0 green:1.0 blue:0 delay:0]];
    // Start driving ball ( this is not a blocking command, so you need to delay seperate)
    [squareMacro addCommand:[RKMCRoll commandWithSpeed:driveSpeed
                                               heading:90
                                                 delay:0]];
    // Delay for a certain time period
    [squareMacro addCommand:[RKMCDelay commandWithDelay:delaySlider.intValue]];
    // Have ball come to a stop (important that you keep the same heading)
    [squareMacro addCommand:[RKMCRoll commandWithSpeed:0.0f
                                               heading:90
                                                 delay:255]];
    
    // Change color immediately to red
    [squareMacro addCommand:[RKMCRGB commandWithRed:1.0 green:0 blue:0 delay:0]];
    // Start driving ball ( this is not a blocking command, so you need to delay seperate)
    [squareMacro addCommand:[RKMCRoll commandWithSpeed:driveSpeed
                                               heading:180
                                                 delay:0]];
    // Delay for a certain time period
    [squareMacro addCommand:[RKMCDelay commandWithDelay:delaySlider.intValue]];
    // Have ball come to a stop (important that you keep the same heading)
    [squareMacro addCommand:[RKMCRoll commandWithSpeed:0.0f
                                               heading:180
                                                 delay:255]];
    
    // Change color immediately to green
    [squareMacro addCommand:[RKMCRGB commandWithRed:1.0 green:1.0 blue:1.0 delay:0]];
    // Start driving ball ( this is not a blocking command, so you need to delay seperate)
    [squareMacro addCommand:[RKMCRoll commandWithSpeed:driveSpeed
                                               heading:270
                                                 delay:0]];
    // Delay for a certain time period
    [squareMacro addCommand:[RKMCDelay commandWithDelay:delaySlider.intValue]];
    // Have ball come to a stop (important that you keep the same heading)
    [squareMacro addCommand:[RKMCRoll commandWithSpeed:0.0f
                                               heading:270
                                                 delay:255]];

    // Stop driving ball
    [squareMacro addCommand:[RKMCRoll commandWithSpeed:0.0f heading:0 delay:255]];
    // Set send mode, normal means simple load and run
    squareMacro.mode = RKMacroObjectModeNormal;
    // Play macro
    [squareMacro playMacro];
    // Release memory
    [squareMacro release];
}

-(IBAction)fadePressed:(id)sender {
    [self returnSpheroToStableState];
    
    // Create a new macro object to send to Sphero
    RKMacroObject* fadeMacro = [[RKMacroObject alloc]init];
    // Start a loop to vibrate length
    [fadeMacro addCommand:[RKMCLoopFor commandWithRepeats:loopSlider.intValue]];

    // Fade color immediately to purple
    [fadeMacro addCommand:[RKMCSlew commandWithRed:0
                                             green:1.0
                                              blue:1.0
                                             delay:delaySlider.intValue]];
    // You must delay to give the fade time to perform
    [fadeMacro addCommand:[RKMCDelay commandWithDelay:delaySlider.intValue]];
    // Fade color immediately to purple
    [fadeMacro addCommand:[RKMCSlew commandWithRed:1.0
                                             green:0
                                              blue:1.0
                                             delay:delaySlider.intValue]];
    // You must delay to give the fade time to perform
    [fadeMacro addCommand:[RKMCDelay commandWithDelay:delaySlider.intValue]];
    // Fade color immediately to purple
    [fadeMacro addCommand:[RKMCSlew commandWithRed:1.0
                                             green:1.0
                                              blue:0
                                             delay:delaySlider.intValue]];
    // You must delay to give the fade time to perform
    [fadeMacro addCommand:[RKMCDelay commandWithDelay:delaySlider.intValue]];
    // End Loop
    [fadeMacro addCommand:[RKMCLoopEnd command]];
    // Turn to green
    [fadeMacro addCommand:[RKMCRGB commandWithRed:0 green:1.0 blue:0 delay:0]];
    // Set send mode, normal means simple load and run
    fadeMacro.mode = RKMacroObjectModeNormal;
    // Play macro
    [fadeMacro playMacro];
    // Release memory
    [fadeMacro release];
}

-(IBAction)shapesPressed:(id)sender {
    [self returnSpheroToStableState];
    
    // Get drive speed
    float driveSpeed = speedSlider.intValue / 10.0f;
    
    // Create a new macro object to send to Sphero
    RKMacroObject* shapesMacro = [[RKMacroObject alloc]init];
    // Change color immediately to blue
    [shapesMacro addCommand:[RKMCRGB commandWithRed:0 green:0 blue:1.0 delay:0]];

    for( int i = 0; i < loopSlider.intValue; i++ ) {
        // Start driving ball ( this is not a blocking command, so you need to delay seperate)
        [shapesMacro addCommand:[RKMCRoll commandWithSpeed:driveSpeed
                                                   heading:i*(360/loopSlider.intValue)
                                                     delay:0]];
        // Delay for a certain time period
        [shapesMacro addCommand:[RKMCDelay commandWithDelay:delaySlider.intValue]];
        // Have ball come to a stop (important that you keep the same heading)
        [shapesMacro addCommand:[RKMCRoll commandWithSpeed:0.0f
                                                   heading:i*(360/loopSlider.intValue)
                                                     delay:255]];
    }
    // Stop driving ball
    [shapesMacro addCommand:[RKMCRoll commandWithSpeed:0.0f heading:0 delay:255]];
    // Set send mode, normal means simple load and run
    shapesMacro.mode = RKMacroObjectModeNormal;
    // Play macro
    [shapesMacro playMacro];
    // Release memory
    [shapesMacro release];
}

-(IBAction)figure8Pressed:(id)sender {
    [self returnSpheroToStableState];
    
    // Get drive speed
    float driveSpeed = speedSlider.intValue / 10.0f;
    
    // Create a new macro object to send to Sphero
    RKMacroObject* figure8Macro = [[RKMacroObject alloc]init];
    // Start driving ball ( this is not a blocking command, so you need to delay seperate)
    [figure8Macro addCommand:[RKMCRoll commandWithSpeed:driveSpeed heading:0 delay:0]];
    // Start a loop to figure 8
    [figure8Macro addCommand:[RKMCLoopFor commandWithRepeats:loopSlider.intValue]];
    // Make Sphero do a circle clockwise (not a blocking command)
    [figure8Macro addCommand:[RKMCRotateOverTime commandWithRotation:360
                                                            delay:delaySlider.intValue]];
    // Delay for a certain time period
    [figure8Macro addCommand:[RKMCDelay commandWithDelay:delaySlider.intValue]];
    // Make Sphero do a circle counter-clockwise (not a blocking command)
    [figure8Macro addCommand:[RKMCRotateOverTime commandWithRotation:-360
                                                               delay:delaySlider.intValue]];
    // Delay for a certain time period
    [figure8Macro addCommand:[RKMCDelay commandWithDelay:delaySlider.intValue]];
    // End loop bracket
    [figure8Macro addCommand:[RKMCLoopEnd command]];
    // Stop driving ball
    [figure8Macro addCommand:[RKMCRoll commandWithSpeed:0.0f heading:0 delay:0]];
    // Set send mode, normal means simple load and run
    figure8Macro.mode = RKMacroObjectModeNormal;
    // Play macro
    [figure8Macro playMacro];
    // Release memory
    [figure8Macro release];
}

-(IBAction)vibratePressed:(id)sender {
    [self returnSpheroToStableState];
    
    // Create a new macro object to send to Sphero
    RKMacroObject* vibrateMacro = [[RKMacroObject alloc]init];
    // Change color immediately to blue
    [vibrateMacro addCommand:[RKMCRGB commandWithRed:1.0 green:0 blue:0 delay:0]];
    // You must turn stabilization off to use the raw motors
    [vibrateMacro addCommand:[RKMCStabilization commandWithSetting:RKStabilizationStateOff
                                                          delay:0]];
    // Start a loop to vibrate length
    [vibrateMacro addCommand:[RKMCLoopFor commandWithRepeats:(delaySlider.intValue/50)]];
    // Run both motors forward at full power
    [vibrateMacro addCommand:[RKMCRawMotor commandWithLeftMode:RKRawMotorModeForward
                                                  leftSpeed:90
                                                  rightMode:RKRawMotorModeForward
                                                 rightSpeed:90
                                                      delay:0]];
    // Delay a millisecond
    [vibrateMacro addCommand:[RKMCDelay commandWithDelay:1]];
    // Run both motors forward at full power
    [vibrateMacro addCommand:[RKMCRawMotor commandWithLeftMode:RKRawMotorModeReverse
                                                     leftSpeed:90
                                                     rightMode:RKRawMotorModeReverse
                                                    rightSpeed:90
                                                         delay:0]];
    // Delay a millisecond
    [vibrateMacro addCommand:[RKMCDelay commandWithDelay:1]];
    // End Loop
    [vibrateMacro addCommand:[RKMCLoopEnd command]];
    // Remeber to turn stabilization back on
    [vibrateMacro addCommand:[RKMCStabilization commandWithSetting:RKStabilizationStateOn
                                                          delay:0]];
    // Turn to green
    [vibrateMacro addCommand:[RKMCRGB commandWithRed:0 green:1.0 blue:0 delay:0]];
    // Set send mode, normal means simple load and run
    vibrateMacro.mode = RKMacroObjectModeNormal;
    // Play macro
    [vibrateMacro playMacro];
    // Release memory
    [vibrateMacro release];
}

-(IBAction)spinPressed:(id)sender {
    [self returnSpheroToStableState];

    // Create a new macro object to send to Sphero
    RKMacroObject* spinMacro = [[RKMacroObject alloc]init];
    // Turn on back LED
    [spinMacro addCommand:[RKMCFrontLED commandWithIntensity:1.0f delay:0]];
    // Start a loop to spin
    [spinMacro addCommand:[RKMCLoopFor commandWithRepeats:loopSlider.intValue]];
    // Spin Sphero
    [spinMacro addCommand:[RKMCRotateOverTime commandWithRotation:360
                                                            delay:(2000/speedSlider.intValue)]];
    // Delay for a certain time period
    [spinMacro addCommand:[RKMCDelay commandWithDelay:(2000/speedSlider.intValue)]];
    // End loop bracket
    [spinMacro addCommand:[RKMCLoopEnd command]];
    // Turn off back LED
    [spinMacro addCommand:[RKMCFrontLED commandWithIntensity:0.0f delay:0]];
    // Set send mode, normal means simple load and run
    spinMacro.mode = RKMacroObjectModeNormal;
    // Play macro
    [spinMacro playMacro];
    // Release memory
    [spinMacro release];
}

-(IBAction)flipPressed:(id)sender {
    [self returnSpheroToStableState];
    
    // Create a new macro object to send to Sphero
    RKMacroObject* flipMacro = [[RKMacroObject alloc]init];
    // Change color immediately to blue
    [flipMacro addCommand:[RKMCRGB commandWithRed:0 green:0 blue:1.0 delay:0]];
    // You must turn stabilization off to use the raw motors
    [flipMacro addCommand:[RKMCStabilization commandWithSetting:RKStabilizationStateOff
                                                          delay:0]];
    // Run both motors forward at full power
    [flipMacro addCommand:[RKMCRawMotor commandWithLeftMode:RKRawMotorModeForward
                                                  leftSpeed:255
                                                  rightMode:RKRawMotorModeForward
                                                 rightSpeed:255
                                                      delay:0]];
    // Delay for a certain time period
    [flipMacro addCommand:[RKMCDelay commandWithDelay:delaySlider.intValue]];
    // Remeber to turn stabilization back on
    [flipMacro addCommand:[RKMCStabilization commandWithSetting:RKStabilizationStateOn
                                                          delay:0]];
    // Turn to green
    [flipMacro addCommand:[RKMCRGB commandWithRed:0 green:1.0 blue:0 delay:0]];
    // Set send mode, normal means simple load and run
    flipMacro.mode = RKMacroObjectModeNormal;
    // Play macro
    [flipMacro playMacro];
    // Release memory
    [flipMacro release];
}

-(IBAction)stopPressed:(id)sender {
    [self returnSpheroToStableState];
}

-(void) returnSpheroToStableState {
    [RKAbortMacroCommand sendCommand];
    [RKStabilizationCommand sendCommandWithState:RKStabilizationStateOn];
    [RKBackLEDOutputCommand sendCommandWithBrightness:0.0f];
    [RKRollCommand sendStop];
}

@end
