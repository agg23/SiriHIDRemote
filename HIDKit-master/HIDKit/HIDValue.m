//
//  HIDValue.m
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/8/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HIDValue.h"
#import "HIDValue+Private.h"
#import "HIDElement+Private.h"
@import IOKit.hid;


@implementation HIDValue

//------------------------------------------------------------------------------
#pragma mark Creation and Destruction
//------------------------------------------------------------------------------
- (instancetype)init
{
	return [self initWithInteger:0 element:nil];
}

- (instancetype)initWithData:(NSData *)data element:(HIDElement *)element
{
	return [self initWithBytes:data.bytes length:data.length element:element];
}

- (instancetype)initWithBytes:(const uint8_t *)bytes length:(NSUInteger)length element:(HIDElement *)element
{
	return [self initWithBytes:bytes length:length copy:YES element:element];
}

- (instancetype)initWithBytesNoCopy:(const uint8_t *)bytes length:(NSUInteger)length element:(HIDElement *)element
{
	return [self initWithBytes:bytes length:length copy:NO element:element];
}

- (instancetype)initWithBytes:(const uint8_t *)bytes length:(NSUInteger)length copy:(BOOL)copyFlag element:(HIDElement *)element
{
	self = [super init];
	if (self)
	{
		NSParameterAssert(bytes);
		NSParameterAssert(length);
		NSParameterAssert(element);
		
		_element = element;
		uint64_t timestamp = mach_absolute_time();
		
		if (copyFlag)
		{
			_value = IOHIDValueCreateWithBytes(NULL, element.element, timestamp, bytes, (CFIndex)length);
		}
		else
		{
			_value = IOHIDValueCreateWithBytesNoCopy(NULL, element.element, timestamp, bytes, (CFIndex)length);
		}
		
		if (!_value || CFGetTypeID(_value) != IOHIDValueGetTypeID())
		{
			return nil;
		}
	}
	return self;
}

- (instancetype)initWithInteger:(NSInteger)value element:(HIDElement *)element
{
	self = [super init];
	if (self)
	{
		NSParameterAssert(element);
		
		_element = element;
		uint64_t timestamp = mach_absolute_time();
		
		_value = IOHIDValueCreateWithIntegerValue(NULL, element.element, timestamp, (CFIndex)value);
	}
	return self;
}

- (instancetype)initWithValue:(IOHIDValueRef)value element:(HIDElement *)element
{
	self = [super init];
	if (self)
	{
		NSParameterAssert(value);
		NSParameterAssert(element);
		
		if (CFGetTypeID(value) != IOHIDValueGetTypeID() )
		{
			return nil;
		}
		
		_value = value;
		_element = element;
		
		CFRetain(_value);
	}
	return self;
}

- (void)dealloc
{
	if (_value)
	{
		CFRelease(_value);
		_value = NULL;
	}
}


//------------------------------------------------------------------------------
#pragma mark Properties
//------------------------------------------------------------------------------
@dynamic byteValue;
- (NSData *)byteValue
{
	const uint8_t * bytePtr = IOHIDValueGetBytePtr(_value);
	
	// Apparently this is a null-terminated array. What's weird is even if it's
	// empty, we still get something 2 bytes long.
	if (bytePtr)
	{
		NSUInteger length = IOHIDValueGetLength(_value);
		return [NSData dataWithBytes:bytePtr length:length];
	}
	
	return nil;
}

@dynamic integerValue;
- (NSInteger)integerValue
{
	return (NSInteger)IOHIDValueGetIntegerValue(_value);
}

@dynamic timeStamp;
- (uint64_t)timeStamp
{
	return IOHIDValueGetTimeStamp(_value);
}

@dynamic scaledPhysicalValue;
- (CGFloat)scaledPhysicalValue
{
	return (CGFloat)IOHIDValueGetScaledValue(_value, kIOHIDValueScaleTypePhysical);
}

@dynamic scaledCalibratedValue;
- (CGFloat)scaledCalibratedValue
{
	return (CGFloat)IOHIDValueGetScaledValue(_value, kIOHIDValueScaleTypeCalibrated);
}

@end
