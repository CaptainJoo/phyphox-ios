//
//  Constants.m
//  phyphox
//
//  Created by Jonas Gessner on 15.01.16.
//  Copyright © 2016 RWTH Aachen. All rights reserved.
//

#import "Constants.h"

BOOL ptHelperFunctionIsIOS9(void) {
    static BOOL ios9 = NO;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSOperatingSystemVersion v;
        v.majorVersion = 9;
        v.minorVersion = 0;
        v.patchVersion = 0;
        
        ios9 = [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:v];
    });
    
    return ios9;
}
