//
//  MemoransTile.m
//  Memorans
//
//  Created by emi on 01/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransTile.h"

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
    if ([MemoransTile minTileValue] <= tileValue <= [MemoransTile maxTileValue])
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

#pragma mark - CLASS METHODS

+ (NSInteger)maxTileValue { return 20; }

+ (NSInteger)minTileValue { return 1; }

+ (NSArray *)allowedTileSets { return @[ @"a", @"b" ]; }

#pragma mark - INSTANCE METHODS

- (NSString *)tileContent
{
    return [NSString stringWithFormat:@"%@%ld", self.tileSet, (long)self.tileValue];
}

- (BOOL)isEqualToTile:(MemoransTile *)otherTile
{
    if ([[self tileContent] isEqualToString:[otherTile tileContent]])
    {
        return YES;
    }
    return NO;
}

@end
