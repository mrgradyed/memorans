//
//  MemoransTile.h
//  Memorans
//
//  Created by emi on 01/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemoransTile : NSObject <NSCopying>

#pragma mark - PROPERTIES

// Tile's value, used for matching tiles.
@property(nonatomic) NSInteger tileValue;

// Tile can be of different types or styles, depending on what they display.
@property(nonatomic) NSString *tileSet;

// This flag is set to YES if tile is current selected.
@property(nonatomic) BOOL selected;

// This flag is to check if the tile has been correctly paired with its "twin".
@property(nonatomic) BOOL paired;

#pragma mark - CLASS METHODS

// This returns the min allowed tile value.
+ (NSInteger)minTileValue;

// This returns the max allowed tile value.
+ (NSInteger)maxTileValue;

// This returns the only allowed tile type strings.
+ (NSArray *)allowedTileSets;

#pragma mark - INSTANCE METHODS

- (NSString *)tileContent;

- (BOOL)isEqualToTile:(MemoransTile *)otherTile;

@end
