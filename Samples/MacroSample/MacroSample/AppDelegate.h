//
//  AppDelegate.h
//  MacroSample
//  This Application sets up a connection to Sphero and runs macros with button presses
//
//  Created by Michael DePhillips on 6/21/12.
//  Copyright (c) 2012 Orbotix Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    BOOL robotOnline;
    IBOutlet NSSlider *speedSlider;
    IBOutlet NSSlider *loopSlider;
    IBOutlet NSSlider *delaySlider;
}

@property (assign) IBOutlet NSWindow *window;

-(void)setupRobotConnection;
-(void)handleRobotOnline;
-(IBAction)squarePressed:(id)sender;
-(IBAction)fadePressed:(id)sender;
-(IBAction)shapesPressed:(id)sender;
-(IBAction)figure8Pressed:(id)sender;
-(IBAction)vibratePressed:(id)sender;
-(IBAction)spinPressed:(id)sender;
-(IBAction)flipPressed:(id)sender;
-(IBAction)stopPressed:(id)sender;

@end
