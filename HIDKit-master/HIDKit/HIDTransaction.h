//
//  HIDTransaction.h
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/10/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import <Foundation/Foundation.h>
@import IOKit.hid;


typedef void (^HIDTransactionCompletionHandler)();

@class HIDDevice;
@class HIDElement;
@class HIDValue;

@interface HIDTransaction : NSObject

- (instancetype)initWithDevice:(HIDDevice *)device;
- (instancetype)initWithDevice:(HIDDevice *)device direction:(IOHIDTransactionDirectionType)direction;

@property (readonly) HIDDevice *device;
@property IOHIDTransactionDirectionType direction;
@property HIDValue *value;

- (void)addElement:(HIDElement *)element;
- (void)removeElement:(HIDElement *)element;
- (BOOL)containsElement:(HIDElement *)element;

- (void)clear;
- (void)commit;
- (void)commitWithTimeout:(CFTimeInterval)timeout completionHandler:(HIDTransactionCompletionHandler)handler;

@end
