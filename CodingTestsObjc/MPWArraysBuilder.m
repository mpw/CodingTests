//
//  MPWArraysBuilder.m
//  CodingTestsObjc
//
//  Created by Marcel Weiher on 23.04.20.
//  Copyright © 2020 metaobject. All rights reserved.
//

#import "MPWArraysBuilder.h"

@implementation MPWArraysBuilder

-(instancetype)initWithArays:(NSArray*)array forKeys:(NSArray*)keys
{
    self=[super init];
    MPWSmallStringTable *table=[[MPWSmallStringTable alloc] initWithKeys:keys values:array];
    self.arrayMap=table;
    return self;
}

-(void)writeInteger:(long)number
{
    if ( _arrayMap && keyStr) {
        MPWIntArray *a=OBJECTFORSTRINGLENGTH(_arrayMap, keyStr, keyLen);
        [a addInteger:(int)number];
        keyStr=NULL;
    }
}

-(void)writeString:(id)aString
{
    if ( _arrayMap && keyStr) {
        NSMutableArray *a=OBJECTFORSTRINGLENGTH(_arrayMap, keyStr, keyLen);
        [a addObject:aString];
        keyStr=NULL;
    }
}


-(void)beginDictionary {}
-(void)beginArray  {}
-(void)endArray {}
-(void)endDictionary {}

@end

