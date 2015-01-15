//
//  MemoransGameLevel.h
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
//  Created by emi on 03/08/14.
//
//

#import <Foundation/Foundation.h>

// From Apple docs: The NSCoding protocol declares the two methods that a class must implement so
// that instances of that class can be encoded and decoded. This capability provides the basis for
// archiving.

@interface MemoransGameLevel : NSObject <NSCoding>

#pragma mark - PUBLIC PROPERTIES

// The type to which a tile belongs (es:"Happy").

@property(strong, nonatomic) NSString *levelType;

// The number of tiles that this level prescribes.

@property(nonatomic) NSInteger tilesInLevel;

// Whether this level has been completed or not.

@property(nonatomic) BOOL completed;

// Whether this level has been partially played and a game has been saved for this level.

@property(nonatomic) BOOL hasSave;

#pragma mark - PUBLIC METHODS

// The numbers of tiles per level.

+ (NSArray *)allowedTilesCountsInLevels;

@end
