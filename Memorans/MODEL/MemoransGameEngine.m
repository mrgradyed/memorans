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

@property(strong, nonatomic) MemoransTile *previousSelectedTile;

@property(strong, nonatomic) NSMutableArray *gameTiles;

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

#pragma mark - GAME TILES HANDLING

- (void)shuffleTilesInGame
{
    int numberOfTilesInGame = (int)[self.gameTiles count];

    int jndex;

    for (int index = numberOfTilesInGame - 1; index > 0; index--)
    {
        jndex = arc4random() % index;

        [self.gameTiles exchangeObjectAtIndex:jndex withObjectAtIndex:index];
    }
}

- (MemoransTile *)gameTileAtIndex:(NSInteger)tileIndex
{
    if (tileIndex < [self.gameTiles count])
    {
        return [self.gameTiles objectAtIndex:tileIndex];
    }
    else
    {
        return nil;
    }
}

#pragma mark - GAMEPLAY

- (NSInteger)pairedBonus
{
    NSInteger tileInGameCount = [self.gameTiles count];

    NSInteger notPairedTilesCount = tileInGameCount - self.pairedTilesInGameCount;

    return (notPairedTilesCount / 2) + (tileInGameCount / 6) + 1;
}

- (NSInteger)notPairedMalus
{
    NSInteger malus = -((self.pairedTilesInGameCount / 2) + 1);

    return malus < -9 ? -9 : malus;
}

- (void)playGameTileAtIndex:(NSInteger)tileIndex
{
    if (tileIndex >= [self.gameTiles count])
    {
        return;
    }

    MemoransTile *selectedTile = self.gameTiles[tileIndex];

    if (selectedTile.paired || selectedTile.selected)
    {
        return;
    }

    selectedTile.selected = YES;
    selectedTile.tilePoints--;

    if (!self.previousSelectedTile)
    {
        self.previousSelectedTile = selectedTile;
    }
    else
    {
        if ([selectedTile isEqualToTile:self.previousSelectedTile])
        {
            NSInteger actualBonus = [self pairedBonus] + (selectedTile.tilePoints +
                                                          self.previousSelectedTile.tilePoints);

            self.gameScore += actualBonus < 3 ? 3 : actualBonus;

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
}

#pragma mark - INIT

- (instancetype)initGameWithTilesCount:(NSInteger)gameTilesCount andTileSet:(NSString *)tileSetType
{
    self = [super init];

    if (self)
    {
        MemoransTilesSet *tilesSet;

        if (tileSetType)
        {
            tilesSet = [[MemoransTilesSet alloc] initWithSetType:tileSetType];
        }
        else
        {
            tilesSet = [[MemoransTilesSet alloc] init];
        }

        if (gameTilesCount % 2 != 0 || gameTilesCount < 4)
        {
            gameTilesCount = 6;
        }

        _gameTiles = [[NSMutableArray alloc] initWithCapacity:gameTilesCount];

        MemoransTile *newTile;

        for (int i = 0; i < gameTilesCount / 2; i++)
        {
            newTile = [tilesSet extractRandomTileFromSet];

            [_gameTiles addObject:newTile];
            [_gameTiles addObject:[newTile copy]];
        }

        [self shuffleTilesInGame];
    }

    return self;
}

- (instancetype)init
{
    self = [super init];

    if (self)
    {
        self = [self initGameWithTilesCount:0 andTileSet:nil];
    }

    return self;
}

#pragma mark - NSCoding PROTOCOL

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    if (self)
    {
        _gameScore = [aDecoder decodeIntegerForKey:@"gameScore"];

        _lastDeltaScore = [aDecoder decodeIntegerForKey:@"lastDeltaScore"];

        _previousSelectedTile = [aDecoder decodeObjectForKey:@"previousSelectedTile"];

        _gameTiles = [aDecoder decodeObjectForKey:@"gameTiles"];

        _pairedTilesInGameCount = [aDecoder decodeIntegerForKey:@"pairedTilesInGameCount"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.gameScore forKey:@"gameScore"];

    [aCoder encodeInteger:self.lastDeltaScore forKey:@"lastDeltaScore"];

    [aCoder encodeObject:self.previousSelectedTile forKey:@"previousSelectedTile"];

    [aCoder encodeObject:self.gameTiles forKey:@"gameTiles"];

    [aCoder encodeInteger:self.pairedTilesInGameCount forKey:@"pairedTilesInGameCount"];
}

@end
