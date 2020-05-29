//
//  MPWMediathekBuilder.m
//  CodingTestsObjc
//
//  Created by Marcel Weiher on 29.05.20.
//  Copyright © 2020 metaobject. All rights reserved.
//

#import "MPWMediathekBuilder.h"
#import "MPWMediathekFilm.h"

@interface MPWMediathekBuilder()

@property (nonatomic, strong) NSArray *currentFilm;

@end

@implementation MPWMediathekBuilder



-(instancetype)init
{
    self=[super init];
    self.keys = [NSMutableArray array];
    self.rows = [NSMutableArray array];
    return self;
}

-(void)beginArray
{
    NSMutableArray *container=[[NSMutableArray alloc] init];
    if ( [[self key] isEqualToString:@"X"]) {
        self.currentFilm = container;
    } else {
        self.keys = container;
    }
#ifndef __clang_analyzer__
    [self pushContainer:container];
#endif
}

-(void)endArray
{
    static int i=0;
    if ( self.currentFilm ) {
        MPWMediathekFilm *film=[[MPWMediathekFilm alloc] initWithArray:self.currentFilm];
        if ( i++ < 20) {
            NSLog(@"self.currentFilm: %@ as object: %@",self.currentFilm,film);
        }
        [self.rows addObject:film];
    }
    self.currentFilm=nil;
    [super endArray];
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"<%@:%p: keys: %@ %d rows>",[self class],self, self.keys,self.rows.count];
}
@end
