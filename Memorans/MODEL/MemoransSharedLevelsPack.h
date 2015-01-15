//
//  MemoransSharedLevelsPack.h
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

#import <Foundation/Foundation.h>

@class MemoransGameLevel;

@interface MemoransSharedLevelsPack : NSObject

#pragma mark - PUBLIC PROPERTIES

// The array of levels available in the game.

@property(strong, nonatomic) NSArray *levelsPack;

#pragma mark - PUBLIC METHODS

// This method creates an instance of this class once and only once
// for the entire lifetime of the application.
// Do NOT use the init method to create an instance, it will just return an exception.

+ (instancetype)sharedLevelsPack;

// Save the levels status by archiving.

- (BOOL)archiveLevelsStatus;

// Remove the level status from disk (for testing only).

- (BOOL)deleteSavedLevelsStatus;

@end
