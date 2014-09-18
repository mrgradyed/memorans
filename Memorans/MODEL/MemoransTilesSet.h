//
//  MemoransTilesPile.h
//  Memorans
//
//  Created by emi on 02/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MemoransTile;

// From Apple docs: The NSCoding protocol declares the two methods that a class must implement so
// that instances of that class can be encoded and decoded. This capability provides the basis for
// archiving.

@interface MemoransTilesSet : NSObject <NSCoding>

#pragma mark - DESIGNATED INITIALISER

// The designated initialiser to create a set of tiles.

- (instancetype)initWithSetType:(NSString *)tileSetType;

#pragma mark - PUBLIC METHODS

// This returns a random tile from the set.
// Usually a game uses a subset of this set of tiles.

- (MemoransTile *)extractRandomTileFromSet;

@end
