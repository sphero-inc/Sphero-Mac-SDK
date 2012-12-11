//
//  AppDelegate.h
//  AcheivementSample
//  This Application sets up a connection to Sphero and records events to SpheroVerse
//
//  Created by Michael DePhillips on 6/21/12.
//  Copyright (c) 2012 Orbotix Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    BOOL robotOnline;
}

@property (assign) IBOutlet NSWindow *window;

-(IBAction)redPressed:(id)sender;
-(IBAction)greenPressed:(id)sender;
-(IBAction)bluePressed:(id)sender;
-(void)setupRobotConnection;
-(void)handleRobotOnline;

@end
