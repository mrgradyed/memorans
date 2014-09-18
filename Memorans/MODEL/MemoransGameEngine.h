//
//  MemoransGameEngine.h
//  Memorans
//
//  Created by emi on 03/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MemoransTile;

// From Apple docs: The NSCoding protocol declares the two methods that a class must implement so
// that instances of that class can be encoded and decoded. This capability provides the basis for
// archiving

@interface MemoransGameEngine : NSObject <NSCoding>

#pragma mark - PUBLIC PROPERTIES

// The current game score.

@property(nonatomic, readonly) NSInteger gameScore;

// The latest change in the game score.

@property(nonatomic, readonly) NSInteger lastDeltaScore;

// If the user got a lucky choice (that is, getting match 2 tiles never turned face up before).

@property(nonatomic, readonly) BOOL isLucky;

// The number of tile matches in a row without errors.

@property(nonatomic, readonly) NSInteger isCombo;

#pragma mark - DESIGNATED INITIALISER

// The designated initializer for the game engine.

- (instancetype)initGameWithTilesCount:(NSInteger)gameTilesCount andTileSet:(NSString *)tileSetType;

#pragma mark - PUBLIC METHODS

// This method actually play a tile in the game engine (that is, choose and compare).

- (void)playGameTileAtIndex:(NSInteger)tileIndex;

// This returns the tile at a certain position in the "game board".

- (MemoransTile *)gameTileAtIndex:(NSInteger)tileIndex;

@end
