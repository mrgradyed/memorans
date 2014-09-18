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
        // This level has been partially played and a game has been saved.

        for (MemoransGameLevel *lvl in [MemoransSharedLevelsPack sharedLevelsPack].levelsPack)
        {
            if ([lvl isEqual:self])
            {
                // This level has a saved game.

                _hasSave = YES;
            }
            else
            {
                // We save only the last partially played game, so we have only one saved game at
                // time. A game has been saved for this level, set the other levels not to have a
                // saved game.

                lvl.hasSave = NO;
            }
        }
    }
    else
    {
        // This level has been fully played and this level has not a saved game.

        _hasSave = NO;
    }

    // Save (by archiving) the updated levels status.

    [[MemoransSharedLevelsPack sharedLevelsPack] archiveLevelsStatus];
}

#pragma mark - CLASS METHODS

+ (NSArray *)allowedTilesCountsInLevels
{
    // The numbers of tiles per level.

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

// From Apple docs: The NSCoding protocol declares the two methods that a class
// must implement so that instances of that class can be encoded and decoded. This capability
// provides the basis for archiving.

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    if (self)
    {
        // Reload saved level status.

        _levelType = [aDecoder decodeObjectForKey:@"tileSetType"];

        _tilesInLevel = [aDecoder decodeIntegerForKey:@"tilesInLevel"];

        _completed = [aDecoder decodeBoolForKey:@"completed"];

        _hasSave = [aDecoder decodeBoolForKey:@"hasSave"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    // Save level status.

    [aCoder encodeObject:self.levelType forKey:@"tileSetType"];

    [aCoder encodeInteger:self.tilesInLevel forKey:@"tilesInLevel"];

    [aCoder encodeBool:self.completed forKey:@"completed"];

    [aCoder encodeBool:self.hasSave forKey:@"hasSave"];
}

@end
