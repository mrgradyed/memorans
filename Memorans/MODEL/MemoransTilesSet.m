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

@property(strong, nonatomic) NSMutableArray *setTiles;

@end

@implementation MemoransTilesSet

#pragma mark - SET TILES SET MANAGEMENT

- (MemoransTile *)extractRandomTileFromSet
{
    MemoransTile *randomTile = nil;

    NSInteger numberOfSetTiles = [self.setTiles count];

    if (numberOfSetTiles)
    {
        NSInteger tileIndex = arc4random() % numberOfSetTiles;

        randomTile = self.setTiles[tileIndex];

        [self.setTiles removeObjectAtIndex:tileIndex];
    }

    return randomTile;
}

#pragma mark - INIT

- (instancetype)initWithSetType:(NSString *)tileSetType
{
    self = [super init];

    if (self)
    {
        _setTiles = [[NSMutableArray alloc] initWithCapacity:gMaxTileValue];

        MemoransTile *newTile;

        for (int tileVal = gMinTileValue; tileVal <= gMaxTileValue; tileVal++)
        {
            newTile = [[MemoransTile alloc] init];

            newTile.tileSetType = tileSetType;
            newTile.tileValue = tileVal;

            [_setTiles addObject:newTile];
        }
    }

    return self;
}

- (instancetype)init
{
    self = [super init];

    if (self)
    {
        self = [self initWithSetType:[MemoransTile allowedTileSets][0]];
    }

    return self;
}

#pragma mark - NSCoding PROTOCOL

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    if (self)
    {
        _setTiles = [aDecoder decodeObjectForKey:@"setTiles"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.setTiles forKey:@"setTiles"];
}

@end
