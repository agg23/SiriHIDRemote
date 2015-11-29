//
//  HIDDevice.h
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/6/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import <Foundation/Foundation.h>
@import IOKit.hid;

/**
	HIDDevice wraps a single IOHIDDeviceRef and provides high level functions for
	interacting with the device and its properties.
 */
@interface HIDDevice : NSObject

/**
	Designated initialzer for HIDDevice. HIDDevice throw an exception if passed
	a NULL deviceRef or initialized with init. Initialization will fail if passed
	a CFTypeRef that is not an IOHIDDeviceRef.
 
	@param deviceRef A valid IOHIDDeviceRef provided by the HIDManager.
 
	@returns An initialized HIDDevice object.
 */
- (instancetype)initWithDeviceRef:(IOHIDDeviceRef)deviceRef NS_DESIGNATED_INITIALIZER;

/// Returns whether the device is currently open.
@property (readonly) BOOL isOpen;
- (void)open;
- (void)close;

/// Allows access to the device's io_service_t service.
@property (readonly) io_service_t service;

/// Returns the root elements on the device.
@property (readonly) NSArray *elements;

/**
	Returns an array of elements matching the criteria specified in a NSDictionary.
 
	@param criteria A NSDictionary containing element matching criteria.
 
	@returns A NSArray of all matching elements. If no matching elements are found,
			 then this will return an empty array.
 */
- (NSArray *)elementsMatchingDictionary:(NSDictionary *)criteria;

@end
