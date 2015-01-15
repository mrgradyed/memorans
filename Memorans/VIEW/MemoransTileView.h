//
//  MemoransTileView.h
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
//  Created by emi on 03/07/14.
//
//

#import <UIKit/UIKit.h>

// From Apple docs: The NSCoding protocol declares the two methods that a class
// must implement so that instances of that class can be encoded and decoded. This capability
// provides the basis for archiving.

@interface MemoransTileView : UIView <NSCoding>

#pragma mark - PUBLIC PROPERTIES

// The name of the image displayed by the tile view when face up.

@property(strong, nonatomic) NSString *imageID;

// The name of the image displayed by the tile view when face down.

@property(strong, nonatomic) NSString *tileBackImage;

// Whether to tile view is face up or not.

@property(nonatomic) BOOL shown;

// Whether to tile view represents a paired tile or not.

@property(nonatomic) BOOL paired;

// Whether to tile view represents a chosen tile or not.

@property(nonatomic) BOOL chosen;

// The tile view's center inside the tiles area on screen.

@property(nonatomic) CGPoint onBoardCenter;

@end
