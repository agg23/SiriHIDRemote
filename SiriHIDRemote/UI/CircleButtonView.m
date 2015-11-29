//
//  CircleButtonView.m
//  SiriHIDRemote
//
//  Created by Adam Gastineau on 11/29/15.
//  Copyright © 2015 AppCannon Software. All rights reserved.
//

#import "CircleButtonView.h"

@implementation CircleButtonView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.layer = _layer;
        self.wantsLayer = YES;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.frame.size.width/2;
        
        [self.layer setBackgroundColor:CGColorCreateGenericRGB(0, 0, 0, 1)];
    }
    return self;
}

- (void)setState:(BOOL)state
{
    if(state) {
        [self.layer setBackgroundColor:CGColorCreateGenericRGB(1, 0, 0, 1)];
    } else {
        [self.layer setBackgroundColor:CGColorCreateGenericRGB(0, 0, 0, 1)];
    }
}

@end
