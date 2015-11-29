//
//  ViewController.m
//  SiriHIDRemote
//
//  Created by Adam Gastineau on 10/15/15.
//  Copyright © 2015 AppCannon Software. All rights reserved.
//

#import "ViewController.h"

#import <HIDKit/HIDKit.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(elementValueUpdateNotification:) name:HIDManagerElementValueDidUpdateNotification object:nil];

    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)elementValueUpdateNotification:(NSNotification *)notification
{
    HIDElement *element = [notification object];
    HIDValue *value = [element value];
    BOOL state = [value integerValue] == 0;
    
    switch ([element cookie]) {
        case 0x02:
            // AirPlay button
            [self.airplayButton setState:state];
            break;
            
        case 0x03:
            // Volume up button
            [self.volumeupButton setState:state];
            break;
            
        case 0x04:
            // Volume down button
            [self.volumedownButton setState:state];
            break;
            
        case 0x05:
            // Play/Pause button
            [self.playpauseButton setState:state];
            break;
            
        case 0x06:
            // Microphone button
            [self.micButton setState:state];
            break;
            
        case 0x07:
            // Menu button
            [self.menuButton setState:state];
            break;
            
        case 0x09:
            // Touchpad button
            // Touchpad state is reversed from the rest for some reason
            [self.touchpadButton setState:!state];
            break;
            
        default:
            break;
    }
}

@end
