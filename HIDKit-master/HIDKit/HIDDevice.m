//
//  HIDDevice.m
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/6/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HIDDevice.h"
#import "HIDDevice+DeviceProperties.h"
#import "HIDDevice+Private.h"
#import "HIDElement.h"
#import "HIDElement+ElementProperties.h"
#import "HIDElement+Private.h"
#import "HIDValue.h"
#import "HIDValue+Private.h"


#define IS_INPUT_ELEMENT(x) x.type == kIOHIDElementTypeInput_Misc	|| \
							x.type == kIOHIDElementTypeInput_Button	|| \
							x.type == kIOHIDElementTypeInput_Axis	|| \
							x.type == kIOHIDElementTypeInput_ScanCodes

#define NSSTRING_FROM_COOKIE(x) [NSString stringWithFormat:@"%ud", x]


//------------------------------------------------------------------------------
#pragma mark Input Value Callback
//------------------------------------------------------------------------------
static void HIDDeviceInputValueCallback(void * context, IOReturn result, void * sender, IOHIDValueRef newValue)
{
	HIDDevice *device = (__bridge HIDDevice *)context;
	[device handleInputValue:newValue result:result];
}



//------------------------------------------------------------------------------
#pragma mark Implementation
//------------------------------------------------------------------------------
@implementation HIDDevice
{
	NSArray *_rootElements;
	NSMutableDictionary *_inputElements;
}


//------------------------------------------------------------------------------
#pragma mark Creating and Destroying Instances
//------------------------------------------------------------------------------
- (instancetype)init
{
	return [self initWithDeviceRef:NULL];
}

- (instancetype)initWithDeviceRef:(IOHIDDeviceRef)deviceRef
{
	self = [super init];
	if (self)
	{
		NSParameterAssert(deviceRef);
		if (CFGetTypeID(deviceRef) != IOHIDDeviceGetTypeID())
		{
			return nil;
		}
		
		CFRetain(deviceRef);
		_device = deviceRef;
		
		// These don't really seem to matter...
		IOHIDDeviceRegisterInputValueCallback(_device, &HIDDeviceInputValueCallback, (__bridge void *)self);
//		IOHIDDeviceScheduleWithRunLoop(_device, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
		
		IOHIDDeviceOpen(_device, kIOHIDOptionsTypeNone);
		HIDLog(@"Device created: %@", self.description);
	}
	return self;
}

- (void)dealloc
{
	if (_device)
	{
		if (_isOpen)
		{
			IOHIDDeviceRegisterInputValueCallback(_device, NULL, (__bridge void *)self);
//			IOHIDDeviceUnscheduleFromRunLoop(_device, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
			HIDLog(@"Device was released without closing: %@", self.description);
		}
		
		IOHIDDeviceClose(_device, kIOHIDOptionsTypeNone);
		CFRelease(_device);
		_device = NULL;
	}
}


//------------------------------------------------------------------------------
#pragma mark Retrieving the I/O Service
//------------------------------------------------------------------------------
@dynamic service;
- (io_service_t)service
{
	return IOHIDDeviceGetService(_device);
}


//------------------------------------------------------------------------------
#pragma mark Describing the Device
//------------------------------------------------------------------------------
- (NSString *)description
{
	return [NSString stringWithFormat:@"HIDDevice: %p \n \
	{ \n \
			\tName: %@ \n \
			\tManufacturer: %@ \n \
			\tIOHIDDeviceRef: %p \n \
	}", self, self.product, self.manufacturer, self.device];
}


//------------------------------------------------------------------------------
#pragma mark Handling Input
//------------------------------------------------------------------------------
- (void)handleInputValue:(IOHIDValueRef)valueRef result:(IOReturn)result
{
	if (result != kIOReturnSuccess)
	{
		// TODO: We really should signal an error somehow.
		HIDLog(@"HIDDeviceInputValueCallback(): result from caller was %d", result);
		return;
	}
	
	
	HIDElement *element = nil;
	if ((element = [self elementForValueRef:valueRef]))
	{
		HIDValue *value = [[HIDValue alloc] initWithValue:valueRef element:element];
		[element didUpdateValue:value];
	}
}


