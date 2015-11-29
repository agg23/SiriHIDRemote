//
//  HIDValue+Private.h
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/10/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HIDValue.h"

@class HIDElement;

@interface HIDValue ()

@property (readonly) IOHIDValueRef value;

- (instancetype)initWithValue:(IOHIDValueRef)value element:(HIDElement *)element;

@end
