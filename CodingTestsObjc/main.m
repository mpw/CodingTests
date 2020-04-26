//
//  main.m
//  Macoun-2018objc
//
//  Created by Marcel Weiher on 02.04.20.
//  Copyright © 2020 metaobject. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CodingTester.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
    }
    CodingTester *tester=[CodingTester new];
    [tester decodeTest];
}
