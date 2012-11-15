//
//  AppDelegate.m
//  SensorStreaming
//
//  Created by Michael DePhillips on 6/21/12.
//  Copyright (c) 2012 Orbotix Inc. All rights reserved.
//

#import "AppDelegate.h"
#import <RobotKit/RobotKit.h>
#include <ApplicationServices/ApplicationServices.h>
#include <unistd.h>

#define TOTAL_PACKET_COUNT 200
#define PACKET_COUNT_THRESHOLD 50

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(appWillTerminate:)
												 name:NSApplicationWillTerminateNotification
											   object:nil];
    
    // Get screen resolution
    NSRect screenRect;
    NSArray *screenArray = [NSScreen screens];
    NSUInteger screenCount = [screenArray count];
    
    // Grabbed the array of screens (may be more than one if you have ext. monitor)
    NSScreen *screen = [screenArray objectAtIndex: 0];
    screenRect = [screen visibleFrame];

    // Add all screen widths and heights together
    for (int index = 0; index < screenCount; index++)
    {
        NSScreen *screen = [screenArray objectAtIndex: index];
        screenRect = [screen visibleFrame];
        screenWidth += screenRect.size.width;
        screenHeight = MAX(screenHeight, screenRect.size.height);
    }
    
    // hard coded fix for thunderbolt display monitor
    screenHeight += 80;
    
    isControllingMouse = NO;
    robotOnline = NO;
    dataStreamingOn = NO;
    isMouseLeftDown = NO;
    isMouseRightDown = NO;
    
    // Insert code here to initialize your application
    [self setupRobotConnection];
}

- (void)appWillTerminate:(NSNotification *)notification {
    // disconnect Sphero
    if( !robotOnline ) return;
    
    /*When the application is entering the background we need to close the connection to the robot*/
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RKDeviceConnectionOnlineNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationWillTerminateNotification object:nil];
    
    // Close the connection
    [[RKRobotProvider sharedRobotProvider] closeRobotConnection];
    
    robotOnline = NO;
    dataStreamingOn = NO;
}

-(void)setupRobotConnection {
    /*Try to connect to the robot*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRobotOnline) name:RKDeviceConnectionOnlineNotification object:nil];
    [[RKRobotProvider sharedRobotProvider] openRobotConnection];
}

- (void)handleRobotOnline {
    /*The robot is now online, we can begin sending commands*/
    if(!robotOnline) {
        // Disable stabilization (the control unit)
        [RKStabilizationCommand sendCommandWithState:RKStabilizationStateOff];
        [RKBackLEDOutputCommand sendCommandWithBrightness:1.0];
        /* Send commands to Sphero Here: */
        [self requestDataStreaming];
        ////Register for asynchronise data streaming packets
        [[RKDeviceMessenger sharedMessenger] addDataStreamingObserver:self selector:@selector(handleAsyncData:)];
    }
    robotOnline = YES;
}

-(void) requestDataStreaming {
    
    packetCount = 0;
    
    //// Start data streaming for the accelerometer and IMU data. The update rate is set to 20Hz with
    //// one sample per update, so the sample rate is 10Hz. Packets are sent continuosly.
    [RKSetDataStreamingCommand sendCommandWithSampleRateDivisor:10 packetFrames:1
                                                     sensorMask:RKDataStreamingMaskIMUAnglesFilteredAll
                                                    packetCount:TOTAL_PACKET_COUNT];
}

- (void)handleAsyncData:(RKDeviceAsyncData *)asyncData
{
    // Need to check which type of async data is received as this method will be called for 
    // data streaming packets and sleep notification packets. We are going to ingnore the sleep
    // notifications.
    if ([asyncData isKindOfClass:[RKDeviceSensorsAsyncData class]]) {
        
        // Check for new data request
        packetCount++;
        if( packetCount > (TOTAL_PACKET_COUNT-PACKET_COUNT_THRESHOLD) ) {
            [self requestDataStreaming];
        }
        
        // Received sensor data, so display it to the user.  This is where
        // the developer can use the data however they please to control
        // the app
        RKDeviceSensorsAsyncData *sensorsAsyncData = (RKDeviceSensorsAsyncData *)asyncData;
        RKDeviceSensorsData *sensorsData = [sensorsAsyncData.dataFrames lastObject];
        RKAttitudeData *attitudeData = sensorsData.attitudeData;
        
        // Control mouse events
        if( isControllingMouse ) {
            
            [self moveMouseWithRoll:attitudeData.roll
                              pitch:attitudeData.pitch
                                yaw:attitudeData.yaw];
        }
    }
}

