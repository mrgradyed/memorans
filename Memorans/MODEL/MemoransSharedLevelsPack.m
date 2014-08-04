//
//  MemoransSharedLevelsPack.m
//  Memorans
//
//  Created by emi on 03/08/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransSharedLevelsPack.h"
#import "MemoransGameLevel.h"
#import "MemoransTile.h"

@implementation MemoransSharedLevelsPack

#pragma mark - SETTERS AND GETTERS

- (NSMutableArray *)levelsPack
{
    if (!_levelsPack)
    {
        _levelsPack = [[NSMutableArray alloc] init];

        MemoransGameLevel *newLevel;

        int loopCount = 0;

        for (NSNumber *tilesInLevel in [MemoransGameLevel allowedTilesInLevels])
        {
            newLevel = [[MemoransGameLevel alloc] init];

            newLevel.tilesInLevel = [tilesInLevel integerValue];

            NSInteger tileSetTypeIndex = loopCount % [[MemoransTile allowedTileSets] count];

            newLevel.tileSetType = [MemoransTile allowedTileSets][tileSetTypeIndex];

            [self.levelsPack addObject:newLevel];

            loopCount++;
        }
    }
    return _levelsPack;
}

#pragma mark - INITS

- (instancetype)init
{
    @throw
        [NSException exceptionWithName:@"SingletonException"
                                reason:@"Please use +[MemoransLevelPack sharedLevelsPack] instead."
                              userInfo:nil];

    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];

    if (!self)
    {
        return nil;
    }

    return self;
}

#pragma mark - CLASS METHODS

+ (instancetype)sharedLevelsPack
{
    static MemoransSharedLevelsPack *sharedLevelsPack;

    static dispatch_once_t blockHasCompleted;

    dispatch_once(&blockHasCompleted, ^{ sharedLevelsPack = [[self alloc] initPrivate]; });

    return sharedLevelsPack;
}

@end
