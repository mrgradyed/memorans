//
//  MemoransGameEngine.h
//  Memorans
//
//  Created by emi on 03/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MemoransTile;

@interface MemoransGameEngine : NSObject

#pragma mark - PUBLIC PROPERTIES

@property(nonatomic, readonly) NSInteger gameScore;

#pragma mark - GLOBAL VARS

extern const int pairedBonus;
extern const int notPairedMalus;

#pragma mark - DESIGNATED INITIALISER

- (instancetype)initGameWithNum:(NSInteger)numOfGameTiles fromTileSet:(NSString *)tileSet;

#pragma mark - PUBLIC METHODS

- (MemoransTile *)playTileAtIndex:(NSInteger)tileIndex;

- (MemoransTile *)tileInGameAtIndex:(NSInteger)tileIndex;

@end
