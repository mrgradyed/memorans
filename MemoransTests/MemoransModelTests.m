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

@interface MemoransModelTests : XCTestCase

@end

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

- (void)testSharedLevelsArchiveLevelsStatus
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
