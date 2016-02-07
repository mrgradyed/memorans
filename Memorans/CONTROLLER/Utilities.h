//
//  Utilities.h
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
//  Created by emi on 29/07/14.
//
//

#import <Foundation/Foundation.h>

@class MemoransOverlayView;

@interface Utilities : NSObject

#pragma mark - PUBLIC METHODS

// A HEX string to UIColor converter.

+ (UIColor *)colorFromHEXString:(NSString *)hexString withAlpha:(CGFloat)alpha;

// A random color generator that uses a nice palette.

+ (UIColor *)randomNiceColor;

// A random 3-color gradient generator.

+ (CAGradientLayer *)randomGradient;

// This method animates an overlay view, puts it on the center of the screen, fade it, and then
// release it.

+ (void)animateOverlayView:(MemoransOverlayView *)overlayView withDuration:(NSTimeInterval)duration;

// This method adds a wobbling animation to a specified view with an optional delegate.

+ (void)addWobblingAnimationToView:(UIView *)view
                   withRepeatCount:(float)repeatCount
                       andDelegate:(id)delegate;

// This method will help create nice texts throughout the app.

+ (NSAttributedString *)styledAttributedStringWithString:(NSString *)string
                                           andAlignement:(NSTextAlignment)alignement
                                                andColor:(UIColor *)color
                                                 andSize:(CGFloat)size
                                          andStrokeColor:(UIColor *)strokeColor;

// This method will make all the app's buttons look consistently.

+ (void)configureButton:(UIButton *)button
        withTitleString:(NSString *)titleString
            andFontSize:(CGFloat)size;

// A method to play system sounds
// File limitations:
// - No longer than 30 seconds in duration
// - In linear PCM or IMA4 (IMA/ADPCM) format
// - Packaged in a .caf, .aif, or .wav file

+ (void)playSystemSoundEffectFromResource:(NSString *)fileName ofType:(NSString *)fileType;

#pragma mark - SYSTEM UTILITIES

+ (BOOL)isIPad;

@end
