//
//  MyWindowController.h
//  KeyDrive
//
//  Created by Michael DePhillips on 10/18/12.
//  Copyright (c) 2012 Orbotix Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MyWindowController : NSWindowController {
    BOOL isCalibrating;
    unsigned int keyMask;
    BOOL calibrateDirection;
    BOOL noArrowsPressed;
}

@end
