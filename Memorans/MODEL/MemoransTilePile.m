//
//  MemoransTilesPile.m
//  Memorans
//
//  Created by emi on 02/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransTilePile.h"
#import "MemoransTile.h"

@interface MemoransTilePile ()

@property(nonatomic, strong) NSMutableArray *tilesInPile;

@end

@implementation MemoransTilePile

#pragma mark - SETTERS AND GETTERS

- (NSMutableArray *)tilesInPile
{
    if (!_tilesInPile)
    {
        _tilesInPile = [[NSMutableArray alloc] init];
    }
    return _tilesInPile;
}

#pragma mark - INITIALISERS

// Designated initialiser
- (instancetype)initWithSet:(NSString *)tileSet
{
    self = [super init];

    if (!self)
    {
        return nil;
    }

    MemoransTile *newTile;
    NSInteger minVal = minTileValue;
    NSInteger maxVal = maxTileValue;

    // We generate the pile with the provided tile set.
    for (NSInteger tileVal = minVal; tileVal <= maxVal; tileVal++)
    {
        newTile = [[MemoransTile alloc] init];
        newTile.tileSet = tileSet;
        newTile.tileValue = tileVal;

        [self.tilesInPile addObject:newTile];
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

#pragma mark - INSTANCE METHODS

- (MemoransTile *)extractRandomTileFromPile
{
    MemoransTile *randomTile = nil;
    NSInteger numberOfTilesInPile = [self.tilesInPile count];

    if (numberOfTilesInPile)
    {
        NSInteger tileIndex = arc4random() % numberOfTilesInPile;
        randomTile = self.tilesInPile[tileIndex];

        [self.tilesInPile removeObjectAtIndex:tileIndex];
    }
    return randomTile;
}

@end
