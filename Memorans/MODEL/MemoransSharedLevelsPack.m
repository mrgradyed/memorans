//
//  MemoransSharedLevelsPack.m
//  Memorans
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by emi on 03/08/14.
//
//

#import "MemoransSharedLevelsPack.h"
#import "MemoransGameLevel.h"
#import "MemoransTile.h"

@implementation MemoransSharedLevelsPack

#pragma mark - CLASS METHODS

+ (instancetype)sharedLevelsPack
{
    // The class method which actually creates the singleton.

    // The static variable which will hold the single and only instance of this class.

    static MemoransSharedLevelsPack *sharedLevelsPack;

    static dispatch_once_t blockHasCompleted;

    // Create an instance of this class once and only once for the lifetime of the application.

    dispatch_once(&blockHasCompleted, ^{ sharedLevelsPack = [[self alloc] initActually]; });

    return sharedLevelsPack;
}

#pragma mark - INIT

- (instancetype)init
{
    // Return an exception if someone try to use the default init
    // instead of creating a singleton by using the class method.
    NSString *exceptionString =
        [NSString stringWithFormat:@"Please use: [%@ sharedInstance] instead.", NSStringFromClass([self class])];

    @throw [NSException exceptionWithName:@"SingletonException" reason:exceptionString userInfo:nil];

    return nil;
}

- (instancetype)initActually
{
    // The actual (private) init method used by the class method to create a singleton.

    self = [super init];

    if (self)
    {
        // Reload the levels array from disk.

        _levelsPack = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePathForArchiving]];

        if (!_levelsPack)
        {
            // No saved levels array was found on disk, create a one.

            NSMutableArray *pack = [[NSMutableArray alloc] init];

            MemoransGameLevel *newLevel;

            int loopCount = 0;

            NSInteger tileSetTypeIndex;

            for (NSNumber *tilesInLevel in [MemoransGameLevel allowedTilesCountsInLevels])
            {
                // For each level allowed by the game.

                // Create a new level object.

                newLevel = [[MemoransGameLevel alloc] init];

                // Set the number of tiles this level prescribes.

                newLevel.tilesInLevel = [tilesInLevel integerValue];

                // Set the level type (es: "Happy"). Alternate the level types, that is, one
                // "Happy", one Angry, and so on.

                tileSetTypeIndex = loopCount % [[MemoransTile allowedTileSets] count];

                newLevel.levelType = [MemoransTile allowedTileSets][tileSetTypeIndex];

                // Add the newly created object to the levels array.

                [pack addObject:newLevel];

                loopCount++;
            }

            // Set the levels array instance varialble.

            _levelsPack = pack;
        }
    }

    return self;
}

#pragma mark - ARCHIVING

- (NSString *)filePathForArchiving
{
    // User's documents folder in the app sandbox.

    NSString *documentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];

    // Return a path to the levelsStatus.archive file in the user's documents folder.

    return [documentDirectory stringByAppendingPathComponent:@"levelsStatus.archive"];
}

- (BOOL)archiveLevelsStatus
{
    // Archive levels starting from the array.

    return [NSKeyedArchiver archiveRootObject:self.levelsPack toFile:[self filePathForArchiving]];
}

- (BOOL)deleteSavedLevelsStatus
{
    // Get a file manager.

    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSError *error;

    // Remove the file with the saved levels status from disk.

    return [fileManager removeItemAtPath:[self filePathForArchiving] error:&error];
}

@end
