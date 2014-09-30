//
//  MemoransModelTests.m
//  Memorans
//
//  Created by emi on 30/09/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
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

- (void)testPlayGameTileAtIndex
{
    NSInteger numberOfTilesToTest = 12;

    // A game engine with 12 tiles of the first set type.

    MemoransGameEngine *gameEngine =
        [[MemoransGameEngine alloc] initGameWithTilesCount:numberOfTilesToTest
                                                andTileSet:[MemoransTile allowedTileSets][0]];

    int firstTileIndex = 0;
    int secondTileIndex = 0;

    MemoransTile *firstTile = [gameEngine gameTileAtIndex:0];
    MemoransTile *secondTile = nil;

    for (int i = 1; i < numberOfTilesToTest; i++)
    {
        secondTile = [gameEngine gameTileAtIndex:i];

        if ([firstTile isEqualToTile:secondTile])
        {
            secondTileIndex = i;

            break;
        }
    }

    if (!secondTile)
    {
        XCTFail(@"Found a game tile without a its twin. Test: %s", __PRETTY_FUNCTION__);
    }

    int oldScore = gameEngine.gameScore;

    XCTAssertFalse(firstTile.selected);
    XCTAssertFalse(secondTile.selected);

    XCTAssertFalse(firstTile.paired);
    XCTAssertFalse(secondTile.paired);

    [gameEngine playGameTileAtIndex:firstTileIndex];

    XCTAssertTrue(firstTile.selected);
    XCTAssertFalse(secondTile.selected);


    [gameEngine playGameTileAtIndex:secondTileIndex];

    XCTAssertTrue(firstTile.selected);
    XCTAssertTrue(secondTile.selected);

    XCTAssertTrue(firstTile.paired);
    XCTAssertTrue(secondTile.paired);

    XCTAssertGreaterThan(gameEngine.gameScore, oldScore);
}

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
