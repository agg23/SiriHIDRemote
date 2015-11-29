//
//  HIDElement.m
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/8/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HIDElement.h"
#import "HIDElement+ElementProperties.h"
#import "HIDElement+Private.h"
#import "HIDDevice+Private.h"
#import "HIDValue.h"
#import "HIDValue+Private.h"

#import "HIDManager.h"

//extern void HIDDeviceInputValueCallback(void * context, IOReturn result, void * sender, IOHIDValueRef newValue);

@implementation HIDElement

//------------------------------------------------------------------------------
#pragma mark Creation and Destruction
//------------------------------------------------------------------------------
- (instancetype)init
{
	return [self initWithElementRef:NULL onDevice:nil parent:nil];
}

- (instancetype)initWithElementRef:(IOHIDElementRef)element onDevice:(HIDDevice *)device parent:(HIDElement *)parentElement
{
	self = [super init];
	if (self)
	{
		NSParameterAssert(element);
		if (CFGetTypeID(element) != IOHIDElementGetTypeID() )
		{
			return nil;
		}
		
		CFRetain(element);
		_element = element;
		_device = device;
		_parent = parentElement;
		
//		[self setInitialValue];
		[self populateChildren];
	}
	return self;
}

- (void)dealloc
{
	if (_element)
	{
		CFRelease(_element);
		_element = NULL;
	}
}

- (void)populateChildren
{
	CFArrayRef rawChildren = IOHIDElementGetChildren(_element);
	if (!rawChildren)
	{
		_children = [NSArray array];
		return;
	}
	
	CFIndex childCount = CFArrayGetCount(rawChildren);
	NSMutableArray *currentChildren = [NSMutableArray array];
	for (int i = 0; i < childCount; i++)
	{
		IOHIDElementRef elementRef = (IOHIDElementRef)CFArrayGetValueAtIndex(rawChildren, i);
		HIDElement *element = [[HIDElement alloc] initWithElementRef:elementRef
															onDevice:_device
															  parent:self];
		
		if (element)
		{
			[currentChildren addObject:element];
		}
	}
	
	CFRelease(rawChildren);	// Why was this commented out?
	_children = [currentChildren copy];
}

//------------------------------------------------------------------------------
#pragma mark Element Properties
//------------------------------------------------------------------------------
@dynamic type;
- (IOHIDElementType)type
{
	return IOHIDElementGetType(_element);
}

@dynamic collectionType;
- (IOHIDElementCollectionType)collectionType
{
	return IOHIDElementGetCollectionType(_element);
}


//------------------------------------------------------------------------------
#pragma mark Interacting with Element Properties
//------------------------------------------------------------------------------
- (NSString *)getStringProperty:(CFStringRef)key
{
	CFTypeRef value = IOHIDElementGetProperty(_element, key);
	
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
	
	CFTypeRef value = IOHIDElementGetProperty(_element, key);
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
		IOHIDElementSetProperty(_element, key, numberRef);
		CFRelease(numberRef);
	}
}


//------------------------------------------------------------------------------
#pragma mark Signaling Value Changes
//------------------------------------------------------------------------------
- (void)readValue
{
	IOHIDValueRef value = NULL;
//	IOReturn success = IOHIDDeviceGetValueWithCallback(_device.device, _element, &value, mach_absolute_time(), &HIDDeviceInputValueCallback, NULL);
	IOReturn success = IOHIDDeviceGetValue(_device.device, _element, &value);
	HIDValue *newValue = [[HIDValue alloc] initWithValue:value element:self];
	[self didUpdateValue:newValue];
}

- (void)didUpdateValue:(HIDValue *)value
{
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDManagerElementValueDidUpdateNotification object:self];
    self.value = value;
}

@end
