//
//  MemoransModelTests.m
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
//  Created by emi on 30/09/14.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MemoransSharedLevelsPack.h"
#import "MemoransGameLevel.h"
#import "MemoransGameEngine.h"
#import "MemoransTile.h"

@interface MemoransModelTests : XCTestCase

@end

#pragma mark - SharedLevelsPack tests

@implementation MemoransModelTests

- (void)testSharedLevelsPackInitReturnsException
{
    // Test if the init method of SharedLevelsPack singleton class returns an exception.

    XCTAssertThrowsSpecificNamed([[MemoransSharedLevelsPack alloc] init], NSException,
                                 @"SingletonException", @"It should have returned an exception.");
}

- (void)testSharedLevelsPackReturnsACorrectInstance
{
    // Test if the class method sharedLevelsPack returns an instance of SharedLevelsPack singleton.

    XCTAssertTrue([[MemoransSharedLevelsPack sharedLevelsPack]
                      isKindOfClass:[MemoransSharedLevelsPack class]],
                  @"A SharedLevelsPack object has NOT been returned.");
}

- (void)testArchiveLevelsStatus
{
    // Delete any previous save file.

    [[MemoransSharedLevelsPack sharedLevelsPack] deleteSavedLevelsStatus];

    // Save levels status in a new file.

    [[MemoransSharedLevelsPack sharedLevelsPack] archiveLevelsStatus];

    // Get the folder where the save file should have been created.

    NSString *documentDirectory =
        NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];

    // Has the save file been created?

    BOOL saveFileExists = [[NSFileManager defaultManager]
        fileExistsAtPath:[documentDirectory
                             stringByAppendingPathComponent:@"levelsStatus.archive"]];

    XCTAssertTrue(saveFileExists, @"Save file has NOT been created.");
}

- (void)testLevelsAreOfTheCorrectKind
{
    for (MemoransGameLevel *level in [[MemoransSharedLevelsPack sharedLevelsPack] levelsPack])
    {
        XCTAssertTrue([level isKindOfClass:[MemoransGameLevel class]],
                      @"The levelsPack does NOT contains MemoransGameLevel objects.");
    }
}

#pragma mark - GameEngine tests

- (void)testGameTilesType
{
    NSInteger numberOfTilesToTest = 12;

    // A game engine with 12 tiles of the first set type.

    MemoransGameEngine *gameEngine =
        [[MemoransGameEngine alloc] initGameWithTilesCount:numberOfTilesToTest
                                                andTileSet:[MemoransTile allowedTileSets][0]];

    MemoransTile *tile = nil;

    for (int i = 0; i < numberOfTilesToTest; i++)
    {
        // For each tile in game check if it's of the correct type.

        tile = [gameEngine gameTileAtIndex:i];

        XCTAssertEqual(tile.tileSetType, [MemoransTile allowedTileSets][0],
                       @"Tile type is NOT the requested one.");
    }
}

- (void)testGameTileAtIndex
{
    NSInteger numberOfTilesToTest = 12;

    // A game engine with 12 tiles of the first set type.

    MemoransGameEngine *gameEngine =
        [[MemoransGameEngine alloc] initGameWithTilesCount:numberOfTilesToTest
                                                andTileSet:[MemoransTile allowedTileSets][0]];

    for (int i = 0; i < numberOfTilesToTest; i++)
    {
        // gameTileAtIndex should return a tile object if the requested tile has an VALID index.

        XCTAssertNotNil([gameEngine gameTileAtIndex:i], @"This tile object should NOT be nil.");
    }

    // gameTileAtIndex should return nil if the requested tile has an INVALID index.

    XCTAssertNil([gameEngine gameTileAtIndex:-1], @"This tile object should be nil.");

    XCTAssertNil([gameEngine gameTileAtIndex:1000], @"This tile object should be nil.");
}

