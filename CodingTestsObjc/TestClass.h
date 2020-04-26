//
//  TestClass.h
//  Macoun-2018objc
//
//  Created by Marcel Weiher on 07.04.20.
//  Copyright © 2020 metaobject. All rights reserved.
//

#import <MPWFoundation/MPWFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestClass : MPWObject

@property (nonatomic) long hi,there;
@property (nonatomic,strong) NSString *comment;

-initWithHi:(long)newHi there:(long)newThere comment:(NSString*)newComment;


@end

NS_ASSUME_NONNULL_END
