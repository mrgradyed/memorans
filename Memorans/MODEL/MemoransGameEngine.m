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

@property(nonatomic, strong) MemoransTilePile *uniqueTilesPile;
@property(nonatomic, strong) NSMutableArray *tilesInGame;
@property(nonatomic, strong) MemoransTile *previousSelectedTile;
@property(nonatomic) NSInteger gameScore;

@end

@implementation MemoransGameEngine

#pragma mark - SETTERS AND GETTERS
- (NSMutableArray *)tilesInGame
{

    if (!_tilesInGame)
    {
        _tilesInGame = [[NSMutableArray alloc] init];
    }
    return _tilesInGame;
}

#pragma mark - INITIALISERS

// Designated initialiser.
- (instancetype)initGameWithNum:(NSInteger)numOfGameTiles fromTileSet:(NSString *)tileSet
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
        self.uniqueTilesPile = [[MemoransTilePile alloc] initWithSet:tileSet];
    }
    else
    {
        self.uniqueTilesPile = [[MemoransTilePile alloc] init];
    }

    if (numOfGameTiles % 2 != 0 || numOfGameTiles < 4)
    {
        numOfGameTiles = 6;
    }
    // We draw as much tiles from the pile as the number requested
    // The actual number of tiles in game is twice that number.
    for (int i = 0; i < numOfGameTiles / 2; i++)
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

    self = [self initGameWithNum:0 fromTileSet:nil];

    return self;
}

#pragma mark - INSTANCE METHODS

- (void)addPairOfTilesToGame
{
    // Extract one tile from the pile and add it twice to the game tiles.
    MemoransTile *newTile = [self.uniqueTilesPile extractRandomTileFromPile];

    // We need the same tile twice in the game.
    [self.tilesInGame addObject:newTile];
    [self.tilesInGame addObject:[newTile copy]];
}

- (void)shuffleTilesInGame
{
    int numberOfTilesInGame = (int)[self.tilesInGame count];
    int jndex;

    for (int index = numberOfTilesInGame - 1; index > 0; index--)
    {
        jndex = arc4random() % index;
        [self.tilesInGame exchangeObjectAtIndex:jndex withObjectAtIndex:index];
    }
}

- (MemoransTile *)tileOnBoardAtIndex:(NSInteger)tileIndex
{

    if (tileIndex < [self.tilesInGame count])
    {
        return [self.tilesInGame objectAtIndex:tileIndex];
    }
    else
    {
        return nil;
    }
}

- (MemoransTile *)playTileAtIndex:(NSInteger)tileIndex
{
    MemoransTile *selectedTile = self.tilesInGame[tileIndex];

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
