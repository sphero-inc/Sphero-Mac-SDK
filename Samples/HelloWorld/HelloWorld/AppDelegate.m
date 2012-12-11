//
//  AppDelegate.m
//  HelloWorld
//  This Application sets up a connection to Sphero and blinks the LED green
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
    
    /*Register for Sphero connection notifications*/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleRobotOnline)
                                                 name:RKDeviceConnectionOnlineNotification
                                               object:nil];
    /* Regained connection noitification */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleRobotOnline)
                                                 name:RKRobotDidGainControlNotification
                                               object:nil];
    
    // Takes ~20 seconds to recognize a ball going offline
    // Recognizes immediately when we close the connection to the ball
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleRobotOffline)
                                                 name:RKRobotIsNoLongerAvailableNotification
                                               object:nil];
    
    robotOnline = NO;
    // Not connected
    [disconnectButton setEnabled:NO];
}

- (void)appWillTerminate:(NSNotification *)notification {
    
    if( !robotOnline ) return;
    
    /* When the application is entering the background we need to close the connection to the robot*/
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:RKDeviceConnectionOnlineNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSApplicationWillTerminateNotification
                                                  object:nil];
    
    /*Try to connect to the robot*/
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:RKDeviceConnectionOnlineNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:RKRobotDidGainControlNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:RKRobotIsNoLongerAvailableNotification
                                                  object:nil];
    
    // Close the connection
    [[RKRobotProvider sharedRobotProvider] closeRobotConnection];
    
    robotOnline = NO;
}

-(void)dealloc {
    [connectButton release];
    [disconnectButton release];
    [super dealloc];
}

-(IBAction)connectPressed:(id)sender {
    [self setupRobotConnection];
}

-(IBAction)disconnectPressed:(id)sender {
    // Close the connection
    [[RKRobotProvider sharedRobotProvider] closeRobotConnection];
    robotOnline = NO;
}

-(void)setupRobotConnection {
    /*Try to connect to the robot*/
    [[RKRobotProvider sharedRobotProvider] openRobotConnection];
}

- (void)handleRobotOnline {
    /*The robot is now online, we can begin sending commands*/
    if(!robotOnline) {
        [connectButton setEnabled:NO];
        [disconnectButton setEnabled:YES];
        /* Send commands to Sphero Here: */
        robotOnline = YES;
        [self blinkSpheroOn];
    }
}


- (void)handleRobotOffline {
    [connectButton setEnabled:YES];
    [disconnectButton setEnabled:NO];
    /*The robot is now offline*/
    robotOnline = NO;
}

-(void)blinkSpheroOn {
    if( !robotOnline ) return;
    
    // Send a command to make Sphero Green
    [RKRGBLEDOutputCommand sendCommandWithRed:0.0 green:1.0 blue:0.0];
    [self performSelector:@selector(blinkSpheroOff) withObject:nil afterDelay:0.5];
}

-(void)blinkSpheroOff {
    if( !robotOnline ) return;
    
    // Send a command to turn off Sphero's LED
    [RKRGBLEDOutputCommand sendCommandWithRed:0.0 green:0.0 blue:0.0];
    [self performSelector:@selector(blinkSpheroOn) withObject:nil afterDelay:0.5];
}

@end
