//
//  HIDDevice+Private.h
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/8/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HIDDevice.h"


@class HIDElement;

// Private class extension for HIDDevice
@interface HIDDevice ()

@property IOHIDDeviceRef device;
@property (readwrite) BOOL isOpen;

- (NSString *)getStringProperty:(CFStringRef)key;
- (BOOL)getUInt32Property:(uint32_t *)outValue forKey:(CFStringRef)key;
- (void)setUInt32Property:(CFStringRef)key value:(uint32_t)value;

- (HIDElement *)elementForValueRef:(IOHIDValueRef)valueRef;
- (void)handleInputValue:(IOHIDValueRef)valueRef result:(IOReturn)result;

@end
