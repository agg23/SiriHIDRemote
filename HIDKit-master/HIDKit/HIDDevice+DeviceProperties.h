//
//  HIDDevice+DeviceProperties.h
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/7/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HIDDevice.h"

extern const NSString * HIDDeviceUsagePairsUsageKey;
extern const NSString * HIDDeviceUsagePairsUsagePageKey;


@interface HIDDevice (DeviceProperties)

/// Returns a string with the device's underlying transport.
@property (readonly) NSString *transport;

/// Returns an unsigned interger with the device's vendor ID.
@property (readonly) NSUInteger vendorID;
/// Returns an unsigned interger with the device's vendor ID source.
@property (readonly) NSUInteger vendorIDSource;
/// Returns an unsigned interger with the device's product ID.
@property (readonly) NSUInteger productID;
/// Returns an unsigned interger with the device's location ID.
@property (readonly) NSUInteger locationID;
/// Returns an unsigned interger with the device's version number.
@property (readonly) NSUInteger versionNumber;
/// Returns a string with the device's manufacturer.
@property (readonly) NSString *manufacturer;
/// Returns a string with the device's product name.
@property (readonly) NSString *product;
/// Returns a string with the device's serial number.
@property (readonly) NSString *serialNumber;
/// Returns an unsigned interger with the device's country code.
@property (readonly) NSUInteger countryCode;

/// Returns an unsigned interger with the device's usage code.
@property (readonly) NSUInteger deviceUsage;
/// Returns an unsigned interger with the device's usage page code.
@property (readonly) NSUInteger deviceUsagePage;
/// Returns an array of dictionaries containing all usage/usage page pairs
/// reported by the device.
@property (readonly) NSArray *deviceUsagePairs;
/// Returns an unsigned interger with the device's primary usage code.
@property (readonly) NSUInteger primaryUsage;
/// Returns an unsigned interger with the device's primary usage page code.
@property (readonly) NSUInteger primaryUsagePage;

/// Returns an unsigned interger with the device's maximum input report size.
@property (readonly) NSUInteger maxInputReportSize;
/// Returns an unsigned interger with the device's maximum output report size.
@property (readonly) NSUInteger maxOutputReportSize;
/// Returns an unsigned interger with the device's maximum feature report size.
@property (readonly) NSUInteger maxFeatureReportSize;
/// Returns an unsigned interger with the device's maximum response latency.
@property (readonly) NSUInteger maxResponseLatency;

//@property (readonly) NSUInteger reportDescriptor;
/// Returns an unsigned interger with the device's report interval.
@property (readonly) NSUInteger reportInterval;
/// Returns an unsigned interger with the device's sample interval.
@property (readonly) NSUInteger sampleInterval;
/// Returns an unsigned interger with the device's request timeout interval.
@property (readonly) NSUInteger requestTimeout;

// Do I even care about these?
//@property (readonly) NSString *standardType;
//@property (readonly) NSUInteger locationID;
//@property (readonly) NSString *productIDMask;
//@property (readonly) NSString *productIDArray;
//@property (readonly) NSString *category;
//@property (readonly) NSString *reset;
//@property (readonly) NSString *keyboardLanguage;
//@property (readonly) NSString *altHandlerID;
//@property (readonly) NSString *isBuiltIn;
//@property (readonly) NSString *displayIntegrated;
//@property (readonly) NSString *powerOnDelayNS;


@end
