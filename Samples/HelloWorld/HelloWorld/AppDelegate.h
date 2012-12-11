//
//  AppDelegate.h
//  HelloWorld
//  This Application sets up a connection to Sphero and blinks the LED green
//
//  Created by Michael DePhillips on 6/21/12.
//  Copyright (c) 2012 Orbotix Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    BOOL robotOnline;
    IBOutlet NSButton *connectButton;
    IBOutlet NSButton *disconnectButton;
}

@property (assign) IBOutlet NSWindow *window;

-(void)setupRobotConnection;
-(void)handleRobotOnline;
-(void)blinkSpheroOn;
-(void)blinkSpheroOff;
-(IBAction)connectPressed:(id)sender;
-(IBAction)disconnectPressed:(id)sender;

@end
