//
//  MemoransTile.m
//  Memorans
//
//  Created by emi on 01/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransTile.h"

@interface MemoransTile ()

@property(nonatomic) NSString *tileID;

@end

@implementation MemoransTile

- (id)copyWithZone:(NSZone *)zone
{

    MemoransTile *tileCopy = [[MemoransTile allocWithZone:zone] init];

    tileCopy.tileValue = self.tileValue;
    tileCopy.tileSet = self.tileSet;
    tileCopy.selected = self.selected;
    tileCopy.paired = self.paired;

    return tileCopy;
}

#pragma mark - SETTERS AND GETTERS

- (void)setTileValue:(NSInteger)tileValue
{
    // The new value must be among the allowed ones.
    if (minTileValue <= tileValue <= maxTileValue)
    {
        _tileValue = tileValue;
    }
}

- (void)setTileSet:(NSString *)tileSet
{
    // If tileType string is not among the allowed ones, we do not set it for this
    // tile.
    if ([[MemoransTile allowedTileSets] containsObject:tileSet])
    {
        _tileSet = tileSet;
    }
}

- (NSString *)tileID
{
    if (!_tileID)
    {
        _tileID = [NSString stringWithFormat:@"%@%ld", self.tileSet, (long)self.tileValue];
    }

    return _tileID;
}

#pragma mark - CLASS VARS AND METHODS

const int maxTileValue = 20;
const int minTileValue = 1;

+ (NSArray *)allowedTileSets { return @[ @"a", @"b" ]; }

#pragma mark - INSTANCE METHODS

- (BOOL)isEqualToTile:(MemoransTile *)otherTile
{
    if ([[self tileID] isEqualToString:[otherTile tileID]])
    {
        return YES;
    }
    return NO;
}

@end
