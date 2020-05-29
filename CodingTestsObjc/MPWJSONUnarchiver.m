//
//  MPWJSONUnarchiver.m
//  CodingTestsObjc
//
//  Created by Marcel Weiher on 30.04.20.
//  Copyright © 2020 metaobject. All rights reserved.
//

#import "MPWJSONUnarchiver.h"
#import "TestClass.h"

@interface MPWJSONUnarchiver()

@property (nonatomic,strong) MPWMASONParser *parser;
@property (nonatomic,strong) MPWSmallStringTable *currentDict;
@property (nonatomic,strong) NSData *jsonData;

@end

@implementation MPWJSONUnarchiver
{
    const char *keyStr;
    long keyLen;
}

- (nullable instancetype)initForReadingFromData:(NSData *)data error:(NSError **)error
{
    self=[super init];
    self.jsonData=data;
    self.parser=[MPWMASONParser parser];
    self.parser.builder=self;
    self.keys = @[ @"hi", @"there", @"comment"];
    self.array = [NSMutableArray array];
    self.objClass = [TestClass class];
    return self;
}

-(id)decodeObject
{
    [self.parser parsedData:self.jsonData];
    return self.array;
}

-(void)beginArray
{

}

-(void)endArray
{

}

-(void)beginDictionary
{
    if (!self.currentDict) {
        self.currentDict = [[MPWSmallStringTable alloc] initWithKeys:self.keys values:self.keys];
    }
}

-(void)endDictionary
{
    id anObject=[(id <NSSecureCoding>)[(id)self.objClass alloc] initWithCoder:self];

    [self.array addObject:anObject];
}


- (nullable id)decodeObjectForKey:(NSString *)key
{
    return [self.currentDict objectForKey:key];
}

- (int)decodeIntForKey:(NSString *)key
{
    return [[self.currentDict objectForKey:key] integerValue];
}
- (int32_t)decodeInt32ForKey:(NSString *)key
{
    return [[self.currentDict objectForKey:key] integerValue];
}
- (int64_t)decodeInt64ForKey:(NSString *)key
{
    return [[self.currentDict objectForKey:key] integerValue];
}

-(void)writeKeyString:(const char *)aKey length:(long)len
{
    keyStr=aKey;
    keyLen=len;
}

-(void)writeInteger:(long)number
{
    if (keyStr) {
        [self.currentDict setObject:@(number) forCString:keyStr length:(int)keyLen];
        keyStr=NULL;
    }
}

-(void)writeString:(id)aString
{
    if (keyStr) {
        [self.currentDict setObject:aString forCString:keyStr length:(int)keyLen];
        keyStr=NULL;
    }
}

- (void)pushContainer:(id)anObject {

}


- (void)pushObject:(id)anObject {

}


- (id)result {
    return self.array;
}


- (void)writeNumber:(id)aNumber {

}


- (void)writeObject:(id)anObject forKey:(id)aKey {

}



@end
