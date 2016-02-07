//
//  Utilities.m
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

@import QuartzCore;
@import AudioToolbox;

#import "Utilities.h"
#import "MemoransOverlayView.h"

@implementation Utilities

#pragma mark - COLORS

+ (UIColor *)colorFromHEXString:(NSString *)hexString withAlpha:(CGFloat)alpha
{
    // A HEX string to UIColor converter.

    if ([hexString hasPrefix:@"#"])
    {
        // If the HEX string has a # prefix, remove it.

        hexString = [hexString substringFromIndex:1];
    }

    if ([hexString length] != 6)
    {
        // The HEX string must be 6 chars now, if not, exit returning nil.

        return nil;
    }

    // Split the HEX string into 3 slices of 2 chars each.

    NSString *red = [hexString substringWithRange:NSMakeRange(0, 2)];
    NSString *green = [hexString substringWithRange:NSMakeRange(2, 2)];
    NSString *blue = [hexString substringWithRange:NSMakeRange(4, 2)];

    // Get a string scanner on the first slice.

    NSScanner *scanner = [NSScanner scannerWithString:red];

    unsigned redInt;

    // Scan the "red" slice of the HEX string.

    if (![scanner scanHexInt:&redInt])
    {
        // Error, no valid hexadecimal integer representation found, return nil.

        return nil;
    }

    // Scan the "green" slice of the HEX string.

    scanner = [NSScanner scannerWithString:green];

    unsigned greenInt;

    if (![scanner scanHexInt:&greenInt])
    {
        // Error, no valid hexadecimal integer representation found, return nil.

        return nil;
    }

    // Scan the "blue" slice of the HEX string.

    scanner = [NSScanner scannerWithString:blue];

    unsigned blueInt;

    if (![scanner scanHexInt:&blueInt])
    {
        // Error, no valid hexadecimal integer representation found, return nil.

        return nil;
    }

    // We got valid red, green and blue values, create and return the UIColor with specified alpha.

    return [UIColor colorWithRed:redInt / 255.0f
                           green:greenInt / 255.0f
                            blue:blueInt / 255.0f
                           alpha:alpha];
}

+ (UIColor *)randomNiceColor
{
    // This method returns a random color in a range of nice ones using HSB coordinates.

    // Random hue from 0 to 359 degrees.

    CGFloat hue = (arc4random() % 360) / 359.0f;

    // Random saturation from 0.0 to 1.0

    CGFloat saturation = (float)arc4random() / UINT32_MAX;

    // Random brightness from 0.0 to 1.0

    CGFloat brightness = (float)arc4random() / UINT32_MAX;

    // Limit saturation and brightness to get a nice colors range.

    saturation = saturation < 0.5 ? 0.5 : saturation;
    brightness = brightness < 0.9 ? 0.9 : brightness;

    // Return a random UIColor.

    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

+ (CAGradientLayer *)randomGradient
{
    // This method provides a nice 3-colors random gradient.

    // Get 3 random colors.

    UIColor *startColor = [Utilities randomNiceColor];
    UIColor *middleColor = [Utilities randomNiceColor];
    UIColor *endColor = [Utilities randomNiceColor];

    // Create a CAGradientLayer object.

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];

    // Set the gradient's colors to be the random ones above, using an array of CGColors.

    gradientLayer.colors =
        @[ (id)startColor.CGColor, (id)middleColor.CGColor, (id)endColor.CGColor ];

    // Set the gradient colors' locations.

    gradientLayer.locations = @[ @(0.0f), @(0.5f), @(1.0f) ];

    // The gradient will be a background gradient, covering its whole frame.

    gradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
    gradientLayer.endPoint = CGPointMake(1.0f, 1.0f);

    // Return this random gradient layer.

    return gradientLayer;
}

#pragma mark - ANIMATION

+ (void)animateOverlayView:(MemoransOverlayView *)overlayView withDuration:(NSTimeInterval)duration
{
    // This method animates an overlay view, puts it on the center of the screen, fade it, and then
    // release it.

    for (UIView *subview in overlayView.superview.subviews)
    {
        // Remove all the others overlay views currently and possibly on screens.
        // We want only the most recent overlay message on screen, no overlapping.

        if ([subview isKindOfClass:[MemoransOverlayView class]] && subview != overlayView)
        {
            // We found an older overlay view on screen, remove it.

            [subview removeFromSuperview];
        }
    }

    // Bring the overlay view to the front.

    [overlayView.superview bringSubviewToFront:overlayView];

    // The overlay view new center will be the center of its super view.

    CGPoint newCenter = CGPointMake(CGRectGetMidX(overlayView.superview.bounds),
                                    CGRectGetMidY(overlayView.superview.bounds));

    // Animate the overlay view from off screen to the center of it.

    [UIView animateWithDuration:0.3f
        animations:^{ overlayView.center = newCenter; }
        completion:^(BOOL finished) {

            // Once in the center of the screen, fade the overlay view out.

            [UIView animateWithDuration:0.3f
                delay:duration
                options:0
                animations:^{ overlayView.alpha = 0; }
                completion:^(BOOL finished) {

                    // Once the overlay view faded out, remove it form the views hierarchy.

                    [overlayView removeFromSuperview];
                }];
        }];
}

