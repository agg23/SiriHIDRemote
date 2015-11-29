//
//  HIDElement.h
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/8/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import <Foundation/Foundation.h>
@import IOKit.hid;

@class HIDDevice, HIDValue;

@interface HIDElement : NSObject

/**
	Designated initialzer for HIDElement. HIDElement throw an exception if passed
	a NULL element or initialized with init. Initialization will fail if passed
	a CFTypeRef that is not an IOHIDElementRef.
 
	@param element A valid IOHIDElementRef.
	@param device The HIDDevice representing the device this element belong to.
	@param parentElement The parent element of this element.
 
	@returns An initialized HIDElement object, or nil if it could not be created.
 */
- (instancetype)initWithElementRef:(IOHIDElementRef)element onDevice:(HIDDevice *)device parent:(HIDElement *)parentElement NS_DESIGNATED_INITIALIZER;

/// The device to which this element belongs to.
@property (readonly, weak) HIDDevice *device;
/// The parent element of this element.
@property (readonly, weak) HIDElement *parent;
/// The children elements of this element. If none, this returns an empty array.
@property (readonly) NSArray *children;

/// The element type of this element.
@property (readonly) IOHIDElementType type;
/// The collection type of this element, if applicable.
@property (readonly) IOHIDElementCollectionType collectionType;

/// The current value of the element.
@property (readonly) HIDValue *value;

- (void)readValue;

@end
