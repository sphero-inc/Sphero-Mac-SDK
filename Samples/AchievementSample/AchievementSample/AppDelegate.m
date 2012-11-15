//
//  AppDelegate.m
//  AcheivementSample
//  This Application sets up a connection to Sphero and records events to SpheroVerse
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
    
    //Register to be notified when an achievement is earned.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(spheroWorldAchievementEarned:) name:RKAchievementEarnedNotification object:nil];
    
    // Set APP ID to receive acheivements
    [RKSpheroWorldAuthMac setAppID:@"macaea4beca16e9960ff7d766d05b2fbcf2d"
                            secret:@"QBmUyk5qbR7asBhVzG9z"];
    
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

-(IBAction)redPressed:(id)sender {
    [RKRGBLEDOutputCommand sendCommandWithRed:1.0 green:0.0 blue:0.0];
    //Record that red was pressed so it is counted toward achievement progress
    [RKAchievement recordEvent:@"red" withCount:1];
}

-(IBAction)greenPressed:(id)sender {
    [RKRGBLEDOutputCommand sendCommandWithRed:0.0 green:1.0 blue:0.0];
    //Record that green was pressed so it is counted toward achievement progress
    [RKAchievement recordEvent:@"green" withCount:1];
}

-(IBAction)bluePressed:(id)sender {
    [RKRGBLEDOutputCommand sendCommandWithRed:0.0 green:0.0 blue:1.0];
    //Record that blue was pressed so it is counted toward achievement progress
    [RKAchievement recordEvent:@"blue" withCount:1];
}

#pragma mark Achievement related

-(void)spheroWorldAchievementEarned:(NSNotification*)notification {
    
    //Get the achievement that was earned from the userInfo dictionary
    RKAchievement *achievement = [notification.userInfo objectForKey:RKAchievementEarnedAchievementKey];

    // Show AlertDialog on the Main Thread
    [self performSelectorOnMainThread:@selector(displayAchievementAlertWithAcheivement:)
                           withObject:achievement
                        waitUntilDone:NO];
    
    //This would be the appropriate time to play a sound a let the user know they earned an achievment
}

-(void) displayAchievementAlertWithAcheivement:(RKAchievement*)achievement {

    NSAlert* alertFail = [[NSAlert alertWithMessageText:@"Acheivement Earned"
                                          defaultButton:@"Ok" alternateButton:nil
                                            otherButton:nil
                              informativeTextWithFormat:achievement.description] retain];
    
    [alertFail runModal];
    [alertFail release];
}

@end
