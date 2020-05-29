//
//  MPWMediathekBuilder.h
//  CodingTestsObjc
//
//  Created by Marcel Weiher on 29.05.20.
//  Copyright © 2020 metaobject. All rights reserved.
//

#import <MPWFoundation/MPWFoundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface MPWMediathekBuilder : MPWPListBuilder

@property (nonatomic,strong) NSArray *keys;
@property (nonatomic,strong) NSMutableArray *rows;


@end

NS_ASSUME_NONNULL_END
