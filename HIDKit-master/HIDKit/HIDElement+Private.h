//
//  HIDElement+Private.h
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/8/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HIDElement.h"

@class HIDValue;

@interface HIDElement ()

@property (readwrite) NSInteger integerValue;
@property (readwrite) NSArray *children;
@property (readonly) IOHIDElementRef element;
@property (readwrite) HIDValue *value;

- (NSString *)getStringProperty:(CFStringRef)key;
- (BOOL)getUInt32Property:(uint32_t *)outValue forKey:(CFStringRef)key;
- (void)setUInt32Property:(CFStringRef)key value:(uint32_t)value;

- (void)didUpdateValue:(HIDValue *)value;

@end
