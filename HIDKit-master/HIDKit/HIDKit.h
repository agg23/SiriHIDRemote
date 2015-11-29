//
//  HIDKit.h
//  HIDKit
//
//  Created by Robert Luis Hoover on 9/6/14.
//  Copyright (c) 2014 ars draconis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//! Project version number for HIDKit.
FOUNDATION_EXPORT double HIDKitVersionNumber;

//! Project version string for HIDKit.
FOUNDATION_EXPORT const unsigned char HIDKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <HIDKit/PublicHeader.h>

#import <HIDKit/HIDManager.h>
#import <HIDKit/HIDDevice.h>
#import <HIDKit/HIDDevice+DeviceProperties.h>
#import <HIDKit/HIDElement.h>
#import <HIDKit/HIDElement+ElementProperties.h>
#import <HIDKit/HIDValue.h>
#import <HIDKit/HIDQueue.h>
#import <HIDKit/HIDTransaction.h>
