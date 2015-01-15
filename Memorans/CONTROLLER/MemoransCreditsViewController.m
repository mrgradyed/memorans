//
//  MemoransCreditsViewController.m
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
//  Created by emi on 06/08/14.
//
//

#import "MemoransCreditsViewController.h"
#import "MemoransSharedAudioController.h"
#import "Utilities.h"

@interface MemoransCreditsViewController ()

#pragma mark - OUTLETS

// A button which brings back to the main menu screen.

@property(weak, nonatomic) IBOutlet UIButton *backToMenuButton;

// The credits text view.

@property(weak, nonatomic) IBOutlet UITextView *creditsText;

#pragma mark - PROPERTIES

// A gradient layer for the background.

@property(strong, nonatomic) CAGradientLayer *gradientLayer;

@end

@implementation MemoransCreditsViewController

#pragma mark - SETTERS AND GETTERS

- (CAGradientLayer *)gradientLayer
{
    if (!_gradientLayer)
    {
        // Get a random gradient for the background.

        _gradientLayer = [Utilities randomGradient];

        // Gradient must cover the whole controller's view.

        _gradientLayer.frame = self.view.bounds;
    }

    return _gradientLayer;
}

#pragma mark - ACTIONS AND NAVIGATION

- (IBAction)backToMenuButtonTouched
{
    // An audio feedback.

    [[MemoransSharedAudioController sharedAudioController] playPopSound];

    // Go back to the main menu screen.

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - VIEWS MANAGEMENT AND UPDATE

- (void)viewDidLoad
{
    // This controller’s view was loaded into memory!

    [super viewDidLoad];

    // Configure the "back" button.

    [Utilities configureButton:self.backToMenuButton withTitleString:@"⬅︎" andFontSize:50];

    // The credits text view must not be editable.

    self.creditsText.editable = NO;

    // The credits text view must not be selectable to allow web links to work.

    self.creditsText.selectable = YES;

    // Detect links in the credits text.

    self.creditsText.dataDetectorTypes = UIDataDetectorTypeLink;

    // "Cream" color for the text view background.

    self.creditsText.backgroundColor = [Utilities colorFromHEXString:@"#FFFDD0" withAlpha:1];

    // Make the credits text view to be strongly rounded and with a 1px black border.

    self.creditsText.layer.borderColor =
        [Utilities colorFromHEXString:@"#2B2B2B" withAlpha:1].CGColor;
    self.creditsText.layer.borderWidth = 1;
    self.creditsText.layer.cornerRadius = 90;

    // The credits text view will be behind all other views.

    [self.view sendSubviewToBack:self.creditsText];
}

- (void)viewWillAppear:(BOOL)animated
{
    // This controller’s view is about to go on screen!

    [super viewWillAppear:animated];

    // Get a dynamic gradient and push it to the very background.

    [self.view.layer insertSublayer:self.gradientLayer atIndex:0];

    // Play credits screen's music.

    [[MemoransSharedAudioController sharedAudioController] playMusicFromResource:@"TakeAChance"
                                                                          ofType:@"mp3"
                                                                      withVolume:0.8f];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // This controller’s view has gone OFF screen!

    [super viewDidDisappear:animated];

    // Remove and release the gradient. We'll get a new random one the next time
    // this controller's view will go on screen.

    [self.gradientLayer removeFromSuperlayer];

    self.gradientLayer = nil;
}

- (BOOL)prefersStatusBarHidden
{
    // Yes, we prefer the status bar hidden.

    return YES;
}

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

@end
