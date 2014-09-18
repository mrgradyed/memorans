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

// The array containing the set of tiles. The tiles in the set are unique.
// 2 copies of each tiles extracted from the set will be put in game.

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
        // Set Tiles are present.

        // Get a random index between 0 and the number of tiles in the set - 1.

        NSInteger tileIndex = arc4random() % numberOfSetTiles;

        // Get a random tile using the above index.

        randomTile = self.setTiles[tileIndex];

        // Remove the extracted tile from the set.

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
        // Create an array for containin the set of tiles, use the max number of different tiles
        // values in this app.

        _setTiles = [[NSMutableArray alloc] initWithCapacity:gMaxTileValue];

        MemoransTile *newTile;

        for (int tileVal = gMinTileValue; tileVal <= gMaxTileValue; tileVal++)
        {
            // For each tile value available in this app, create a new tile object.

            newTile = [[MemoransTile alloc] init];

            // Set the tile type to be the one specified.

            newTile.tileSetType = tileSetType;

            // Set the current tile value to be the current one in the loop.

            newTile.tileValue = tileVal;

            // Add the new tile to the set.

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
        // Create a new set of tiles using the default tile type.

        self = [self initWithSetType:[MemoransTile allowedTileSets][0]];
    }

    return self;
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
        // Reload the saved set of tiles.

        _setTiles = [aDecoder decodeObjectForKey:@"setTiles"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    // Save the current set of tiles.

    [aCoder encodeObject:self.setTiles forKey:@"setTiles"];
}

@end