//------------------------------------------------------------------------------
#pragma mark Opening and Closing the Device
//------------------------------------------------------------------------------
- (void)open
{
	IOReturn success = kIOReturnSuccess;
	
	if (success == kIOReturnSuccess)
	{
		self.isOpen = YES;
	}
	else
	{
		self.isOpen = NO;
	}
}

- (void)close
{
	IOReturn success = kIOReturnSuccess;
	
	if (success == kIOReturnSuccess)
	{
		self.isOpen = NO;
	}
	else
	{
		self.isOpen = YES;
	}
}


//------------------------------------------------------------------------------
#pragma mark Interacting with Device Properties
//------------------------------------------------------------------------------
- (NSString *)getStringProperty:(CFStringRef)key
{
	CFTypeRef value = IOHIDDeviceGetProperty(_device,  key);
	
	NSString *ret = nil;
	if (value)
	{
		ret = [NSString stringWithString:(__bridge NSString *)value];
	}
	
	return ret;
}

- (BOOL)getUInt32Property:(uint32_t *)outValue forKey:(CFStringRef)key
{
	BOOL result = NO;
	
	CFTypeRef value = IOHIDDeviceGetProperty(_device, key);
	if (value && CFNumberGetTypeID() == CFGetTypeID(value) )
	{
		result = (BOOL)CFNumberGetValue( (CFNumberRef)value, kCFNumberSInt32Type, outValue);
	}
	
	return result;
}

- (void)setUInt32Property:(CFStringRef)key value:(uint32_t)value
{
	CFNumberRef numberRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &value);
	
	if (numberRef)
	{
		IOHIDDeviceSetProperty(_device, key, numberRef);
		CFRelease(numberRef);
	}
}


//------------------------------------------------------------------------------
#pragma mark Retrieving Device Elements
//------------------------------------------------------------------------------
@dynamic elements;
- (NSArray *)elements
{
	if (_rootElements)
	{
		return _rootElements;
	}
	
	CFArrayRef rawElements = IOHIDDeviceCopyMatchingElements(_device, NULL, kIOHIDOptionsTypeNone);
	CFIndex elementCount = CFArrayGetCount(rawElements);
	
	NSMutableArray *elements = [NSMutableArray array];
	for (int i = 0; i < elementCount; i++)
	{
		// We're counting on HIDElement to recursively create instances of itself
		// for all its children, so we're only focusing on the root elements.
		IOHIDElementRef elementRef = (IOHIDElementRef)CFArrayGetValueAtIndex(rawElements, i);
		if (IOHIDElementGetParent(elementRef))
		{
			continue;
		}
		
		HIDElement *element = [[HIDElement alloc] initWithElementRef:elementRef
															onDevice:self
															  parent:nil];
		
		if (element)
		{
			[elements addObject:element];
		}
	}
	
//	CFRelease(rawElements);	
	_rootElements = [elements copy];
	
	_inputElements = [NSMutableDictionary dictionary];
	[self recursivelyFindInputElements:_rootElements];
	
	return _rootElements;
}

- (void)recursivelyFindInputElements:(NSArray *)rootElementsArray
{
	for (HIDElement *element in rootElementsArray)
	{
		// Identify input elements.
		if ( IS_INPUT_ELEMENT(element) )
		{
			NSString *key = NSSTRING_FROM_COOKIE(element.cookie);
			_inputElements[key] = element;
		}
		
		// Recurse to children.
		NSArray *children = element.children;
		if (children.count > 0)
		{
			return [self recursivelyFindInputElements:children];
		}
	}
}

- (HIDElement *)elementForValueRef:(IOHIDValueRef)valueRef
{
	if (!_inputElements)
	{
		return nil;
	}
	
	IOHIDElementRef elementRef = IOHIDValueGetElement(valueRef);
	uint32_t cookie = IOHIDElementGetCookie(elementRef);
	
	NSString *key = NSSTRING_FROM_COOKIE(cookie);
	return _inputElements[key];
}

- (NSArray *)elementsMatchingDictionary:(NSDictionary *)criteria
{
	// TODO: Implement me!
	NSLog(@"Method unimplemented: %s in %s, line %d.", __PRETTY_FUNCTION__, __FILE__, __LINE__);
	return [NSArray array];
}


@end
