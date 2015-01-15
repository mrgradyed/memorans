//
//  MemoransScoreOverlayView.m
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
//  Created by emi on 21/07/14.
//
//

#import "MemoransOverlayView.h"
#import "Utilities.h"

@interface MemoransOverlayView ()

#pragma mark - PROPERTIES

// The attributed text displayed by the overlay view.

@property(strong, nonatomic) NSAttributedString *overlayAttributedString;

// The starting center for the overlay views is off-screen.

@property(nonatomic) CGPoint outOfScreenCenter;

@end

@implementation MemoransOverlayView

#pragma mark - SETTERS AND GETTERS

- (void)setOverlayString:(NSString *)overlayString
{
    if ([_overlayString isEqualToString:overlayString])
    {
        // Same overlay text, don't waste time, exit.

        return;
    }

    // Set the new overlay text.

    _overlayString = overlayString;

    // The current attributed overlay text is invalid.

    _overlayAttributedString = nil;

    // Resize the overlay view to accomodate the new text.

    [self resizeView];
}

- (void)setOverlayColor:(UIColor *)overlayColor
{
    if ([_overlayColor isEqual:overlayColor])
    {
        // Same overlay text color, don't waste time, exit.

        return;
    }

    // Set the new text color.

    _overlayColor = overlayColor;

    // The current attributed overlay text is invalid.

    _overlayAttributedString = nil;

    // We need to redraw with the new color.

    [self setNeedsDisplay];
}

- (void)setFontSize:(CGFloat)fontSize
{
    if (_fontSize == fontSize)
    {
        // Same overlay text font size, don't waste time, exit.

        return;
    }

    // Set the new text size.

    _fontSize = fontSize;

    // The current attributed overlay text is invalid.

    _overlayAttributedString = nil;

    // Resize the overlay view to accomodate the new text size.

    [self resizeView];
}

- (NSAttributedString *)overlayAttributedString
{
    if (!_overlayAttributedString)
    {
        // An attributed version of the overlay text is missing.

        // If the overlay text is missing too, set it to a default string.

        NSString *overString = self.overlayString ? self.overlayString : @"!?";

        // Create a nice attributed text with the specified properties.

        _overlayAttributedString = [Utilities styledAttributedStringWithString:overString
                                                                 andAlignement:NSTextAlignmentCenter
                                                                      andColor:self.overlayColor
                                                                       andSize:self.fontSize
                                                                andStrokeColor:nil];
    }

    return _overlayAttributedString;
}

- (CGPoint)outOfScreenCenter
{
    if (_outOfScreenCenter.x == CGPointZero.x || _outOfScreenCenter.y == CGPointZero.y)
    {
        // The starting off-screen center has not been set for the overlay view.

        // Get the screen's bounds.

        CGRect screenBounds = [[UIScreen mainScreen] bounds];

        // Get the controller's view's dimensions.

        CGFloat shortSide = MIN(screenBounds.size.width, screenBounds.size.height);
        CGFloat longSide = MAX(screenBounds.size.width, screenBounds.size.height);

        // Set the off-screen center to be 1 screen to the right off the visible one, but vertically
        // in the middle.

        _outOfScreenCenter = CGPointMake(longSide * 2, shortSide / 2);
    }

    return _outOfScreenCenter;
}

#pragma mark - VIEW DRAWING

- (void)resetView
{
    if (self.center.x != self.outOfScreenCenter.x || self.center.y != self.outOfScreenCenter.y)
    {
        // Stop all animations on this overlay view.

        [self.layer removeAllAnimations];

        // Put the overlay back off-screen.

        self.center = self.outOfScreenCenter;

        // Reset possible fading out effect.

        self.alpha = 1;
    }
}

- (void)resizeView
{
    // Get the actual attributed text size.

    CGSize newSize = [self.overlayAttributedString size];

    // Create a new frame to accomodate the size above.

    CGRect newBounds = self.bounds;

    newBounds.size = newSize;

    // Set the overlay view to have the new size.

    self.bounds = newBounds;

    // We need to redraw the view with the new size.

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // This is a direct UIView subclass, we do not need to call super.

    // Draw the attributed string in the overlay view.

    [self.overlayAttributedString drawInRect:self.bounds];
}

#pragma mark - INIT

- (instancetype)initWithFrame:(CGRect)frame
{
    // The designated initialiser.

    self = [super initWithFrame:frame];

    if (self)
    {
        // Configure this view.

        [self configureView];
    }

    return self;
}

- (void)configureView
{
    // The overlay must have a trasparent background.

    self.backgroundColor = [UIColor clearColor];

    // Redisplay the view when the bounds change.

    self.contentMode = UIViewContentModeRedraw;

    // NO user interaction allowed on the overlay view.

    self.userInteractionEnabled = NO;

    // Be sure it's off screen.

    [self resetView];
}

- (instancetype)initWithString:(NSString *)string
                      andColor:(UIColor *)color
                   andFontSize:(CGFloat)fontSize
{
    // Use the designated initialiser with a zero-size frame.
    // The overlay view will be resized according to parameters.

    self = [self initWithFrame:CGRectZero];

    // Set the specified text.

    _overlayString = string;

    // Set the specified text color.

    _overlayColor = color;

    // Set the specified text font size.

    _fontSize = fontSize;

    // Resize the overlay view according to text's properties.

    [self resizeView];

    return self;
}

@end
