//
//  MemoransGameLevel.m
//  Memorans
//
//  Created by emi on 03/08/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransGameLevel.h"
#import "MemoransSharedLevelsPack.h"

@implementation MemoransGameLevel

#pragma mark - SETTERS AND GETTERS

- (void)setHasSave:(BOOL)hasSave
{
    if (hasSave)
    {
        for (MemoransGameLevel *lvl in [MemoransSharedLevelsPack sharedLevelsPack].levelsPack)
        {
            if ([lvl isEqual:self])
            {
                _hasSave = YES;
            }
            else
            {
                lvl.hasSave = NO;
            }
        }
    }
    else
    {
        _hasSave = NO;
    }

    [[MemoransSharedLevelsPack sharedLevelsPack] archiveLevelsStatus];
}

#pragma mark - CLASS METHODS

+ (NSArray *)allowedTilesCountsInLevels
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

#pragma mark - NSCoding PROTOCOL

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    if (self)
    {
        _tileSetType = [aDecoder decodeObjectForKey:@"tileSetType"];

        _tilesInLevel = [aDecoder decodeIntegerForKey:@"tilesInLevel"];

        _unlocked = [aDecoder decodeBoolForKey:@"unlocked"];

        _hasSave = [aDecoder decodeBoolForKey:@"hasSave"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.tileSetType forKey:@"tileSetType"];

    [aCoder encodeInteger:self.tilesInLevel forKey:@"tilesInLevel"];

    [aCoder encodeBool:self.unlocked forKey:@"unlocked"];

    [aCoder encodeBool:self.hasSave forKey:@"hasSave"];
}

@end
