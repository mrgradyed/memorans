////
//  MemoransGameEngine.m
//  Memorans
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.
//
//  Created by emi on 03/07/14.
//
//

#import "MemoransGameEngine.h"
#import "MemoransTilesSet.h"
#import "MemoransTile.h"

@interface MemoransGameEngine ()

#pragma mark - PROPERTIES

// To compare we need 2 tiles, this keeps track of the first tile chosen.

@property(strong, nonatomic) MemoransTile *previousSelectedTile;

// The tiles currently in game.

@property(strong, nonatomic) NSMutableArray *gameTiles;

// The current game score.

@property(nonatomic) NSInteger gameScore;

// The latest change in the game score.

@property(nonatomic) NSInteger lastDeltaScore;

// The number of paired tiles in the current game.

@property(nonatomic) NSInteger pairedTilesInGameCount;

// If the user got a lucky choice (that is, getting match 2 tiles never turned face up before).

@property(nonatomic) BOOL isLucky;

// The number of tile matches in a row without errors.

@property(nonatomic) NSInteger isCombo;

@end

@implementation MemoransGameEngine

#pragma mark - SETTERS AND GETTERS

- (void)setGameScore:(NSInteger)gameScore
{
    // The previous comparison was a match?

    BOOL wasAMatch = self.lastDeltaScore > 0;

    // Update the delta score to be the difference between the old score and the new one we are
    // about to set.

    self.lastDeltaScore = gameScore - _gameScore;

    // The current comparison is a match?

    BOOL isAMatch = self.lastDeltaScore > 0;

    if (wasAMatch && isAMatch)
    {
        // This is a match right after another match, increase the combo counter.

        self.isCombo++;
    }
    else
    {
        // Mismatch! Reset the combo counter.

        self.isCombo = 0;
    }

    // Set the new score and add the possible combo bonus (the number of matches in a row).

    _gameScore = gameScore + self.isCombo;
}

#pragma mark - GAME TILES HANDLING

- (void)shuffleTilesInGame
{
    // To shuffle the tiles at game start we will use the modern version of the Fisher–Yates
    // shuffling algorithm, introduced by Richard Durstenfeld in 1964. More precisely, this is my
    // implementation of that algorithm and can be buggy ;)
    // The original algorithm's time complexity is O(n).

    int numberOfTilesInGame = (int)[self.gameTiles count];

    int jndex;

    for (int index = numberOfTilesInGame - 1; index > 0; index--)
    {
        // For i that goes from n - 1 down to 1, do:

        // Get a random j index between 0 and i - 1.

        jndex = arc4random() % index;

        // Swap the j-th element with the i-th element in the array.

        [self.gameTiles exchangeObjectAtIndex:jndex withObjectAtIndex:index];
    }
}

- (MemoransTile *)gameTileAtIndex:(NSInteger)tileIndex
{
    if (tileIndex < [self.gameTiles count])
    {
        // The index is valid return the tile object at that position in the tiles array.

        return [self.gameTiles objectAtIndex:tileIndex];
    }
    else
    {
        // Out of bounds index, return nil.

        return nil;
    }
}

#pragma mark - GAMEPLAY

- (NSInteger)pairedBonus
{
    // This is the bonus score in case of a tiles match.

    NSInteger tileInGameCount = [self.gameTiles count];

    // The number of unpaired tiles left.

    NSInteger notPairedTilesCount = tileInGameCount - self.pairedTilesInGameCount;

    // The bonus score is always positive. It's proportional to the number of unpaired tiles and to
    // the number of tiles currently in game. That is because more tiles are not paired and more
    // tiles are in game, more difficult is to get a match, so bigger is the bonus.

    return (notPairedTilesCount / 2) + (tileInGameCount / 6) + 1;
}

- (NSInteger)notPairedMalus
{
    // This is the malus score in case of a tiles mismatch.
    // The malus score is always negative and it's proportional to the number of the already paired
    // tiles in the current game. This is because more tiles are paired, less chances of a mismatch
    // are. So if the user gets a mismatch with few unpaired tiles left, the malus is bigger.

    NSInteger malus = -((self.pairedTilesInGameCount / 2) + 1);

    // Put a cap to the max malus score, otherwise the game is too hard to play.

    return malus < -9 ? -9 : malus;
}

