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

-(void)decodeNSJSON:(NSData*)json
{
    NSArray *plistResult=[NSJSONSerialization JSONObjectWithData:json options:0 error:nil];
    NSLog(@"NSJSON %@ with %ld objects",plistResult[0],[plistResult count]);
}

-(void)decodeNSJSONAndKVC:(NSData*)json
{
    NSArray *keys=@[ @"hi", @"there", @"comment"];
    NSArray *plistResult=[NSJSONSerialization JSONObjectWithData:json options:0 error:nil];
    NSMutableArray *objResult=[NSMutableArray arrayWithCapacity:plistResult.count+20];
    for ( NSDictionary *d in plistResult) {
        TestClass *cur=[TestClass new];
        for (NSString *key in keys) {
            [cur setValue:d[key] forKey:key];
        }
        [objResult addObject:cur];
    }
    NSLog(@"NSJSON+KVC %@ with %ld objects",objResult[0],[objResult count]);
}
#define COUNT 1000000
-(void)createObjects
{
    NSMutableArray *objResult=[NSMutableArray arrayWithCapacity:COUNT+20];
    for ( int i=0;i<COUNT;i++ ) {
#if 1
        TestClass *cur=[[TestClass alloc] initWithHi:i there:i comment:@"comment"];
#else
        TestClass *cur=[[TestClass alloc] init];
        cur.hi=i;
        cur.there=i;
        cur.comment=@"comment";
#endif
        [objResult addObject:cur];
    }
    NSLog(@"Created objects in code w/o parsing %@ with %ld objects",objResult[0],[objResult count]);
}

-(void)createDicts
{
    NSMutableArray *objResult=[NSMutableArray arrayWithCapacity:COUNT+20];
    for ( int i=0;i<COUNT;i++ ) {
#if 0
        NSDictionary *cur=@{
            @"hi": @(i),
            @"there": @(i),
            @"comment": @"comment",

        };
#else
        NSMutableDictionary *cur=[NSMutableDictionary dictionary];
        cur[@"hi"]=@(i);
        cur[@"there"]=@(i);
        cur[@"comment"]=@"comment";
#endif
        [objResult addObject:[cur copy]];
    }
    NSLog(@"Created dicts in code w/o parsing %@ with %ld objects",objResult[0],[objResult count]);
}

-(void)decodeMPWViaDictsAndKVC:(NSData*)json
{
    NSArray *keys=@[ @"hi", @"there", @"comment"];
    MPWMASONParser *parser=[MPWMASONParser parser];
    [parser setFrequentStrings:keys];
    NSArray* plistResult = [parser parsedData:json];
#if 1
    NSMutableArray *objResult=[NSMutableArray arrayWithCapacity:plistResult.count+20];
    for ( NSDictionary *d in plistResult) {
        TestClass *cur=[TestClass new];
        for (NSString *key in keys) {
            [cur setValue:d[key] forKey:key];
        }
        [objResult addObject:cur];
    }
#else
    NSArray *objResult=plistResult;
#endif
    NSLog(@"MPWMASON %@ with %ld objects",objResult[0],[objResult count]);
}

-(void)decodeMPWDicts:(NSData*)json
{
    NSArray *keys=@[ @"hi", @"there", @"comment"];
    MPWMASONParser *parser=[MPWMASONParser parser];
    [parser setFrequentStrings:keys];
    [parser setBuilder:nil];
    NSArray* plistResult = [parser parsedData:json];
    NSArray *objResult=plistResult;
    NSLog(@"MPWMASON %@ with %ld dicts",[objResult firstObject],[objResult count]);
}

-(void)decodeMPWDirect:(NSData*)json
{
    @autoreleasepool {
        NSArray *keys=@[ @"hi", @"there", @"comment"];
        MPWMASONParser *parser=[MPWMASONParser parser];
        MPWObjectBuilder *builder=[[MPWObjectBuilder alloc] initWithClass:[TestClass class]];
        builder.streamingThreshold=1;
        [parser setBuilder:builder];
        [parser setFrequentStrings:keys];
        NSArray* objResult = [parser parsedData:json];
        NSLog(@"MPWMASON %@ with %ld elements",[objResult firstObject],[objResult count]);
    }
}

-(void)decodeApple:(NSData*)json
{
    id result = [NSJSONSerialization JSONObjectWithData:json options:0 error:nil];
    NSLog(@"NSJSON %@ with %ld elements",[result class],[(NSArray*)result count]);
}

-(void)decodeTest
{
    NSData *json=[NSData dataWithContentsOfFile:@"/tmp/swlist.json" options:0 error:nil];
    NSLog(@"got data with %ld bytes",[json length]);
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
//    [self decodeMPWViaDictsAndKVC:json];
//        [self decodeMPWDicts:json];
//    [self decodeNSJSON:json];
//    [self decodeNSJSONAndKVC:json];
//    [self decodeNSJSONSerialisationAndKVC:json];
    [self decodeMPWDirect:json];
//    [self createDicts];
//    [self createObjects];

    NSTimeInterval decodeTime = [NSDate timeIntervalSinceReferenceDate] - start;
    NSLog(@"real time to decode: %g",decodeTime);
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self decodeTest];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
