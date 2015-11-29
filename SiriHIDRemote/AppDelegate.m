//
//  AppDelegate.m
//  SiriHIDRemote
//
//  Created by Adam Gastineau on 10/15/15.
//  Copyright © 2015 AppCannon Software. All rights reserved.
//

#import "AppDelegate.h"

#import "HIDController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
//    NSLog(@"%@", [HIDManager devices]);
    [HIDController sharedInstance];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
