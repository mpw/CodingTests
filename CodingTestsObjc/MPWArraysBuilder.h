//
//  MPWArraysBuilder.h
//  CodingTestsObjc
//
//  Created by Marcel Weiher on 23.04.20.
//  Copyright © 2020 metaobject. All rights reserved.
//

#import <MPWFoundation/MPWFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPWArraysBuilder : MPWObjectBuilder

@property (nonatomic, strong) MPWSmallStringTable *arrayMap;

-(instancetype)initWithArays:(NSArray*)array forKeys:(NSArray*)keys;

@end

NS_ASSUME_NONNULL_END
