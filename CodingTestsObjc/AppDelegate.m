//
//  AppDelegate.m
//  Macoun-2018objc
//
//  Created by Marcel Weiher on 02.04.20.
//  Copyright © 2020 metaobject. All rights reserved.
//

#import "AppDelegate.h"
#import "TestClass.h"

@import MPWFoundation;

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

-(void)decodeMPW:(NSData*)json
{
    NSArray *keys=@[ @"hi", @"there", @"comment"];
    MPWMASONParser *parser=[MPWMASONParser parser];
    [parser setFrequentStrings:keys];
    NSArray* plistResult = [parser parsedData:json];
    NSMutableArray *objResult=[NSMutableArray arrayWithCapacity:plistResult.count+20];
    for ( NSDictionary *d in plistResult) {
        TestClass *cur=[TestClass new];
        for (NSString *key in keys) {
            [cur setValue:d[key] forKey:key];
        }
        [objResult addObject:cur];
    }
    NSLog(@"MPWMASON %@ with %ld elements",objResult[0],[objResult count]);
}

-(void)decodeApple:(NSData*)json
{
    id result = [NSJSONSerialization JSONObjectWithData:json options:0 error:nil];
    NSLog(@"NSJSON %@ with %ld elements",[result class],[(NSArray*)result count]);
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSData *json=[NSData dataWithContentsOfFile:@"/tmp/swlist.json" options:0 error:nil];
    NSLog(@"got data with %ld bytes",[json length]);
    [self decodeMPW:json];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
