//
//  HIDDeviceTests.m
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/12/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
@import IOKit.hid;

#import "HIDDevice.h"
#import "HIDDevice+DeviceProperties.h"
#import "HIDDevice+Private.h"


@interface HIDDeviceTests : XCTestCase

@property IOHIDManagerRef manager;

@property IOHIDDeviceRef testDevice;
@property NSUInteger testDeviceRetainCount;

@end

@implementation HIDDeviceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
	
	// Create the manager object.
	_manager = IOHIDManagerCreate(kCFAllocatorDefault, kIOHIDOptionsTypeNone);
	if (CFGetTypeID(_manager) != IOHIDManagerGetTypeID())
	{
		CFRelease(_manager);
	}
	XCTAssert(_manager, @"Could not create an IOHIDManager");
	
	IOHIDManagerSetDeviceMatching(_manager, NULL);
	IOReturn success = IOHIDManagerOpen(_manager, kIOHIDOptionsTypeNone);
	
	XCTAssertEqual(success, kIOReturnSuccess, @"Could not open HID Manager");
	
	// Get a test device.
	CFSetRef rawDevices = IOHIDManagerCopyDevices(_manager);
	CFIndex numDevices = CFSetGetCount(rawDevices);
	IOHIDDeviceRef *deviceArray = calloc(numDevices, sizeof(IOHIDDeviceRef));
	CFSetGetValues(rawDevices, (const void **)deviceArray);
	
	_testDevice = deviceArray[0];	// Take the first device.
	
	CFRelease(rawDevices);
	free(deviceArray);
	deviceArray = NULL;
	
	XCTAssert(_testDevice, @"No test device was retrieved.");

	// Note the retain count.
	CFRetain(_testDevice);
	_testDeviceRetainCount = CFGetRetainCount(_testDevice);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
	
	// Release test device and manager.
	CFRelease(_testDevice);
	_testDevice = NULL;
	
	IOHIDManagerClose(_manager, kIOHIDOptionsTypeNone);
	CFRelease(_manager);
	_manager = NULL;
}

- (void)testRetainCount
{
	NSLog(@"This test assumes at least one HID device is attached to the system. If there isn't, the test will fail.");
	
	HIDDevice *device = [[HIDDevice alloc] initWithDeviceRef:_testDevice];
	XCTAssert(device.device, @"HIDDevice did not store the device ref.");
	XCTAssertEqual(_testDeviceRetainCount + 1, CFGetRetainCount(_testDevice), @"HIDDevice did not retain device ref on init.");
	
	device = nil;
	XCTAssertEqual(_testDeviceRetainCount, CFGetRetainCount(_testDevice), @"HIDDevice did not release device ref on dealloc.");
}

- (void)testInitWithNullDevice
{
	XCTAssertThrows([[HIDDevice alloc] initWithDeviceRef:NULL], @"HIDDevice did not throw an exception when passed a NULL device ref.");
	XCTAssertThrows([[HIDDevice alloc] init], @"HIDDevice did not throw an exception when initialized with -init.");
}

#if 0
- (void)testExample {
	// This is an example of a functional test case.
	XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}
#endif

@end