- (void)playGameTileAtIndex:(NSInteger)tileIndex
{
    // This method actually play a tile in the game engine (that is, choose and compare).

    if (tileIndex >= [self.gameTiles count])
    {
        // Invalid tile index, exit.

        return;
    }

    // Get the tile object at the position specified.

    MemoransTile *selectedTile = self.gameTiles[tileIndex];

    if (selectedTile.paired || selectedTile.selected)
    {
        // The tile is already paired or selected (face up in the UI), exit.

        return;
    }

    // Set the tile as selected.

    selectedTile.selected = YES;

    // Put a negative value on the tile. This is to produce an additional malus score.
    // More times the user turns a tile face up, less points the user will receive
    // when he/she will pair that tile with its twin. So a good memory is needed to win :)

    selectedTile.tilePoints--;

    if (!self.previousSelectedTile)
    {
        // If we do not have a previously selected tile, then this is the first one.

        self.previousSelectedTile = selectedTile;
    }
    else
    {
        // We have already 2 tiles chosen by the user. Let's compare them.

        if ([selectedTile isEqualToTile:self.previousSelectedTile])
        {
            // The tiles match!

            // Get the additional malus score.

            NSInteger tilesNegativePoints =
                (selectedTile.tilePoints + self.previousSelectedTile.tilePoints);

            // If the user has reduced the tiles points by only 2 (-1 per tile), that means the user
            // got a match at the first time he/she chose those tiles, the user was lucky ;)

            self.isLucky = (tilesNegativePoints >= -2);

            // Calculate the actual bonus, that is, the match bonus minus the negative tiles values.

            NSInteger actualBonus = [self pairedBonus] + tilesNegativePoints;

            // Update the score.

            self.gameScore += actualBonus < 3 ? 3 : actualBonus;

            // Set the second chosen tile to be paired.

            selectedTile.paired = YES;

            // Set the first chosen tile to be paired.

            self.previousSelectedTile.paired = YES;

            // Increase the paired tiles counter.

            self.pairedTilesInGameCount += 2;
        }
        else
        {
            // Mismatch!! The tiles are different ones.

            self.gameScore += [self notPairedMalus];

            // Unselect the first chosen tile.

            selectedTile.selected = NO;

            // Unselect the second chosen tile.

            self.previousSelectedTile.selected = NO;
        }

        // Play action ended, we have no chosen tiles.

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
            // A tile set type was specified, create a tiles Set with that type.

            tilesSet = [[MemoransTilesSet alloc] initWithSetType:tileSetType];
        }
        else
        {
            // A tile set type was NOT specified, create a tiles Set with the default type.

            tilesSet = [[MemoransTilesSet alloc] init];
        }

        if (gameTilesCount % 2 != 0 || gameTilesCount < 4)
        {
            // The tiles count is not pair, or it is less than 4, set it to be at least 6.

            gameTilesCount = 6;
        }

        // Create an array to contain game tiles objects.

        _gameTiles = [[NSMutableArray alloc] initWithCapacity:gameTilesCount];

        MemoransTile *newTile;

        for (int i = 0; i < gameTilesCount / 2; i++)
        {
            // Get a random tile object from the Tiles Set.

            newTile = [tilesSet extractRandomTileFromSet];

            // Add 2 copies of that object to the game tiles array.

            [_gameTiles addObject:newTile];
            [_gameTiles addObject:[newTile copy]];
        }

        // All the tiles have been added to the game, shuffle them.

        [self shuffleTilesInGame];
    }

    return self;
}

- (instancetype)init
{
    self = [super init];

    if (self)
    {
        // Use the designated initialiser to create a game with the default parameters.

        self = [self initGameWithTilesCount:0 andTileSet:nil];
    }

    return self;
}

#pragma mark - NSCoding PROTOCOL

// From Apple docs: The NSCoding protocol declares the two methods that a class
// must implement so that instances of that class can be encoded and decoded. This capability
// provides the basis for archiving.

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{

    self = [super init];

    if (self)
    {
        // Reload previous saved game score and tiles status.

        _gameScore = [aDecoder decodeIntegerForKey:@"gameScore"];

        _previousSelectedTile = [aDecoder decodeObjectForKey:@"previousSelectedTile"];

        _gameTiles = [aDecoder decodeObjectForKey:@"gameTiles"];

        _pairedTilesInGameCount = [aDecoder decodeIntegerForKey:@"pairedTilesInGameCount"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    // Save the current game score and the current tiles status.

    [aCoder encodeInteger:self.gameScore forKey:@"gameScore"];

    [aCoder encodeObject:self.previousSelectedTile forKey:@"previousSelectedTile"];

    [aCoder encodeObject:self.gameTiles forKey:@"gameTiles"];

    [aCoder encodeInteger:self.pairedTilesInGameCount forKey:@"pairedTilesInGameCount"];
}

@end
