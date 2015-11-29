//
//  HIDManager.h
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/6/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/// The notification that lets observers know a device has been connected.
extern NSString * const HIDManagerDeviceDidConnectNotification;
/// The notification that lets observers know a device has been disconnected.
extern NSString * const HIDManagerDeviceDidDisconnectNotification;

extern NSString * const HIDManagerElementValueDidUpdateNotification;


/**
	HIDManager is an Objective-C wrapper around OS X's IOHIDManager.
 */
@interface HIDManager : NSObject

/**
	Returns the shared HIDManager instance.
	
	@returns The singleton HIDManager instance.
 */
+ (instancetype)sharedManager;

/**
	Returns all HID devices found by the system.
 
	@returns An NSArray containing the devices found, if any.
 */
+ (NSArray *)devices;

/**
	Returns all HID devices matching the specified criteria, if any. Please refer
	to the criteria in I/O Kit's HID Manager headers.
 
	@param criteria An NSDictionary containing device matching criteria.
	
	@returns An NSArray containing the devices found, if any.
 */
+ (NSArray *)devicesMatchingDictionary:(NSDictionary *)criteria;

@end
