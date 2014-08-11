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

- (NSArray *)levelsPack
{
    if (!_levelsPack)
    {
        NSMutableArray *pack = [[NSMutableArray alloc] init];

        MemoransGameLevel *newLevel;

        int loopCount = 0;

        for (NSNumber *tilesInLevel in [MemoransGameLevel allowedTilesCountsInLevels])
        {
            newLevel = [[MemoransGameLevel alloc] init];

            newLevel.tilesInLevel = [tilesInLevel integerValue];

            NSInteger tileSetTypeIndex = loopCount % [[MemoransTile allowedTileSets] count];

            newLevel.tileSetType = [MemoransTile allowedTileSets][tileSetTypeIndex];

            [pack addObject:newLevel];

            loopCount++;
        }

        _levelsPack = pack;
    }

    return _levelsPack;
}

#pragma mark - INITS

- (instancetype)init
{
    @throw [NSException
        exceptionWithName:@"SingletonException"
                   reason:@"Please use +[MemoransLevelPack " @"sharedLevelsPack] instead."
                 userInfo:nil];

    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];

    if (self)
    {
        _levelsPack = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePathForArchiving]];
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

#pragma mark - ARCHIVING

- (NSString *)filePathForArchiving
{
    NSString *documentDirectory =
        NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];

    return [documentDirectory stringByAppendingPathComponent:@"levelsStatus.archive"];
}

- (BOOL)archiveLevelsStatus
{
    return [NSKeyedArchiver archiveRootObject:self.levelsPack toFile:[self filePathForArchiving]];
}

- (BOOL)removeLevelsStatusOnDisk
{
    self.levelsPack = nil;

    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSError *error;

    return [fileManager removeItemAtPath:[self filePathForArchiving] error:&error];
}

@end
