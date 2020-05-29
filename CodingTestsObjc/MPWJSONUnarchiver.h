//
//  MPWJSONUnarchiver.h
//  CodingTestsObjc
//
//  Created by Marcel Weiher on 30.04.20.
//  Copyright © 2020 metaobject. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MPWFoundation;

NS_ASSUME_NONNULL_BEGIN

@interface MPWJSONUnarchiver : NSCoder <MPWPlistStreaming>

@property (nonatomic,strong) NSArray *keys;
@property (nonatomic,assign) Class objClass;
@property (nonatomic,strong) NSMutableArray *array;

- (nullable instancetype)initForReadingFromData:(NSData *)data error:(NSError **)error;


@end

NS_ASSUME_NONNULL_END
