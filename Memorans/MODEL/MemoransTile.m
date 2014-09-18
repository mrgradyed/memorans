//
//  MemoransTile.m
//  Memorans
//
//  Created by emi on 01/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransTile.h"

@interface MemoransTile ()

// The tile id (tile type + tile value) to uniquely identify a tile in the game.

@property(strong, nonatomic) NSString *tileID;

@end

@implementation MemoransTile

#pragma mark - SETTERS AND GETTERS

- (void)setTileValue:(NSInteger)tileValue
{
    if (gMinTileValue <= tileValue <= gMaxTileValue)
    {
        // The tile value is valid, set it.

        _tileValue = tileValue;
    }
}

- (void)setTileSetType:(NSString *)tileSetType
{
    if ([[MemoransTile allowedTileSets] containsObject:tileSetType])
    {
        // The tile set is valid, set it.

        _tileSetType = tileSetType;
    }
}

- (NSString *)tileID
{
    if (!_tileID)
    {
        // Generate the tile set ID, chaining the tile type and the tile value.

        _tileID = [NSString stringWithFormat:@"%@%d", self.tileSetType, (int)self.tileValue];
    }

    return _tileID;
}

#pragma mark - EQUALITY

- (BOOL)isEqualToTile:(MemoransTile *)otherTile
{
    // Tiles are equal when their IDs are the same.

    if ([[self tileID] isEqualToString:[otherTile tileID]])
    {

        return YES;
    }

    return NO;
}

#pragma mark - NSCopying PROTOCOL

- (id)copyWithZone:(NSZone *)zone
{
    // Get a new tile instance.

    MemoransTile *tileCopy = [[MemoransTile allocWithZone:zone] init];

    // To copy a tile object we have to copy all these properties.

    tileCopy.tileValue = self.tileValue;
    tileCopy.tileSetType = self.tileSetType;
    tileCopy.tileID = self.tileID;
    tileCopy.selected = self.selected;
    tileCopy.paired = self.paired;

    return tileCopy;
}

#pragma mark - NSCoding PROTOCOL

// Archiving.

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    if (self)
    {
        // Reload the saved tiles properties.

        _tileValue = [aDecoder decodeIntegerForKey:@"tileValue"];
        _tilePoints = [aDecoder decodeIntegerForKey:@"_tilePoints"];

        _tileSetType = [aDecoder decodeObjectForKey:@"tileSetType"];
        _tileID = [aDecoder decodeObjectForKey:@"tileID"];

        _selected = [aDecoder decodeBoolForKey:@"selected"];
        _paired = [aDecoder decodeBoolForKey:@"paired"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    // Save the tiles properties.

    [aCoder encodeInteger:self.tileValue forKey:@"tileValue"];
    [aCoder encodeInteger:self.tilePoints forKey:@"_tilePoints"];

    [aCoder encodeObject:self.tileSetType forKey:@"tileSetType"];
    [aCoder encodeObject:self.tileID forKey:@"tileID"];

    [aCoder encodeBool:self.selected forKey:@"selected"];
    [aCoder encodeBool:self.paired forKey:@"paired"];
}

#pragma mark - GLOBAL VARS AND CLASS METHODS

// Global tile limits.

const int gMaxTileValue = 20;
const int gMinTileValue = 1;

+ (NSArray *)allowedTileSets
{
    // The currently available tile types.

    return @[ @"Happy", @"Angry", ];
}

@end
