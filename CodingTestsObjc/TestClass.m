//
//  TestClass.m
//  Macoun-2018objc
//
//  Created by Marcel Weiher on 07.04.20.
//  Copyright © 2020 metaobject. All rights reserved.
//

#import "TestClass.h"

@implementation TestClass

-(NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p: hi: %ld there: %ld \"%@\">",[self class],self,self.hi,self.there,self.comment];
}

@end
