//
//  MyWindowController.h
//  KeyDrive
//
//  Created by Michael DePhillips on 10/18/12.
//  Copyright (c) 2012 Orbotix Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <RobotKit/RobotKit.h>

@interface MyWindowController : NSWindowController {
    BOOL isCalibrating;
    unsigned int keyMask;
    BOOL calibrateDirection;
    BOOL noArrowsPressed;
    
    IBOutlet NSTextField *messageView;

    RKOrbBasicProgram* orbBasicProgram;
}

-(IBAction)loadPressed:(id)sender;
-(IBAction)abortPressed:(id)sender;
-(IBAction)executePressed:(id)sender;
-(IBAction)erasePressed:(id)sender;
-(IBAction)openPressed:(id)sender;
-(void)robotWentOnline;

@end
