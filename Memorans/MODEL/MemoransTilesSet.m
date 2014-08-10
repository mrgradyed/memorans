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

#pragma mark - INIT

- (instancetype)initWithSetType:(NSString *)tileSetType
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
        newTile.tileSetType = tileSetType;
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

    self = [self initWithSetType:firstTileSet];

    return self;
}

#pragma mark - NSCoding PROTOCOL

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    if (self)
    {
        _tilesInSet = [aDecoder decodeObjectForKey:@"tilesInSet"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.tilesInSet forKey:@"tilesInSet"];
}

@end
