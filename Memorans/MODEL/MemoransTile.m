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

#pragma mark - SETTERS AND GETTERS

- (void)setTileValue:(NSInteger)tileValue
{
    if (gMinTileValue <= tileValue <= gMaxTileValue)
    {
        _tileValue = tileValue;
    }
}

- (void)setTileSetType:(NSString *)tileSet
{
    if ([[MemoransTile allowedTileSets] containsObject:tileSet])
    {
        _tileSetType = tileSet;
    }
}

- (NSString *)tileID
{
    if (!_tileID)
    {
        _tileID = [NSString stringWithFormat:@"%@%ld", self.tileSetType, (long)self.tileValue];
    }

    return _tileID;
}

#pragma mark - EQUALITY

- (BOOL)isEqualToTile:(MemoransTile *)otherTile
{
    if ([[self tileID] isEqualToString:[otherTile tileID]])
    {
        return YES;
    }
    return NO;
}

#pragma mark - NSCopying PROTOCOL

- (id)copyWithZone:(NSZone *)zone
{
    MemoransTile *tileCopy = [[MemoransTile allocWithZone:zone] init];

    tileCopy.tileValue = self.tileValue;
    tileCopy.tileSetType = self.tileSetType;
    tileCopy.selected = self.selected;
    tileCopy.paired = self.paired;

    return tileCopy;
}

#pragma mark - GLOBAL VARS AND CLASS METHODS

const int gMaxTileValue = 20;
const int gMinTileValue = 1;

+ (NSArray *)allowedTileSets { return @[ @"Happy", @"Angry", ]; }

@end
