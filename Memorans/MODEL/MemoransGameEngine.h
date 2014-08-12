//
//  MemoransGameEngine.h
//  Memorans
//
//  Created by emi on 03/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MemoransTile;

@interface MemoransGameEngine : NSObject <NSCoding>

#pragma mark - PUBLIC PROPERTIES

@property(nonatomic, readonly) NSInteger gameScore;
@property(nonatomic, readonly) NSInteger lastDeltaScore;

#pragma mark - DESIGNATED INITIALISER

- (instancetype)initGameWithTilesCount:(NSInteger)gameTilesCount andTileSet:(NSString *)tileSetType;

#pragma mark - PUBLIC METHODS

- (void)playGameTileAtIndex:(NSInteger)tileIndex;

- (MemoransTile *)gameTileAtIndex:(NSInteger)tileIndex;

@end
