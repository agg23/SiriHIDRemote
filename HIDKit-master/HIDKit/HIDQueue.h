//
//  HIDQueue.h
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/10/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HIDDevice;
@class HIDElement;
@class HIDValue;

/**
	HIDQueue defines an object used to queue values from input parsed items
	contained within an HIDDevice. This is useful when you need to keep track of
	all values of an input element, not just the most recent one.
 
	HIDQueue should be considered optional and is only useful for working with
	complex input elements. These elements include those whose length are greater
	than sizeof(CFIndex) or elements that are duplicate items.
 
	Note: Absolute element values (based on a fixed origin) will only be placed
	on a queue if there is a change in value.
 */
@interface HIDQueue : NSObject

/**
	Initializes a HIDQueue for the specified device and a default depth of 255.
 
	@param device A HIDDevice object.
 
	@returns A new HIDQueue object, or nil if it could not be created.
 */
- (instancetype)initWithDevice:(HIDDevice *)device;
/**
	Initializes a HIDQueue for the specified device with the specified depth.
 
	@discussion Take care in specifying an appropriate depth to prevent dropping events.
 
	@param device A HIDDevice object.
	@param depth The number of values that can be handled by the queue.
 
	@returns A new HIDQueue object, or nil if it could not be created.
 */
- (instancetype)initWithDevice:(HIDDevice *)device depth:(NSUInteger)depth;

/**
	Adds an element to the queue.
 
	@param element The element to be added to the queue.
 */
- (void)addElement:(HIDElement *)element;
/**
	Removes an element from the queue.
 
	@param element The element to be removed from the queue.
 */
- (void)removeElement:(HIDElement *)element;
/**
	Queries the queue to determine if element has been added.
 
	@param element The element to be queried.
 
	@returns YES if the element has been added to the queue, otherwise NO.
 */
- (BOOL)containsElement:(HIDElement *)element;


/**
	Dequeues the next element value, if any.
 
	@returns A HIDValue, or nil if no data is available.
 */
- (HIDValue *)nextValue;

/**
	Dequeues the next element value, if any. This method will block until either
	a value is available or it times out.
 
	@param timeout The amount of time to wait before aborting an attempt to
					dequeue a value from the head of the queue.
 
	@returns A HIDValue, or nil if no data is available.
 */
- (HIDValue *)nextValueWithTimeout:(CFTimeInterval)timeout;


/**
	Starts element value delivery to the queue.
 */
- (void)start;
/**
	Stops element value delivery to the queue.
 */
- (void)stop;


/// The number of values that can be handled by the queue. Take care in
/// specifying an appropriate depth to prevent dropping events.
@property NSUInteger depth;

/// The device associated with the queue.
@property HIDDevice *device;


@end
