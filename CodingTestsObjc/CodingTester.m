//
//  AppDelegate.m
//  Macoun-2018objc
//
//  Created by Marcel Weiher on 02.04.20.
//  Copyright © 2020 metaobject. All rights reserved.
//

#import "CodingTester.h"
#import "TestClass.h"
#import "MPWArraysBuilder.h"
#import "MPWJSONUnarchiver.h"
#import "MPWMediathekBuilder.h"
#import "MPWMediathekFilm.h"

@import MPWFoundation;

@interface CodingTester ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation CodingTester

-(void)decodeNSJSON:(NSData*)json
{
    NSArray *plistResult=[NSJSONSerialization JSONObjectWithData:json options:0 error:nil];
//    NSDictionary *first=[plistResult firstObject];
        NSLog(@"NSJSON %@ with %ld objects",[plistResult class],[plistResult count]);
//    NSLog(@"class of dict: '%s'",class_getName(object_getClass(first)));
//    for (id key in [first allKeys]) {
//        NSLog(@"key: %@ %p '%s'",key,key,class_getName(object_getClass(key)));
//    }

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
    MPWMASONParser *parser=[MPWMASONParser parser];
    //    [parser setFrequentStrings:@[ @"hi", @"there", @"comment"]];
    [parser setFrequentStrings:@[ @"X"]];

    [parser setBuilder:nil];
    NSArray* plistResult = [parser parsedData:json];
    NSLog(@"MPWMASON %@ %ld dicts",[plistResult class],[plistResult count]);
    //   NSLog(@"class of dict: '%s'",class_getName(object_getClass(first)));
    //    for (id key in [first allKeys]) {
    //        NSLog(@"key: %@ %p '%s'",key,key,class_getName(object_getClass(key)));
    //    }
}

-(void)decodeMediathek:(NSData*)json
{
    MPWMASONParser *parser=[MPWMASONParser parser];
    //    [parser setFrequentStrings:@[ @"hi", @"there", @"comment"]];
    [parser setFrequentStrings:@[ @"X", @"",
                                  @"WDR",
                                  @"ARTE.FR",
                                  @"NDR",
                                  @"3Sat",
                                  @"SRF",
                                  @"SWR",
                                  @"MDR",
                                  @"SRF.Podcast",
                                  @"ARD",
                                  @"KiKA",
                                  @"RBB",
                                  @"PHOENIX",
                                  @"BR",
                                  @"DW",
                                  @"ORF",
                                  @"HR",
                                  @"SR",
                                  @"ZDF-tivi",
                                  @"rbtv",
                                  @"ARTE.DE",
                                  @"ZDF"]];
    MPWMediathekBuilder *builder=[MPWMediathekBuilder builder];
    [parser setBuilder:builder];
    [parser parsedData:json];
    NSArray *filme=[builder rows];
    MPWByteStream *Stdout=[MPWByteStream Stdout];
    for ( MPWMediathekFilm *film in filme) {
        if ( [film.title containsString:@"Unser Sandm"] && ![film.title containsString:@"Gebä"] ) {
            [Stdout println:[film description]];
        }
    }

//    NSLog(@"Mediathek %@ first film: %@",builder,builder.rows.firstObject);
//    NSLog(@"Sender %@ ",[builder alleSender]);
    //   NSLog(@"class of dict: '%s'",class_getName(object_getClass(first)));
    //    for (id key in [first allKeys]) {
    //        NSLog(@"key: %@ %p '%s'",key,key,class_getName(object_getClass(key)));
    //    }
}

-(void)decodeMPWDirect:(NSData*)json
{
    MPWMASONParser *parser=[[MPWMASONParser alloc] initWithClass:[TestClass class]];
    NSArray* objResult = [parser parsedData:json];
//    NSLog(@"MPWMASON %@ with %ld elements",[objResult firstObject],[objResult count]);
}

static long objCount=0;
static long hiCount=0;
MPWRusage *first = nil;

-(void)writeObject:(TestClass*)anObject
{
    if (!first) {
        first=[MPWRusage current];
    }
    objCount++;
    hiCount+=anObject.hi;
}

-(void)decodeMPWDirectStream:(NSData*)json
{
    MPWMASONParser *parser=[[MPWMASONParser alloc] initWithClass:[TestClass class]];
    MPWObjectBuilder *builder=(MPWObjectBuilder*)[parser builder];
    [builder setStreamingThreshold:1];
    [builder setTarget:self];
    [parser parsedData:json];
//    NSLog(@"objCount: %ld, hiCount: %ld",objCount,hiCount);
}

-(void)decodeMPWArrays:(NSData*)json
{
    NSArray *keys=@[ @"hi", @"there", @"comment"];
    MPWIntArray *hi=[MPWIntArray array];
    MPWIntArray *there=[MPWIntArray array];
    NSMutableArray *comments=[NSMutableArray array];
    NSArray *arrays=@[hi,there,comments];
    MPWArraysBuilder *builder=[[MPWArraysBuilder alloc] initWithArays:arrays

                                                           forKeys:keys];
    MPWMASONParser *parser=[MPWMASONParser parser];
    [parser setBuilder:builder];
    [parser setFrequentStrings:keys];
    //    [parser setBuilder:nil];

    NSArray* objResult = [parser parsedData:json];
//    NSLog(@"arrays: %@",arrays);
}

-(void)decodeApple:(NSData*)json
{
    id result = [NSJSONSerialization JSONObjectWithData:json options:0 error:nil];
    NSLog(@"NSJSON %@ with %ld elements",[result class],[(NSArray*)result count]);
}

-(void)decodeMPWJSONUnarchiver:(NSData*)json
{
    MPWJSONUnarchiver *unarchiver=[[MPWJSONUnarchiver alloc] initForReadingFromData:json error:nil];
    id result=[unarchiver decodeObject];
    NSLog(@"MPWJSONUnarchiver %@ with %ld elements",[result class],[(NSArray*)result count]);
    NSLog(@"MPWJSONUnarchiver %@ ",[result firstObject]);
    NSLog(@"MPWJSONUnarchiver %@ ",[result lastObject]);
}

-(void)decodeTest
{
 //   NSData *json=[NSData dataWithContentsOfFile:@"/tmp/swlist.json" options:0 error:nil];
    NSLog(@"-decodeTest before read data");
   NSData *json=[NSData dataWithContentsOfFile:@"/tmp/filmliste.txt" options:0 error:nil];
    NSLog(@"got data with %ld bytes",[json length]);
//    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    MPWRusage* start=[MPWRusage current];
//    [self decodeMPWViaDictsAndKVC:json];
//    [self decodeMPWDicts:json];
    [self decodeMediathek:json];

//      [self decodeNSJSON:json];
  //  [self decodeNSJSONAndKVC:json];
//    [self decodeNSJSONSerialisationAndKVC:json];
//    [self decodeMPWDirect:json];
//    [self decodeMPWDirectStream:json];


//    [self decodeMPWJSONUnarchiver:json];
//    [self decodeMPWArrays:json];

//    [self createDicts];
//    [self createObjects];
    MPWRusage* rtime=[MPWRusage timeRelativeTo:start];
    if ( first ) {
        first=[first subtractStartTime:start];
        NSLog(@"user time to first: %ld µs",[first userMicroseconds]);
    }
    NSLog(@"user time to decode: %ld ms",[rtime userMicroseconds]/1000);
}

@end
