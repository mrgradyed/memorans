////
//  MemoransGameEngine.m
//  Memorans
//
//  Created by emi on 03/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransGameEngine.h"
#import "MemoransTilePile.h"
#import "MemoransTile.h"

@interface MemoransGameEngine ()

#pragma mark - PROPERTIES

@property(nonatomic, strong) MemoransTilePile *gamePile;
@property(nonatomic, strong) NSMutableArray *tilesOnBoard;
@property(nonatomic, strong) MemoransTile *previousSelectedTile;
@property(nonatomic) NSInteger gameScore;

@end

@implementation MemoransGameEngine

static const int numberOfUniqueTilesSimultaneouslyInGame = 14;

#pragma mark - SETTERS AND GETTERS
- (NSMutableArray *)tilesOnBoard
{

    if (!_tilesOnBoard)
    {
        _tilesOnBoard = [[NSMutableArray alloc] init];
    }
    return _tilesOnBoard;
}

#pragma mark - INITIALISERS

// Designated initialiser.
- (instancetype)initGameWithTileSet:(NSString *)tileSet
{
    self = [super init];

    if (!self)
    {
        return nil;
    }

    // If the provided tile set is nil we will create a game pile using the first
    // available set.
    if (tileSet)
    {
        self.gamePile = [[MemoransTilePile alloc] initWithSet:tileSet];
    }
    else
    {
        self.gamePile = [[MemoransTilePile alloc] init];
    }

    // We draw as much tiles from the pile as the number requested
    // The actual number of tiles in game is twice that number.
    for (int i = 0; i < numberOfUniqueTilesSimultaneouslyInGame; i++)
    {
        [self addPairOfTilesToGame];
    }

    [self shuffleTilesInGame];

    return self;
}

// Init uses the designated initialiser
// to create a default game with 14(x2) tiles of the first available set.
- (instancetype)init
{
    self = [super init];

    if (!self)
    {
        return nil;
    }

    self = [self initGameWithTileSet:nil];

    return self;
}

#pragma mark - INSTANCE METHODS

- (void)addPairOfTilesToGame
{
    // Extract one tile from the pile and add it twice to the game tiles.
    MemoransTile *newTile = [self.gamePile extractRandomTileFromPile];

    // We need the same tile twice in the game.
    [self.tilesOnBoard addObject:newTile];
    [self.tilesOnBoard addObject:[newTile copy]];
}

- (void)shuffleTilesInGame
{
    NSInteger numberOfTilesInGame = [self.tilesOnBoard count];
    NSInteger tileIndex;

    for (int i = 0; i < numberOfTilesInGame / 2; i += 2)
    {
        tileIndex = (arc4random() % numberOfTilesInGame / 2) + numberOfTilesInGame / 2;

        [self.tilesOnBoard exchangeObjectAtIndex:i withObjectAtIndex:tileIndex];
    }
}

- (MemoransTile *)tileOnBoardAtIndex:(NSInteger)tileIndex
{

    if (tileIndex < [self.tilesOnBoard count])
    {
        return [self.tilesOnBoard objectAtIndex:tileIndex];
    }
    else
    {
        return nil;
    }
}

- (MemoransTile *)playTileAtIndex:(NSInteger)tileIndex
{
    MemoransTile *selectedTile = self.tilesOnBoard[tileIndex];

    // If it's already paired or selected return;
    if (selectedTile.paired || selectedTile.selected)
    {
        return nil;
    }

    selectedTile.selected = YES;

    if (!self.previousSelectedTile)
    {
        self.previousSelectedTile = selectedTile;
    }
    else
    {
        if ([selectedTile isEqualToTile:self.previousSelectedTile])
        {
            self.gameScore += 5;
            selectedTile.paired = YES;
            self.previousSelectedTile.paired = YES;
        }
        else
        {
            self.gameScore -= 2;
            selectedTile.selected = NO;
            self.previousSelectedTile.selected = NO;
        }

        self.previousSelectedTile = nil;
    }

    return selectedTile;
}

@end
