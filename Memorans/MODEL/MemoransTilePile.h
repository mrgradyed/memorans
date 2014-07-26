//
//  MemoransTilesPile.h
//  Memorans
//
//  Created by emi on 02/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MemoransTile;

@interface MemoransTilePile : NSObject

#pragma mark - DESIGNATED INITIALISER

- (instancetype)initWithSet:(NSString *)tileSet;

#pragma mark - PUBLIC METHODS

- (MemoransTile *)extractRandomTileFromPile;

@end
