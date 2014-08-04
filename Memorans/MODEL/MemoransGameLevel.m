//
//  MemoransGameLevel.m
//  Memorans
//
//  Created by emi on 03/08/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransGameLevel.h"

@implementation MemoransGameLevel

#pragma mark - CLASS METHODS

+ (NSArray *)allowedTilesInLevels
{
    return @[
        @6,
        @6,
        @8,
        @8,
        @12,
        @12,
        @16,
        @16,
        @18,
        @18,
        @20,
        @20,
        @24,
        @24,
        @28,
        @28,
        @30,
        @30,
        @32,
        @32,
        @36,
        @36,
        @40,
        @40
    ];
}

@end
