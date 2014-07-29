//
//  MemoransTilesSet.m
//  Memorans
//
//  Created by emi on 02/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransTilesSet.h"
#import "MemoransTile.h"

@interface MemoransTilesSet ()

#pragma mark - PROPERTIES

@property(nonatomic, strong) NSMutableArray *tilesInSet;

@end

@implementation MemoransTilesSet

#pragma mark - SETTERS AND GETTERS

- (NSMutableArray *)tilesInSet
{
    if (!_tilesInSet)
    {
        _tilesInSet = [[NSMutableArray alloc] init];
    }
    return _tilesInSet;
}

#pragma mark - TILES SET MANAGEMENT

- (MemoransTile *)extractRandomTileFromSet
{
    MemoransTile *randomTile = nil;
    NSInteger numberOfTilesInSet = [self.tilesInSet count];

    if (numberOfTilesInSet)
    {
        NSInteger tileIndex = arc4random() % numberOfTilesInSet;
        randomTile = self.tilesInSet[tileIndex];

        [self.tilesInSet removeObjectAtIndex:tileIndex];
    }
    return randomTile;
}

#pragma mark - INITIALISERS

- (instancetype)initWithSet:(NSString *)tileSet
{
    self = [super init];

    if (!self)
    {
        return nil;
    }

    MemoransTile *newTile;

    for (int tileVal = gMinTileValue; tileVal <= gMaxTileValue; tileVal++)
    {
        newTile = [[MemoransTile alloc] init];
        newTile.tileSet = tileSet;
        newTile.tileValue = tileVal;

        [self.tilesInSet addObject:newTile];
    }

    return self;
}

- (instancetype)init
{
    self = [super init];

    if (!self)
    {
        return nil;
    }

    NSString *firstTileSet = [[MemoransTile allowedTileSets] firstObject];

    self = [self initWithSet:firstTileSet];

    return self;
}

@end
