//
//  ViewController.h
//  SiriHIDRemote
//
//  Created by Adam Gastineau on 10/15/15.
//  Copyright © 2015 AppCannon Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CircleButtonView.h"
#import "TouchpadView.h"

@interface ViewController : NSViewController

@property (weak) IBOutlet CircleButtonView *menuButton;
@property (weak) IBOutlet CircleButtonView *airplayButton;
@property (weak) IBOutlet CircleButtonView *micButton;
@property (weak) IBOutlet CircleButtonView *playpauseButton;
@property (weak) IBOutlet CircleButtonView *volumeupButton;
@property (weak) IBOutlet CircleButtonView *volumedownButton;
@property (weak) IBOutlet TouchpadView *touchpadButton;

@end

