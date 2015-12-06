//
//  HIDManager.m
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/6/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HIDManager.h"
#import "HIDDevice.h"
#import "HIDDevice+Private.h"
@import IOKit.hid;



//------------------------------------------------------------------------------
#pragma mark Notification Keys
//------------------------------------------------------------------------------
NSString * const HIDManagerDeviceDidConnectNotification = @"HIDManagerDeviceDidConnectNotification";
NSString * const HIDManagerDeviceDidDisconnectNotification = @"HIDManagerDeviceDidDisconnectNotification";

NSString * const HIDManagerElementValueDidUpdateNotification = @"HIDManagerElementValueDidUpdateNotification";

//------------------------------------------------------------------------------
#pragma mark Private Class Extension
//------------------------------------------------------------------------------
@interface HIDManager ()

@property IOHIDManagerRef manager;
@property (readonly) NSMutableArray *devices;

@end



//------------------------------------------------------------------------------
#pragma mark Device Callback Functions
//------------------------------------------------------------------------------
static void HIDManagerDeviceMatchCallback(void * context, IOReturn result, void * sender, IOHIDDeviceRef device)
{
	NSLog(@"Device connected: %p", device);
	
	HIDManager *manager = (__bridge HIDManager *)context;
	HIDDevice *newDevice = [[HIDDevice alloc] initWithDeviceRef:device];
	[manager.devices addObject:newDevice];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:HIDManagerDeviceDidConnectNotification object:newDevice];
}

static void HIDManagerDeviceRemovedCallback(void * context, IOReturn result, void * sender, IOHIDDeviceRef device)
{
	NSLog(@"Device disconnected: %p", device);
	
	HIDManager *manager = (__bridge HIDManager *)context;
	HIDDevice *disconnectedDevice;
    	
    for (int i = 0; i < [manager.devices count]; i++)
	{
        HIDDevice *aDevice = [manager.devices objectAtIndex:i];
        
        if (aDevice != nil && aDevice.device == device)
		{
			disconnectedDevice = aDevice;
            // FIXME: We really should have a way as marking a device as removed.
            // We can't just deallocate it here since others may be referencing it.
            // Plus, we can then pass it along in our notification later.
            [manager.devices removeObjectAtIndex:i];
		}
	}

	[[NSNotificationCenter defaultCenter] postNotificationName:HIDManagerDeviceDidDisconnectNotification object:disconnectedDevice];
}




//------------------------------------------------------------------------------
#pragma mark Implementation
//------------------------------------------------------------------------------
@implementation HIDManager

//------------------------------------------------------------------------------
#pragma mark Retrieving the Shared Manager
//------------------------------------------------------------------------------
+ (instancetype)sharedManager
{
	static HIDManager *sharedInstance;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		sharedInstance = [[[self class] alloc] init];
	});
	
	return sharedInstance;

}


//------------------------------------------------------------------------------
#pragma mark Creation and Destruction
//------------------------------------------------------------------------------
- (instancetype)init
{
	self = [super init];
	if (self)
	{
		_devices = [NSMutableArray array];
		
		_manager = IOHIDManagerCreate(kCFAllocatorDefault, kIOHIDOptionsTypeNone);
		if (!_manager || CFGetTypeID(_manager) != IOHIDManagerGetTypeID() )
		{
			return nil;
		}
		
		IOHIDManagerSetDeviceMatching(_manager, NULL);
		IOHIDManagerRegisterDeviceMatchingCallback(_manager, &HIDManagerDeviceMatchCallback, (__bridge void *)self);
		IOHIDManagerRegisterDeviceRemovalCallback(_manager, &HIDManagerDeviceRemovedCallback, (__bridge void *)self);
		IOHIDManagerScheduleWithRunLoop(_manager, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
		
		if (IOHIDManagerOpen(_manager, kIOHIDOptionsTypeNone) != kIOReturnSuccess)
		{
			return nil;
		}
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(cleanup)
													 name:NSApplicationWillTerminateNotification
												   object:nil];
		HIDLog(@"HIDManager created.");
	}
	return self;
}

- (void)cleanup
{
	if (_manager)
	{
		HIDLog(@"HIDManager cleaning up.");
		IOHIDManagerUnscheduleFromRunLoop(_manager, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
		IOHIDManagerClose(_manager, kIOHIDOptionsTypeNone);
		CFRelease(_manager);
		_manager = NULL;
	}
	
}

- (void)dealloc
{
	[self performSelectorOnMainThread:@selector(cleanup) withObject:nil waitUntilDone:YES];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


//------------------------------------------------------------------------------
#pragma mark Retrieving Devices
//------------------------------------------------------------------------------
+ (NSArray *)devices
{
	return [[HIDManager sharedManager].devices copy];
	
#if 0
	NSLog(@"HIDManager is retrieving devices.");
	CFSetRef rawDevices = IOHIDManagerCopyDevices([HIDManager sharedManager].manager);
	CFIndex deviceCount = CFSetGetCount(rawDevices);
	
	IOHIDDeviceRef *deviceArray = calloc(deviceCount, sizeof(IOHIDDeviceRef));
	CFSetGetValues(rawDevices, (const void **)deviceArray);
	
	NSMutableArray *devices = [NSMutableArray array];
	for (int i = 0; i < deviceCount; i++)
	{
		HIDDevice *device = [[HIDDevice alloc] initWithDeviceRef:deviceArray[i]];
		
		if (device)
		{
			[devices addObject:device];
		}
	}
	
	CFRelease(rawDevices);
	free(deviceArray);
	deviceArray = NULL;
	
	return [devices copy];
#endif
}

+ (NSArray *)devicesMatchingDictionary:(NSDictionary *)criteria
{
	NSMutableArray *devices = [[HIDManager sharedManager].devices mutableCopy];
	
	// TODO: Implement me!
	
	return [devices copy];
}


@end
