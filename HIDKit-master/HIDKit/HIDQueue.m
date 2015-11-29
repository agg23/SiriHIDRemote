//
//  HIDQueue.m
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/10/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HIDQueue.h"

// We sure do love poking around inside our friends!
#import "HIDDevice+Private.h"
#import "HIDElement+Private.h"
#import "HIDValue+Private.h"

@import IOKit.hid;



@interface HIDQueue ()

@property (readonly) IOHIDQueueRef queue;

@end



@implementation HIDQueue

//------------------------------------------------------------------------------
#pragma mark Creation and Destruction
//------------------------------------------------------------------------------
- (instancetype)init
{
	return [self initWithDevice:nil];
}

- (instancetype)initWithDevice:(HIDDevice *)device
{
	return [self initWithDevice:device depth:255];
}

- (instancetype)initWithDevice:(HIDDevice *)device depth:(NSUInteger)depth
{
	self = [super init];
	if (self)
	{
		NSParameterAssert(device);
		NSParameterAssert(depth);
		
		_device = device;
		_queue = IOHIDQueueCreate(NULL, device.device, depth, kIOHIDOptionsTypeNone);
		if (!_queue || CFGetTypeID(_queue) != IOHIDQueueGetTypeID() )
		{
			return nil;
		}
		
		// TODO: Register the callback and implement an async blocks-based handler API.
		
		IOHIDQueueScheduleWithRunLoop(_queue, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	}
	return self;
}

- (void)dealloc
{
	if (_queue)
	{
		// FIXME: Can we pass something that's already been unscheduled?
		IOHIDQueueUnscheduleFromRunLoop(_queue, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
		CFRelease(_queue);
		_queue = NULL;
	}
}

//------------------------------------------------------------------------------
#pragma mark Starting and Stopping Queues
//------------------------------------------------------------------------------
- (void)start
{
	IOHIDQueueStart(_queue);
}

- (void)stop
{
	IOHIDQueueStop(_queue);
}


//------------------------------------------------------------------------------
#pragma mark Dequeueing Values
//------------------------------------------------------------------------------
- (HIDValue *)nextValue
{
	IOHIDValueRef value = IOHIDQueueCopyNextValue(_queue);
	HIDValue *returnValue = nil;
	
	if (value)
	{
		returnValue = [[HIDValue alloc] initWithValue:value element:[_device elementForValueRef:value]];
		CFRelease(value);
	}
	
	return returnValue;
}

- (HIDValue *)nextValueWithTimeout:(CFTimeInterval)timeout
{
	IOHIDValueRef value = IOHIDQueueCopyNextValueWithTimeout(_queue, timeout);
	HIDValue *returnValue = nil;
	
	if (value)
	{
		returnValue = [[HIDValue alloc] initWithValue:value element:[_device elementForValueRef:value]];
		CFRelease(value);
	}
	
	return returnValue;
}

//------------------------------------------------------------------------------
#pragma mark Managing Elements
//------------------------------------------------------------------------------
// TODO: This could be better expressed with an array property of attached elements.
// We could hook into object addition/removal to do this.
- (void)addElement:(HIDElement *)element
{
	IOHIDQueueAddElement(_queue, element.element);
}

- (void)removeElement:(HIDElement *)element
{
	IOHIDQueueRemoveElement(_queue, element.element);
}

- (BOOL)containsElement:(HIDElement *)element
{
	return (BOOL)IOHIDQueueContainsElement(_queue, element.element);
}

//------------------------------------------------------------------------------
#pragma mark Queue Properties
//------------------------------------------------------------------------------
@dynamic depth;
- (void)setDepth:(NSUInteger)depth
{
	IOHIDQueueSetDepth(_queue, (CFIndex)depth);
}

- (NSUInteger)depth
{
	return (NSUInteger)IOHIDQueueGetDepth(_queue);
}

@end