-(void) moveMouseWithRoll:(float)roll pitch:(float)pitch yaw:(float)yaw {
    
    BOOL mousePositionChanged = NO;
    
    // Move horizontally
    if( ABS(roll) > 20 ) {
        // Quadratic equation to control speed of mouse movement
        int addition = (0.005*roll*roll);
        if( roll < 0 ) addition = -addition;
        int newMouseX = mousePositionX + addition;
        // Keep mouse position within the bounds of the screen
        if( newMouseX < 0 ) newMouseX = 0;
        if( newMouseX > screenWidth ) newMouseX = screenWidth;
        mousePositionX = newMouseX;
        mousePositionChanged = YES;
    }
    
    // Move horizontally
    if( ABS(pitch) > 20 ) {
        // Quadratic equation to control speed of mouse movement
        int addition = (0.005*pitch*pitch);
        if( pitch < 0 ) addition = -addition;
        int newMouseY = mousePositionY + addition;
        // Keep mouse position within the bounds of the screen
        if( newMouseY < 0 ) newMouseY = 0;
        if( newMouseY > screenHeight ) newMouseY = screenHeight;
        mousePositionY = newMouseY;
        mousePositionChanged = YES;
    }
    
    // Only call this function if the mouse position hase changed
    if( mousePositionChanged ) {
        if( !isMouseLeftDown ) {
            // Create move the mouse to a different position event
            CGEventRef move1 = CGEventCreateMouseEvent(
                                                       NULL, kCGEventMouseMoved,
                                                       CGPointMake(mousePositionX, mousePositionY),
                                                       kCGMouseButtonLeft // ignored
                                                       );
            // Post event
            CGEventPost(kCGHIDEventTap, move1);
            CFRelease(move1);
        }
        else {
            // Create move the mouse to a different position event
            CGEventRef click1_down = CGEventCreateMouseEvent(
                                                             NULL, kCGEventLeftMouseDragged,
                                                             CGPointMake(mousePositionX, mousePositionY),
                                                             kCGMouseButtonLeft
                                                             );
            // Post the event
            CGEventPost(kCGHIDEventTap, click1_down);
            CFRelease(click1_down);
            isMouseLeftDown = YES;
        }
    }
    
    // Left Mouse Click
    if( !isMouseRightDown ) {
        // Sphero is level, and rotated clockwise
        if( yaw > 45 && ABS(roll) < 20 && ABS(pitch) < 20  ) {
            if( !isMouseLeftDown ) {
                // Create a mouse event that the their should be a left click down event
                CGEventRef click1_down = CGEventCreateMouseEvent(
                                                                 NULL, kCGEventLeftMouseDown,
                                                                 CGPointMake(mousePositionX, mousePositionY),
                                                                 kCGMouseButtonLeft
                                                                 );
                // Post the mouse event
                CGEventPost(kCGHIDEventTap, click1_down);
                CFRelease(click1_down);
                isMouseLeftDown = YES;
            }
        }
        else if( ABS(roll) < 20 && ABS(pitch) < 20 ) {
            if( isMouseLeftDown ) {
                // Create a mouse event that the their should be a left click up event
                CGEventRef click_up = CGEventCreateMouseEvent(
                                                              NULL, kCGEventLeftMouseUp,
                                                              CGPointMake(mousePositionX, mousePositionY),
                                                              kCGMouseButtonLeft
                                                              );
                CGEventPost(kCGHIDEventTap, click_up);
                CFRelease(click_up);
            }
            
            isMouseLeftDown = NO;
        }
    }
    
    // The mouse is pressed down
    if( !isMouseLeftDown ) {
        // Sphero is level, and rotated counter-clockwise
        if( yaw < -45 && ABS(roll) < 20 && ABS(pitch) < 20  ) {
            // Don't do anything if mouse is down
            if( !isMouseRightDown  ) {
                // Create a mouse event that the their should be a right click down event
                CGEventRef click1_down = CGEventCreateMouseEvent(
                                                                 NULL, kCGEventRightMouseDown,
                                                                 CGPointMake(mousePositionX, mousePositionY),
                                                                 kCGMouseButtonRight
                                                                 );
                // Post the event
                CGEventPost(kCGHIDEventTap, click1_down);
                CFRelease(click1_down);
                isMouseRightDown = YES;
            }
        }
        else if( ABS(roll) < 20 && ABS(pitch) < 20 ) {
            
            // The mouse was previously down and is now going up
            if( isMouseRightDown ) {
                // Create a mouse event that the their should be a right click up event
                CGEventRef click_up = CGEventCreateMouseEvent(
                                                              NULL, kCGEventRightMouseUp,
                                                              CGPointMake(mousePositionX, mousePositionY),
                                                              kCGMouseButtonRight
                                                              );
                // Post the event
                CGEventPost(kCGHIDEventTap, click_up);
                CFRelease(click_up);
            }
            
            isMouseRightDown = NO;
        }
    }
}

-(IBAction)toggleMouseControllerPressed:(id)sender {
    if( !isControllingMouse ) {
        [RKCalibrateCommand sendCommandWithHeading:0.0f];
        // Start mouse position in the middle of the screen
        mousePositionX = (screenWidth/2);
        mousePositionY = (screenHeight/2);
        isControllingMouse = YES;
        toggleControllerButton.title = @"Turn Mouse Controller Off";
    }
    else {
        isControllingMouse = NO;
        toggleControllerButton.title = @"Turn Mouse Controller On";
    }
}


@end
