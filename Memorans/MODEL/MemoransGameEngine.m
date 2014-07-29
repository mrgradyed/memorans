////
//  MemoransGameEngine.m
//  Memorans
//
//  Created by emi on 03/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransGameEngine.h"
#import "MemoransTilesSet.h"
#import "MemoransTile.h"

@interface MemoransGameEngine ()

#pragma mark - PROPERTIES

@property(nonatomic, strong) MemoransTile *previousSelectedTile;

@property(nonatomic, strong) MemoransTilesSet *tilesSet;

@property(nonatomic, strong) NSMutableArray *tilesInGame;

@property(nonatomic) NSInteger gameScore;
@property(nonatomic) NSInteger lastDeltaScore;
@property(nonatomic) NSInteger pairedTilesInGameCount;

@end

@implementation MemoransGameEngine

#pragma mark - SETTERS AND GETTERS

- (void)setGameScore:(NSInteger)gameScore
{
    self.lastDeltaScore = gameScore - _gameScore;

    _gameScore = gameScore;
}

- (NSMutableArray *)tilesInGame
{
    if (!_tilesInGame)
    {
        _tilesInGame = [[NSMutableArray alloc] init];
    }
    return _tilesInGame;
}

#pragma mark - IN-GAME TILES HANDLING

- (void)addPairOfTilesToGame
{
    MemoransTile *newTile = [self.tilesSet extractRandomTileFromSet];

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

- (MemoransTile *)tileInGameAtIndex:(NSInteger)tileIndex
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

#pragma mark - GAMEPLAY

- (NSInteger)pairedBonus
{
    NSInteger notPairedTilesCount = [self.tilesInGame count] - self.pairedTilesInGameCount;

    return notPairedTilesCount / 2;
}

- (NSInteger)notPairedMalus { return -((self.pairedTilesInGameCount / 3) + 1); }

- (MemoransTile *)playTileAtIndex:(NSInteger)tileIndex
{
    MemoransTile *selectedTile = self.tilesInGame[tileIndex];

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
            self.gameScore += [self pairedBonus];

            selectedTile.paired = YES;
            self.previousSelectedTile.paired = YES;

            self.pairedTilesInGameCount += 2;
        }
        else
        {
            self.gameScore += [self notPairedMalus];

            selectedTile.selected = NO;
            self.previousSelectedTile.selected = NO;
        }

        self.previousSelectedTile = nil;
    }
    return selectedTile;
}

#pragma mark - INITIALISERS

- (instancetype)initGameWithTilesCount:(NSInteger)gameTilesCount andTileSet:(NSString *)tileSetType
{
    self = [super init];

    if (!self)
    {
        return nil;
    }

    if (tileSetType)
    {
        self.tilesSet = [[MemoransTilesSet alloc] initWithSet:tileSetType];
    }
    else
    {
        self.tilesSet = [[MemoransTilesSet alloc] init];
    }

    if (gameTilesCount % 2 != 0 || gameTilesCount < 4)
    {
        gameTilesCount = 6;
    }

    for (int i = 0; i < gameTilesCount / 2; i++)
    {
        [self addPairOfTilesToGame];
    }

    [self shuffleTilesInGame];

    self.tilesSet = nil;

    return self;
}

- (instancetype)init
{
    self = [super init];

    if (!self)
    {
        return nil;
    }

    self = [self initGameWithTilesCount:0 andTileSet:nil];

    return self;
}

@end
