//
//  MPWMediathekFilm.h
//  CodingTestsObjc
//
//  Created by Marcel Weiher on 29.05.20.
//  Copyright © 2020 metaobject. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPWMediathekFilm : NSObject

@property (nonatomic,strong) NSString *sender;
@property (nonatomic,strong) NSString *thema;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *url;

-(instancetype)initWithArray:(NSArray*)jsonArrayEntries;

@end

NS_ASSUME_NONNULL_END
