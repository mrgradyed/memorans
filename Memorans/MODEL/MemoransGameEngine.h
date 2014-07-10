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

#pragma mark - PROPERTIES

@property(nonatomic, readonly) NSInteger gameScore;



#pragma mark - INITIALISERS

// Designated initialiser.
- (instancetype)initGameWithTileSet:(NSString *)tileSet;

#pragma mark - INSTANCE METHODS

- (void)playTileAtIndex:(NSInteger)tileIndex;

- (MemoransTile *)tileOnBoardAtIndex:(NSInteger)tileIndex;

@end
