//
//  MemoransEndViewController.m
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
//  Created by emi on 21/08/14.
//
//

#import "MemoransEndViewController.h"
#import "MemoransBehavior.h"
#import "MemoransSharedAudioController.h"
#import "MemoransSharedLocalizationController.h"
#import "Utilities.h"

@interface MemoransEndViewController () <UIDynamicAnimatorDelegate>

#pragma mark - OUTLETS

// A button for going back to the main menu screeen.

@property(weak, nonatomic) IBOutlet UIButton *backToRootButton;

#pragma mark - PROPERTIES

// A gradient layer for the background.

@property(strong, nonatomic) CAGradientLayer *gradientLayer;

// An animator for the monsters animation.

@property(strong, nonatomic) UIDynamicAnimator *dynamicAnimator;

// An array of "monsters" views for using in the main menu screen animation.

@property(strong, nonatomic) NSMutableArray *monsterViews;

@end

@implementation MemoransEndViewController

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

- (UIDynamicAnimator *)dynamicAnimator
{
    if (!_dynamicAnimator)
    {
        // Get an dynamic animator to animate monsters views on the main menu screen.

        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

        // Set the animator's delegate to be this controller.

        _dynamicAnimator.delegate = self;
    }

    return _dynamicAnimator;
}

- (NSMutableArray *)monsterViews
{
    if (!_monsterViews)
    {
        // Get a new mutable array to contain monsters views.

        _monsterViews = [[NSMutableArray alloc] init];
    }

    return _monsterViews;
}

#pragma mark - ACTIONS

- (IBAction)backToMenuTouched
{
    // Go back to the main menu screen.

    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - VIEWS MANAGEMENT AND UPDATE

- (void)viewDidLoad
{
    // This controller’s view was loaded into memory!

    [super viewDidLoad];

    [Utilities configureButton:self.backToRootButton withTitleString:@"⬅︎" andFontSize:50];

    // Get the controller's view's dimensions.

    CGFloat shortSide = MIN(self.view.bounds.size.width, self.view.bounds.size.height);
    CGFloat longSide = MAX(self.view.bounds.size.width, self.view.bounds.size.height);

    // Create a proportional text. This is the main menu "The End" main text.

    UILabel *backgroundLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0.8 * longSide, 0.3 * shortSide)];

    // Center the main text in the controller's view.

    backgroundLabel.center = CGPointMake(longSide / 2, shortSide / 2);

    // Set the "The End" localized text as the label's text, add the background label to the
    // controller's view.

    backgroundLabel.attributedText =
        [Utilities styledAttributedStringWithString:
                       [[MemoransSharedLocalizationController sharedLocalizationController]
                           localizedStringForKey:@"The End"]
                                      andAlignement:NSTextAlignmentCenter
                                           andColor:nil
                                            andSize:150
                                     andStrokeColor:nil];

    [self.view addSubview:backgroundLabel];

    // This label must be above the animated monsters image views.

    [self.view bringSubviewToFront:backgroundLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    // This controller’s view is about to go on screen!

    [super viewWillAppear:animated];

    // Get a dynamic gradient and push it to the very background.

    [self.view.layer insertSublayer:self.gradientLayer atIndex:0];

    // Start floating monsters animation.

    [self addAndAnimateMonsterViews];

    // Start playing end screen's music.

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

    // Release the monsters views and the dynamic animator.

    [self.monsterViews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    self.monsterViews = nil;
    self.dynamicAnimator = nil;
}

- (void)addAndAnimateMonsterViews
{
    if ([self.monsterViews count])
    {
        // If monsters views from a previous animation are present, release the monsters views and
        // the dynamic animator. We want new random monsters every time we start the animation.

        [self.monsterViews makeObjectsPerformSelector:@selector(removeFromSuperview)];

        self.monsterViews = nil;
        self.dynamicAnimator = nil;
    }

    // Play an "happy" feedback when starting the animation.

    [[MemoransSharedAudioController sharedAudioController] playIiiiSound];

    // An image view containing an image of a memorans monster.

    UIImage *monsterImage;
    UIImageView *monsterImageView;

    // X and Y offsets to randomly scatter the monsters on the screen.

    NSInteger monsterViewXOffset;
    NSInteger monsterViewYOffset;

    NSMutableArray *imageIndexes = [[NSMutableArray alloc] init];
    NSInteger randomImageIndex = 0;

    // We want to animate 12 random monsters images.

    for (int i = 0; i < 12; i++)
    {
        do
        {
            // The next random monster image's index.

            randomImageIndex = (arc4random() % 20) + 1;

            // If that image index has already been included, repeat until you get a
            // new unused monster image's index.

        } while ([imageIndexes indexOfObject:@(randomImageIndex)] != NSNotFound);

        // Add the monster images's index to the array of the already included ones.

        [imageIndexes addObject:@(randomImageIndex)];

        // The monster's image selected (the monsters images for this animation will all be from the
        // Happy set).

        monsterImage =
            [UIImage imageNamed:[NSString stringWithFormat:@"Happy%d", (int)randomImageIndex]];

        // Get a view with the selected image.

        monsterImageView = [[UIImageView alloc] initWithImage:monsterImage];

        // Calculate random offsets to slighly scatter the monsters image views.
        // Random offsets will be between 0 and the monsters images' size-1.

        monsterViewXOffset = monsterImageView.frame.size.width +
                             (arc4random() % (int)monsterImageView.frame.size.width);

        monsterViewYOffset = monsterImageView.frame.size.height +
                             (arc4random() % (int)monsterImageView.frame.size.height);

        // Place the monsters views. Having slight different start positions the views will behavior
        // in more chaotic way when added to the animator.

        monsterImageView.center = CGPointMake(monsterViewXOffset, monsterViewYOffset);

        // Add the monster view just created to the array of the currenty used in the animation.

        [self.monsterViews addObject:monsterImageView];

        // Add the monster view just created to the controller's view.

        [self.view addSubview:monsterImageView];
    }

    // Be sure all the main menu buttons and the main ""The End" are in foreground. This is to avoid
    // monsters views to animate over other elements.

    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UIButton class]] || [view isKindOfClass:[UILabel class]])
        {
            // If it's a button or a label, push it to the front.

            [self.view bringSubviewToFront:view];
        }
    }

    // Create an instance of the custom behavior, intialised with all the monsters views created.

    MemoransBehavior *memoransBehavior = [[MemoransBehavior alloc] initWithItems:self.monsterViews];

    // Add this behavior to the dynamic animator and start the monsters animation.

    [self.dynamicAnimator addBehavior:memoransBehavior];
}

- (BOOL)prefersStatusBarHidden
{
    // Yes, we prefer the status bar hidden.

    return YES;
}

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

#pragma mark - UIDynamicAnimatorDelegate PROTOCOL

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    // When the monsters animation stops, start a new one.

    [self addAndAnimateMonsterViews];
}

@end
