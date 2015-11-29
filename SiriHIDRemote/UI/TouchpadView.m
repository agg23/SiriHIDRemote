//
//  TouchpadView.m
//  SiriHIDRemote
//
//  Created by Adam Gastineau on 11/29/15.
//  Copyright © 2015 AppCannon Software. All rights reserved.
//

#import "TouchpadView.h"

@implementation TouchpadView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.layer = _layer;
        self.wantsLayer = YES;
        
        [self.layer setBackgroundColor:CGColorCreateGenericRGB(0, 0, 0, 0.6)];
    }
    return self;
}

- (void)setState:(BOOL)state
{
    if(state) {
        [self.layer setBackgroundColor:CGColorCreateGenericRGB(0, 0, 0, 0.6)];
    } else {
        [self.layer setBackgroundColor:CGColorCreateGenericRGB(1, 0, 0, 0.6)];
    }
}

@end
