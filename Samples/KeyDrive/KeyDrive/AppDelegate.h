//
//  AppDelegate.h
//  HelloWorld
//  This Application sets up a connection to Sphero and blinks the LED green
//
//  Created by Michael DePhillips on 6/21/12.
//  Copyright (c) 2012 Orbotix Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MyWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    BOOL robotOnline;
    MyWindowController *myWindowController;
}

@property (assign) IBOutlet NSWindow *window;

-(void)setupRobotConnection;
-(void)handleRobotOnline;

@end
