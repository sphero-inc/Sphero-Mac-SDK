//
//  AppDelegate.m
//  HelloWorld
//  This Application sets up a connection to Sphero and blinks the LED green
//
//  Created by Michael DePhillips on 6/21/12.
//  Copyright (c) 2012 Orbotix Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "MyWindowController.h"
#import <RobotKit/RobotKit.h>

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(appWillTerminate:)
												 name:NSApplicationWillTerminateNotification
											   object:nil];
    
    if (myWindowController == NULL)
		myWindowController = [[MyWindowController alloc] initWithWindowNibName:@"Window"];
	
	[myWindowController showWindow:self];
    
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
        [myWindowController robotWentOnline];
    }
}

@end
