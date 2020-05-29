//
//  MPWMediathekFilm.m
//  CodingTestsObjc
//
//  Created by Marcel Weiher on 29.05.20.
//  Copyright © 2020 metaobject. All rights reserved.
//

#import "MPWMediathekFilm.h"

@implementation MPWMediathekFilm

-(instancetype)initWithArray:(NSArray*)jsonArrayEntries
{
    self=[super init];
    self.sender=jsonArrayEntries[0];
    self.title=jsonArrayEntries[2];
    self.url=jsonArrayEntries[8];
    return self;
}

-(NSString*)description {
    return [NSString stringWithFormat:@"%@ - %@ - %@",self.sender,self.title,self.url];
}

@end
