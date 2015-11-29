//
//  HIDDevice+DeviceProperties.m
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/7/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HIDDevice+DeviceProperties.h"
#import "HIDDevice+Private.h"

// Usage Pairs Keys
const NSString * HIDDeviceUsagePairsUsageKey = (NSString *)CFSTR(kIOHIDDeviceUsageKey);
const NSString * HIDDeviceUsagePairsUsagePageKey = (NSString *)CFSTR(kIOHIDDeviceUsagePageKey);



@implementation HIDDevice (DeviceProperties)

@dynamic transport;
- (NSString *)transport
{
	return [self getStringProperty:CFSTR(kIOHIDTransportKey)];
}

@dynamic vendorID;
- (NSUInteger)vendorID
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDVendorIDKey)];
	return (result) ? result : 0;
}

@dynamic vendorIDSource;
- (NSUInteger)vendorIDSource
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDVendorIDSourceKey)];
	return (result) ? result : 0;
}

@dynamic productID;
- (NSUInteger)productID
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDProductIDKey)];
	return (result) ? result : 0;
}

@dynamic locationID;
- (NSUInteger)locationID
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDLocationIDKey)];
	return (result) ? result : 0;
}

@dynamic versionNumber;
- (NSUInteger)versionNumber
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDVersionNumberKey)];
	return (result) ? result : 0;
}

@dynamic manufacturer;
- (NSString *)manufacturer
{
	return [self getStringProperty:CFSTR(kIOHIDManufacturerKey)];
}

@dynamic product;
- (NSString *)product
{
	return [self getStringProperty:CFSTR(kIOHIDProductKey)];
}

@dynamic serialNumber;
- (NSString *)serialNumber
{
	return [self getStringProperty:CFSTR(kIOHIDSerialNumberKey)];
}

@dynamic countryCode;
- (NSUInteger)countryCode
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDCountryCodeKey)];
	return (result) ? result : 0;
}

@dynamic deviceUsage;
- (NSUInteger)deviceUsage
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDDeviceUsageKey)];
	return (result) ? result : 0;
}

@dynamic deviceUsagePage;
- (NSUInteger)deviceUsagePage
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDDeviceUsagePageKey)];
	return (result) ? result : 0;
}

@dynamic deviceUsagePairs;
- (NSArray *)deviceUsagePairs
{
	// FIXME: Refactor this, it can crash.
	CFTypeRef array = IOHIDDeviceGetProperty(self.device, CFSTR(kIOHIDDeviceUsagePairsKey) );
	NSMutableArray *pairs = [NSMutableArray array];
	
	if (array && CFGetTypeID(array) == CFArrayGetTypeID())
	{
		NSArray *devicePairs = (__bridge NSArray *)array;
		for (id pair in devicePairs)
		{
			NSDictionary *dict = [NSDictionary dictionaryWithDictionary:(NSDictionary *)pair];
			[pairs addObject:dict];
		}
	}
	
	return [pairs copy];
}

@dynamic primaryUsage;
- (NSUInteger)primaryUsage
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDPrimaryUsageKey)];
	return (result) ? result : 0;
}

@dynamic primaryUsagePage;
- (NSUInteger)primaryUsagePage
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDPrimaryUsagePageKey)];
	return (result) ? result : 0;
}

@dynamic maxInputReportSize;
- (NSUInteger)maxInputReportSize
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDMaxInputReportSizeKey)];
	return (result) ? result : 0;
}

@dynamic maxOutputReportSize;
- (NSUInteger)maxOutputReportSize
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDMaxOutputReportSizeKey)];
	return (result) ? result : 0;
}

@dynamic maxFeatureReportSize;
- (NSUInteger)maxFeatureReportSize
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDMaxFeatureReportSizeKey)];
	return (result) ? result : 0;
}

@dynamic maxResponseLatency;
- (NSUInteger)maxResponseLatency
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDMaxResponseLatencyKey)];
	return (result) ? result : 0;
}

@dynamic reportInterval;
- (NSUInteger)reportInterval
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDReportIntervalKey)];
	return (result) ? result : 0;
}

@dynamic sampleInterval;
- (NSUInteger)sampleInterval
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDSampleIntervalKey)];
	return (result) ? result : 0;
}

@dynamic requestTimeout;
- (NSUInteger)requestTimeout
{
	uint32_t result;
	[self getUInt32Property:&result forKey:CFSTR(kIOHIDRequestTimeoutKey)];
	return (result) ? result : 0;
}


@end
