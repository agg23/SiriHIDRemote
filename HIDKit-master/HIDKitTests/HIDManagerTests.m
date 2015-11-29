//
//  HIDManagerTests.m
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/12/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

#import "HIDManager.h"
#import "HIDDevice.h"
#import "HIDDevice+Private.h"

@interface HIDManagerTests : XCTestCase

@end


@implementation HIDManagerTests

- (void)setUp {
	[super setUp];
	// Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
	// Put teardown code here. This method is called after the invocation of each test method in the class.
	[super tearDown];
}

- (void)testRetainCounts
{
	// Ensure that all devices given out have a retain count of exactly 2 (from
	// the IOHIDManagerRef + HIDDevice they're returned in.)
	
	const CFIndex expectedRetainCount = 2;
	
	for (HIDDevice *device in [HIDManager devices])
	{
		IOHIDDeviceRef deviceRef = device.device;
		CFIndex retainCount = CFGetRetainCount(deviceRef);
		XCTAssertEqual(retainCount, expectedRetainCount, @"The device %p had a mismatching retain count.", deviceRef);
	}
}

@end
