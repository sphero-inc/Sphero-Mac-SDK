//
//  AppDelegate.h
//  SensorStreaming
//
//  Created by Michael DePhillips on 6/21/12.
//  Copyright (c) 2012 Orbotix Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    BOOL robotOnline;
    int  packetCount;
}

@property (assign) IBOutlet NSTextField *accelXField;
@property (assign) IBOutlet NSTextField *accelYField;
@property (assign) IBOutlet NSTextField *accelZField;


@property (assign) IBOutlet NSTextField *gyroRollField;
@property (assign) IBOutlet NSTextField *gyroPitchField;
@property (assign) IBOutlet NSTextField *gyroYawField;


@property (assign) IBOutlet NSWindow *window;

-(void)setupRobotConnection;
-(void)handleRobotOnline;

@end
