//
//  MemoransTile.m
//  Memorans
//
//  Created by emi on 01/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransTile.h"

@interface MemoransTile ()

@property(strong, nonatomic) NSString *tileID;

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

- (void)setTileSetType:(NSString *)tileSetType
{
    if ([[MemoransTile allowedTileSets] containsObject:tileSetType])
    {
        _tileSetType = tileSetType;
    }
}

- (NSString *)tileID
{
    if (!_tileID)
    {
        _tileID = [NSString stringWithFormat:@"%@%d", self.tileSetType, (int)self.tileValue];
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
    tileCopy.tileID = self.tileID;
    tileCopy.selected = self.selected;
    tileCopy.paired = self.paired;

    return tileCopy;
}

#pragma mark - NSCoding PROTOCOL

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    if (self)
    {
        _tileValue = [aDecoder decodeIntegerForKey:@"tileValue"];

        _tileSetType = [aDecoder decodeObjectForKey:@"tileSetType"];
        _tileID = [aDecoder decodeObjectForKey:@"tileID"];

        _selected = [aDecoder decodeBoolForKey:@"selected"];
        _paired = [aDecoder decodeBoolForKey:@"paired"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.tileValue forKey:@"tileValue"];

    [aCoder encodeObject:self.tileSetType forKey:@"tileSetType"];
    [aCoder encodeObject:self.tileID forKey:@"tileID"];

    [aCoder encodeBool:self.selected forKey:@"selected"];
    [aCoder encodeBool:self.paired forKey:@"paired"];
}

#pragma mark - GLOBAL VARS AND CLASS METHODS

const int gMaxTileValue = 20;
const int gMinTileValue = 1;

+ (NSArray *)allowedTileSets { return @[ @"Happy", @"Angry", ]; }

@end