- (void)testPlayGameTileAtIndexWithMatchingTiles
{
    NSInteger numberOfTilesToTest = 12;

    // A game engine with 12 tiles of the first set type.

    MemoransGameEngine *gameEngine =
        [[MemoransGameEngine alloc] initGameWithTilesCount:numberOfTilesToTest
                                                andTileSet:[MemoransTile allowedTileSets][0]];

    // We need 2 identical tiles to be played.

    int firstTileIndex = 0;
    int secondTileIndex = 0;

    // We pick the first tile in game.

    MemoransTile *firstTile = [gameEngine gameTileAtIndex:0];
    MemoransTile *secondTile = nil;

    // Look for its twin tile (Level are randomized).

    for (int i = 1; i < numberOfTilesToTest; i++)
    {
        secondTile = [gameEngine gameTileAtIndex:i];

        if ([firstTile isEqualToTile:secondTile])
        {

            // We found its twin tile, which will be our second tile to play.

            secondTileIndex = i;

            break;
        }
    }

    if (!secondTile)
    {
        // We didn't find a twin tile for the first tile in the game, something is very wrong, fail.

        XCTFail(@"Found a game tile without a its twin. Test: %s", __PRETTY_FUNCTION__);
    }

    // Unplayed tiles should be unselected.

    XCTAssertFalse(firstTile.paired, @"Tile should be unselected if not yet played.");
    XCTAssertFalse(secondTile.paired, @"Tile should be unselected if not yet played.");

    // Unplayed tiles should be unpaired.

    XCTAssertFalse(firstTile.paired, @"Tile should be unpaired if not yet played.");
    XCTAssertFalse(secondTile.paired, @"Tile should be unpaired if not yet played.");

    // The score before playing the tiles.

    NSInteger oldScore = gameEngine.gameScore;

    // Play the twin tiles.

    [gameEngine playGameTileAtIndex:firstTileIndex];
    [gameEngine playGameTileAtIndex:secondTileIndex];

    // Played matched tiles should be paired.

    XCTAssertTrue(firstTile.paired, @"Tile should be paired at this point.");
    XCTAssertTrue(secondTile.paired, @"Tile should be paired at this point.");

    // After a match, delta score should be positive and the score should be incremented.

    XCTAssertGreaterThan(gameEngine.lastDeltaScore, 0,
                         @"A match should always produce a positive delta score.");
    XCTAssertGreaterThan(gameEngine.gameScore, oldScore,
                         @"A match should always produce a score increment.");
}

- (void)testPlayGameTileAtIndexWithMismatchingTiles
{
    NSInteger numberOfTilesToTest = 12;

    // A game engine with 12 tiles of the first set type.

    MemoransGameEngine *gameEngine =
        [[MemoransGameEngine alloc] initGameWithTilesCount:numberOfTilesToTest
                                                andTileSet:[MemoransTile allowedTileSets][0]];

    // We need 2 unmatchable tiles to be played.

    int firstTileIndex = 0;
    int secondTileIndex = 0;

    // We pick the first tile in game.

    MemoransTile *firstTile = [gameEngine gameTileAtIndex:0];
    MemoransTile *secondTile = nil;

    // Look for a different tile (Level are randomized).

    for (int i = 1; i < numberOfTilesToTest; i++)
    {
        secondTile = [gameEngine gameTileAtIndex:i];

        if (![firstTile isEqualToTile:secondTile])
        {
            // We found a different unmatchable tile, which will be our second tile to play.

            secondTileIndex = i;

            break;
        }
    }

    // Unplayed tiles should be unselected.

    XCTAssertFalse(firstTile.paired, @"Tile should be unselected if not yet played.");
    XCTAssertFalse(secondTile.paired, @"Tile should be unselected if not yet played.");

    // Unplayed tiles should be unpaired.

    XCTAssertFalse(firstTile.paired, @"Tile should be unpaired if not yet played.");
    XCTAssertFalse(secondTile.paired, @"Tile should be unpaired if not yet played.");

    // The score before playing the tiles.

    NSInteger oldScore = gameEngine.gameScore;

    // Play the mismatching tiles.

    [gameEngine playGameTileAtIndex:firstTileIndex];
    [gameEngine playGameTileAtIndex:secondTileIndex];

    XCTAssertFalse(firstTile.selected);
    XCTAssertFalse(secondTile.selected);

    // Mismatching tiles should be unpaired after play.

    XCTAssertFalse(firstTile.paired, @"Tile should be NOT paired at this point.");
    XCTAssertFalse(secondTile.paired, @"Tile should be NOT paired at this point.");

    // After a mismatch, delta score should be negative and the score should be decremented.

    XCTAssertLessThan(gameEngine.lastDeltaScore, 0);
    XCTAssertLessThan(gameEngine.gameScore, oldScore);
}

#pragma mark - Tests setup

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the
    // class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the
    // class.
    [super tearDown];
}

@end
