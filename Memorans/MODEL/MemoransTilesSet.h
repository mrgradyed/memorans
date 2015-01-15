//
//  MemoransTilesPile.h
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
//  Created by emi on 02/07/14.
//
//

#import <Foundation/Foundation.h>

@class MemoransTile;

// From Apple docs: The NSCoding protocol declares the two methods that a class must implement so
// that instances of that class can be encoded and decoded. This capability provides the basis for
// archiving.

@interface MemoransTilesSet : NSObject <NSCoding>

#pragma mark - DESIGNATED INITIALISER

// The designated initialiser to create a set of tiles.

- (instancetype)initWithSetType:(NSString *)tileSetType;

#pragma mark - PUBLIC METHODS

// This returns a random tile from the set.
// Usually a game uses a subset of this set of tiles.

- (MemoransTile *)extractRandomTileFromSet;

@end
