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

@property (nonatomic, strong) MPWMediathekFilm *currentFilm;
@property (nonatomic, strong) NSString *sender;
@property (nonatomic, assign) int attributeIndex;
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
    BOOL isX = (keyLen == 1) && (keyStr[0]=='X') ;
    if ( isX ) {
        self.currentFilm = [[MPWMediathekFilm alloc] init];
        _attributeIndex=0;
    } else {
        NSMutableArray *container=[[NSMutableArray alloc] init];
        self.keys = container;
        [self pushContainer:container];
    }
}

-(void)pushObject:(id)anObject
{
    if ( self.currentFilm) {
        switch ( _attributeIndex) {
            case 0:
                if( [anObject length] > 0 ) {
                    self.sender=anObject;
                }
                self.currentFilm.sender = self.sender;
                break;
            case 2:
                self.currentFilm.title = anObject;
                break;
            case 8:
                self.currentFilm.url = anObject;
                break;
        }
        _attributeIndex++;
    } else {
        [super pushObject:anObject];
    }
}

-(void)endArray
{
    if ( _currentFilm) {
        if ( [self.currentFilm.sender isEqualToString:@"RBB"]) {
            [self.rows addObject:self.currentFilm];
        }
        self.currentFilm=nil;
    } else {
        [super endArray];
    }
}

-(NSArray*)alleSender
{
    NSArray *sender=[[self.rows collect] sender];
    NSSet *unique=[NSSet setWithArray:sender];
    return [unique allObjects];
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"<%@:%p: keys: %@ %d rows>",[self class],self, self.keys,self.rows.count];
}


@end
