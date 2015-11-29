//
//  HIDElement+ElementProperties.h
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/8/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import "HIDElement.h"

@interface HIDElement (ElementProperties)

/// The name for the element.
@property (readonly) NSString *name;
/// The cookie for the element.
@property (readonly) IOHIDElementCookie cookie;
/// The usage for the element.
@property (readonly) NSUInteger usage;
/// The usage page for the element.
@property (readonly) NSUInteger usagePage;


/// The maximum value possible for the element.
@property (readonly) NSInteger logicalMax;
/// The minimum value possible for the element.
@property (readonly) NSInteger logicalMin;
/// The scaled maximum value possible for the element.
@property (readonly) NSInteger physicalMax;
/// The scaled minimum value possible for the element.
@property (readonly) NSInteger physicalMin;
/// The unit for the element.
@property (readonly) NSUInteger unit;
/// The unit exponent in base 10 for the element.
@property (readonly) NSUInteger unitExponent;


/// The report count for the element.
@property (readonly) NSUInteger reportCount;
/// The report ID for the element. Represents what report this particular
/// element belongs to.
@property (readonly) NSUInteger reportID;
/// The report size in bits for the element.
@property (readonly) NSUInteger reportSize;


/// Indicates whether the element has a state in which it is not sending
/// meaningful data.
@property (readonly) BOOL hasNullState;
/// Indicates whether the element has a preferred state to which it will return
/// when the user is not physically interacting with the control.
@property (readonly) BOOL hasPreferredState;
/// Indicates whether the element represents variable or array data values.
@property (readonly) BOOL isArray;
/// Indicates whether the value of the element has been processed in some way
/// and no longer represents a linear relationship between what is measured and
/// the value that is reported.
@property (readonly) BOOL isNonLinear;
/// Indicates whether the data is relative (indicating the change in value from
/// the last report) or absolute (based on a fixed origin).
@property (readonly) BOOL isRelative;
/// Indicates whether the element is a virtual element.
@property (readonly) BOOL isVirtual;
/// Indicates whether the data "rolls over" when reaching either the extreme
/// high or low value.
@property (readonly) BOOL isWrapping;


@end