+ (void)addWobblingAnimationToView:(UIView *)view
                   withRepeatCount:(float)repeatCount
                       andDelegate:(id)delegate
{
    // This method adds a wobbling animation to a specified view.

    // Create an animation with a rotation effect.
    // KeyPath possible values can be found here:
    // https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreAnimation_guide/Key-ValueCodingExtensions/Key-ValueCodingExtensions.html

    CABasicAnimation *wobbling = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];

    // Set wobbling range.

    [wobbling setFromValue:@(0.08f)];

    [wobbling setToValue:@(-0.08f)];

    // Set single oscillation duration.

    [wobbling setDuration:0.1f];

    // Reverse the animation once finshed.

    [wobbling setAutoreverses:YES];

    // Repeat the whole animation as many times as specified.

    [wobbling setRepeatCount:repeatCount];

    if (delegate)
    {
        // If an animation delegate object is passed, set it.

        wobbling.delegate = delegate;
    }

    // Add a wobbling animation to the view.

    [view.layer addAnimation:wobbling forKey:@"wobbling"];
}

#pragma mark - ATTRIBUTED STRINGS

+ (NSAttributedString *)styledAttributedStringWithString:(NSString *)string
                                           andAlignement:(NSTextAlignment)alignement
                                                andColor:(UIColor *)color
                                                 andSize:(CGFloat)size
                                          andStrokeColor:(UIColor *)strokeColor
{

    // This method will help create nice texts throughout the app.

    // If no text color is passed let's use the default one.

    UIColor *dcolor = color ? color : [Utilities colorFromHEXString:@"#108cff" withAlpha:1];

    // If no text stroke color is passed let's use the default one.

    UIColor *dStrokeColor = strokeColor ? strokeColor : [UIColor whiteColor];

    // If no text size is passed let's use the default one.

    CGFloat adaptedSize = [self isIPad] ? size : size / 2;

    // Get a paragraph style object.

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];

    // Set the text alignement to the one passed.

    paragraphStyle.alignment = alignement;

    // Text wrapping will occur at word boundaries.

    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

    // Return a nicely styled attributed string.

    return [[NSAttributedString alloc]
        initWithString:string
            attributes:@
            {
                NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:adaptedSize],
                NSForegroundColorAttributeName : dcolor,
                NSStrokeWidthAttributeName : @-3,
                NSStrokeColorAttributeName : dStrokeColor,
                NSParagraphStyleAttributeName : paragraphStyle,
            }];
}

#pragma mark - BUTTONS CONFIGURATION

+ (void)configureButton:(UIButton *)button
        withTitleString:(NSString *)titleString
            andFontSize:(CGFloat)size
{
    // This method will make all the app's buttons look consistently.

    // Get an attributed string from the specified title string.

    NSAttributedString *attributedTitle =
        [Utilities styledAttributedStringWithString:titleString
                                      andAlignement:NSTextAlignmentCenter
                                           andColor:nil
                                            andSize:50
                                     andStrokeColor:nil];

    // Set the attributed string as button title.

    [button setAttributedTitle:attributedTitle forState:UIControlStateNormal];

    // A shade of black for the button background.

    button.backgroundColor = [Utilities colorFromHEXString:@"#2B2B2B" withAlpha:1];

    // Single and exclusive touch for the button. After a button is touched we don't want any more
    // touches delivered.

    button.multipleTouchEnabled = NO;
    button.exclusiveTouch = YES;

    // Subviews won't escape the button ROUNDED boundaries.

    button.clipsToBounds = YES;

    // A shade of black for the 1px button border.

    button.layer.borderColor = [Utilities colorFromHEXString:@"#2B2B2B" withAlpha:1].CGColor;
    button.layer.borderWidth = 1;

    // Button must be quite rounded.

    button.layer.cornerRadius = 25;
}

#pragma mark - SYSTEM SOUNDS

+ (void)playSystemSoundEffectFromResource:(NSString *)fileName ofType:(NSString *)fileType
{
    if (!([@[ @"caf", @"aif", @"wav" ] containsObject:fileType]))
    {
        // The file type is not supported by the AudioServicesPlaySystemSound function, exit.

        return;
    }

    // From Apple docs: "Unlike the main queue or queues allocated with
    // dispatch_queue_create(), the global concurrent queues
    // schedule blocks as soon as threads become available(non - FIFO completion order)."

    // Get the the default priority global queue.

    dispatch_queue_t globalDefaultQueue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_async(globalDefaultQueue, ^(void) {

        // The path to the audio file.

        NSString *soundEffectPath =
            [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];

        // Get a CFURL object with the audio file path, get the ownership of this Core Foundation
        // object. IMPORTANT: remember to release it after use.

        CFURLRef soundEffectUrl = CFBridgingRetain([NSURL fileURLWithPath:soundEffectPath]);

        SystemSoundID soundEffect;

        // Create a system sound object associated with the passed audio file.

        AudioServicesCreateSystemSoundID(soundEffectUrl, &soundEffect);

        // Release the Core Foundation URL object.

        CFRelease(soundEffectUrl);

        // Register a callback function that is invoked when a specified system sound finishes
        // playing.

        AudioServicesAddSystemSoundCompletion(soundEffect, NULL, NULL, disposeSoundEffect, NULL);

        // Play the sound.

        AudioServicesPlaySystemSound(soundEffect);
    });
}

void disposeSoundEffect(soundEffect, inClientData)
{
    // From Apple docs: "Unlike the main queue or queues allocated with
    // dispatch_queue_create(), the global concurrent queues
    // schedule blocks as soon as threads become available(non - FIFO completion order)."

    // Get the the default priority global queue.

    dispatch_queue_t globalDefaultQueue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_async(globalDefaultQueue, ^(void) {

        // Dispose of the system sound object.

        AudioServicesDisposeSystemSoundID(soundEffect);
    });
}

#pragma mark - SYSTEM UTILITIES

+ (BOOL)isIPad
{
    NSString *model = [[UIDevice currentDevice] model];

    return [model.lowercaseString rangeOfString:@"ipad"].length;
}

@end
