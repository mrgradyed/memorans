//
//  MemoransLevelView.m
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
//  Created by emi on 31/07/14.
//
//

#import "MemoransLevelButton.h"
#import "Utilities.h"

@interface MemoransLevelButton ()

#pragma mark - PROPERTIES

// An image view to be displayed on top of the level buttons to indicate that the level is locked.

@property(strong, nonatomic) UIImageView *overlayLockView;

@end

@implementation MemoransLevelButton

#pragma mark - SETTERS AND GETTERS

- (UIView *)overlayLockView
{
    if (!_overlayLockView)
    {
        // Create the overlay view with a an image of a lock.

        _overlayLockView = [[UIImageView alloc] initWithFrame:self.bounds];

        _overlayLockView.image = [UIImage imageNamed:@"lock"];
    }

    return _overlayLockView;
}

#pragma mark - VIEW DRAWING

- (void)drawRect:(CGRect)rect
{
    // This is NOT a direct UIView subclass, we should call super.

    [super drawRect:rect];

    if (self.enabled)
    {
        // This level is unlocked, enable user's interaction.

        self.userInteractionEnabled = YES;

        // Remove the overlay view containinig the lock image, and be sure it's released.

        [self.overlayLockView removeFromSuperview];

        self.overlayLockView = nil;
    }
    else
    {
        // This level is currently LOCKED. Disable user's interaction.

        self.userInteractionEnabled = NO;

        // Add the lock image in top of the level button.

        [self addSubview:self.overlayLockView];
    }
}

#pragma mark - INIT

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    // The level buttons will be unarchived from the storyboard,
    // so we need to implement custom initialization in this method.

    // The superclass (UIView) implements the NSCoding protocol, so we should call super.

    self = [super initWithCoder:aDecoder];

    if (self)
    {
        // Configure this view.

        [self configureView];
    }

    return self;
}

- (void)configureView
{
    // Transparent background.

    self.backgroundColor = [UIColor clearColor];

    // Redisplay the view when the bounds change.

    self.contentMode = UIViewContentModeRedraw;

    // We want just tapping available.

    self.multipleTouchEnabled = NO;

    // Exclusive touch for the level buttons.

    self.exclusiveTouch = YES;

    // Subviews won't escape the button ROUNDED boundaries.

    self.clipsToBounds = YES;

    // 1px black border around buttons.

    self.layer.borderColor = [Utilities colorFromHEXString:@"#2B2B2B" withAlpha:1].CGColor;
    self.layer.borderWidth = 1;

    // Level buttons are slightly roundes.

    self.layer.cornerRadius = 15;
}

@end
