//
//  HIDElement+ElementProperties.m
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/8/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HIDElement+ElementProperties.h"
#import "HIDElement+Private.h"

@implementation HIDElement (ElementProperties)

@dynamic name;
- (NSString *)name
{
	CFStringRef value = IOHIDElementGetName(self.element);
	
	NSString *ret = nil;
	if (value)
	{
		ret = [NSString stringWithString:(__bridge NSString *)value];
	}
	
	return ret;
}

@dynamic cookie;
- (IOHIDElementCookie)cookie
{
	return IOHIDElementGetCookie(self.element);
}

@dynamic usage;
- (NSUInteger)usage
{
	return (NSUInteger)IOHIDElementGetUsage(self.element);
}

@dynamic usagePage;
- (NSUInteger)usagePage
{
	return (NSUInteger)IOHIDElementGetUsagePage(self.element);
}

@dynamic logicalMax;
- (NSInteger)logicalMax
{
	return (NSInteger)IOHIDElementGetLogicalMax(self.element);
}

@dynamic logicalMin;
- (NSInteger)logicalMin
{
	return (NSInteger)IOHIDElementGetLogicalMin(self.element);
}

@dynamic physicalMax;
- (NSInteger)physicalMax
{
	return (NSInteger)IOHIDElementGetPhysicalMax(self.element);
}

@dynamic physicalMin;
- (NSInteger)physicalMin
{
	return (NSInteger)IOHIDElementGetPhysicalMin(self.element);
}

@dynamic unit;
- (NSUInteger)unit
{
	return (NSUInteger)IOHIDElementGetUnit(self.element);
}

@dynamic unitExponent;
- (NSUInteger)unitExponent
{
	return (NSUInteger)IOHIDElementGetUnitExponent(self.element);
}

@dynamic reportCount;
- (NSUInteger)reportCount
{
	return (NSUInteger)IOHIDElementGetReportCount(self.element);
}

@dynamic reportID;
- (NSUInteger)reportID
{
	return (NSUInteger)IOHIDElementGetReportID(self.element);
}

@dynamic reportSize;
- (NSUInteger)reportSize
{
	return (NSUInteger)IOHIDElementGetReportSize(self.element);
}

@dynamic hasNullState;
- (BOOL)hasNullState
{
	return (BOOL)IOHIDElementHasNullState(self.element);
}

@dynamic hasPreferredState;
- (BOOL)hasPreferredState
{
	return (BOOL)IOHIDElementHasPreferredState(self.element);
}

@dynamic isArray;
- (BOOL)isArray
{
	return (BOOL)IOHIDElementIsArray(self.element);
}

@dynamic isNonLinear;
- (BOOL)isNonLinear
{
	return (BOOL)IOHIDElementIsNonLinear(self.element);
}

@dynamic isRelative;
- (BOOL)isRelative
{
	return (BOOL)IOHIDElementIsRelative(self.element);
}

@dynamic isVirtual;
- (BOOL)isVirtual
{
	return (BOOL)IOHIDElementIsVirtual(self.element);
}

@dynamic isWrapping;
- (BOOL)isWrapping
{
	return (BOOL)IOHIDElementIsWrapping(self.element);
}

@end
