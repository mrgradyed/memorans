//
//  MemoransMenuViewController.m
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
//  Created by emi on 05/08/14.
//
//

#import "MemoransMenuViewController.h"
#import "MemoransBehavior.h"
#import "MemoransTile.h"
#import "MemoransOverlayView.h"
#import "MemoransSharedAudioController.h"
#import "MemoransSharedLocalizationController.h"
#import "Utilities.h"

@interface MemoransMenuViewController () <UIDynamicAnimatorDelegate>

#pragma mark - OUTLETS

// The main menu play button.

@property(weak, nonatomic) IBOutlet UIButton *playButton;

// The main menu music on/off button.

@property(weak, nonatomic) IBOutlet UIButton *musicButton;

// The main menu sounds on/off button.

@property(weak, nonatomic) IBOutlet UIButton *soundEffectsButton;

// The main menu credits button.

@property(weak, nonatomic) IBOutlet UIButton *creditsButton;

// The main menu App Store rate button.

@property(weak, nonatomic) IBOutlet UIButton *rateButton;

// The main menu language button to change app language "on the fly".

@property(weak, nonatomic) IBOutlet UIButton *languageButton;

#pragma mark - PROPERTIES

// A gradient layer for the background.

@property(strong, nonatomic) CAGradientLayer *gradientLayer;

// An animator for the monsters animation.

@property(strong, nonatomic) UIDynamicAnimator *dynamicAnimator;

// An array of "monsters" views for using in the main menu screen animation.

@property(strong, nonatomic) NSMutableArray *monsterViews;

// The shared audio controller to play music and effects.

@property(strong, nonatomic) MemoransSharedAudioController *sharedAudioController;

// The shared localization controller to allow language switching "on the fly".

@property(strong, nonatomic) MemoransSharedLocalizationController *sharedLocalizationController;

@end

@implementation MemoransMenuViewController

#pragma mark - SETTERS AND GETTERS

- (CAGradientLayer *)gradientLayer
{
    if (!_gradientLayer)
    {
        // Get a random gradient for the background.

        _gradientLayer = [Utilities randomGradient];

        // Gradient must cover the whole screen's background.

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

- (MemoransSharedAudioController *)sharedAudioController
{
    if (!_sharedAudioController)
    {
        // Get the shared audio controller instance.

        _sharedAudioController = [MemoransSharedAudioController sharedAudioController];
    }

    return _sharedAudioController;
}

- (MemoransSharedLocalizationController *)sharedLocalizationController
{
    if (!_sharedLocalizationController)
    {
        // Get the shared localization controller instance.

        _sharedLocalizationController =
            [MemoransSharedLocalizationController sharedLocalizationController];
    }
    return _sharedLocalizationController;
}

#pragma mark - ACTIONS AND NAVIGATION

- (IBAction)playButtonTouched
{
    // An audio feedback.

    [self.sharedAudioController playPopSound];

    // Go to the level choice screen.

    [self performSegueWithIdentifier:@"toLevelsController" sender:self];
}

- (IBAction)languageButtonTouched
{
    // An audio feedback.

    [self.sharedAudioController playPopSound];

    // Set the app language to be the next language actually supported by the app,
    // it circularly iterates the list of supported languages starting from the current set one.

    [self.sharedLocalizationController
        setAppLanguage:[self.sharedLocalizationController nextSupportedLanguage]];

    // Change buttons titles according to the new language set.

    [self configureUIButtons];
}

- (IBAction)musicButtonTouched
{
    // An audio feedback.

    [self.sharedAudioController playPopSound];

    // Turn the music ON/OFF in the shared audio controller.

    self.sharedAudioController.musicOff = !self.sharedAudioController.musicOff;

    // Create a string which states the music new status.

    NSString *overMusicOnOff =
        self.sharedAudioController.musicOff
            ? [self.sharedLocalizationController localizedStringForKey:@"Music Off"]
            : [self.sharedLocalizationController localizedStringForKey:@"Music On"];

    // Create an overlay text to notify the user of the change, using the string above.

    MemoransOverlayView *overlayView =
        [[MemoransOverlayView alloc] initWithString:overMusicOnOff andColor:nil andFontSize:150];

    // Add and animate the overlay text.

    [self.view addSubview:overlayView];

    [Utilities animateOverlayView:overlayView withDuration:0.5f];

    // Change the music button's title according to music status.

    NSString *musicOnOff = self.sharedAudioController.musicOff ? @"♬ Off" : @"♬ On";

    [Utilities configureButton:self.musicButton
               withTitleString:[self.sharedLocalizationController localizedStringForKey:musicOnOff]
                   andFontSize:50];
}

- (IBAction)soundEffectsButtonTouched
{
    // An audio feedback. This plays only when sounds are ON.

    [self.sharedAudioController playPopSound];

    // Turn the sounds ON/OFF in the shared audio controller.

    self.sharedAudioController.soundsOff = !self.sharedAudioController.soundsOff;

    // An audio feedback. This plays only if sounds are turned back on.

    [self.sharedAudioController playPopSound];

    // Create a string which states the sounds new status.

    NSString *overSoundsOnOff =
        self.sharedAudioController.soundsOff
            ? [self.sharedLocalizationController localizedStringForKey:@"Sounds Off"]
            : [self.sharedLocalizationController localizedStringForKey:@"Sounds On"];

    // Create an overlay text to notify the user of the change, using the string above.

    MemoransOverlayView *overlayView =
        [[MemoransOverlayView alloc] initWithString:overSoundsOnOff andColor:nil andFontSize:150];

    // Add and animate the overlay text.

    [self.view addSubview:overlayView];

    [Utilities animateOverlayView:overlayView withDuration:0.5f];

    // Change the sounds button's title according to sounds status.

    NSString *soundsOnOff = self.sharedAudioController.soundsOff ? @"♪ Off" : @"♪ On";

    [Utilities configureButton:self.soundEffectsButton
               withTitleString:[self.sharedLocalizationController localizedStringForKey:soundsOnOff]
                   andFontSize:50];
}

- (IBAction)creditsButtonTouched
{
    // An audio feedback.

    [self.sharedAudioController playPopSound];

    // Go to the credits screen.

    [self performSegueWithIdentifier:@"toCreditsController" sender:self];
}

- (IBAction)rateButtonTouched
{
    // An audio feedback.

    [self.sharedAudioController playPopSound];

    // The Memorans App Store page URL. Using "itms-apps" protocol will open it directly with the
    // App Store application.

    NSURL *appURL = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id914969431"];

    // Open the App Store page URL.

    [[UIApplication sharedApplication] openURL:appURL];
}

#pragma mark - VIEWS MANAGEMENT AND UPDATE

- (void)configureUIButtons
{
    // This method styles and configures all the main menu buttons consistently, using an utility
    // method and the shared localized controller to correctly localize the buttons titles.
    
    NSString *currentLangCode = self.sharedLocalizationController.currentLanguageCode;

    [Utilities configureButton:self.languageButton
               withTitleString:[NSString stringWithFormat:@"⚑ %@",currentLangCode.capitalizedString]
                   andFontSize:50];

    [Utilities configureButton:self.playButton
               withTitleString:[self.sharedLocalizationController localizedStringForKey:@"Play"]
                   andFontSize:50];

    // Change the music button's title according to music status.

    NSString *musicOnOff = self.sharedAudioController.musicOff ? @"♬ Off" : @"♬ On";

    [Utilities configureButton:self.musicButton
               withTitleString:[self.sharedLocalizationController localizedStringForKey:musicOnOff]
                   andFontSize:50];

    // Change the sounds button's title according to sounds status.

    NSString *soundsOnOff = self.sharedAudioController.soundsOff ? @"♪ Off" : @"♪ On";

    [Utilities configureButton:self.soundEffectsButton
               withTitleString:[self.sharedLocalizationController localizedStringForKey:soundsOnOff]
                   andFontSize:50];

    [Utilities configureButton:self.creditsButton
               withTitleString:[self.sharedLocalizationController localizedStringForKey:@"Credits"]
                   andFontSize:50];

    [Utilities configureButton:self.rateButton withTitleString:@"★★★★★" andFontSize:50];
}

- (void)viewDidLoad
{
    // This controller’s view was loaded into memory!

    [super viewDidLoad];

    // It's a game, we want all the space available, no navigation bar.

    self.navigationController.navigationBarHidden = YES;

    // NO multiple touch allowed on the main menu screen, one action at time.

    self.view.multipleTouchEnabled = NO;

    // Style and configure the buttons.

    [self configureUIButtons];

    // Get the controller's view's dimensions.

    CGFloat shortSide = MIN(self.view.bounds.size.width, self.view.bounds.size.height);
    CGFloat longSide = MAX(self.view.bounds.size.width, self.view.bounds.size.height);

    // Create a proportional background text. This is the main menu "Memorans" text.

    UILabel *backgroundLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0.8 * longSide, 0.3 * shortSide)];

    // Center the background text in the controller's view.

    backgroundLabel.center = CGPointMake(longSide / 2, shortSide / 2);

    // Set the "Memorans" localized text as the label's text, add the background label to the
    // controller's view.

    backgroundLabel.attributedText =
        [Utilities styledAttributedStringWithString:@"Memorans"
                                      andAlignement:NSTextAlignmentCenter
                                           andColor:[UIColor clearColor]
                                            andSize:150
                                     andStrokeColor:[UIColor blackColor]];

    [self.view addSubview:backgroundLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    // This controller’s view is about to go on screen!

    [super viewWillAppear:animated];

    // Get a dynamic gradient and push it to the very background.

    [self.view.layer insertSublayer:self.gradientLayer atIndex:0];



    // Start playing main menu's music.

    [self.sharedAudioController playMusicFromResource:@"JauntyGumption"
                                               ofType:@"mp3"
                                           withVolume:0.3f];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // Start floating monsters animation.
    
    [self addAndAnimateMonsterViews];
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

#pragma mark - ANIMATIONS

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

    // An image view containing an image of a memorans monster.

    UIImage *monsterImage;
    UIImageView *monsterImageView;

    // X and Y offsets to randomly scatter the monsters on the screen.

    NSInteger monsterViewXOffset;
    NSInteger monsterViewYOffset;

    // An array of monsters images already used, we want no duplicate monsters in the animation.

    NSMutableArray *imageIndexes = [[NSMutableArray alloc] init];
    NSInteger randomImageIndex = 0;

    // We want to animate random monsters images.

    int numberOfMonster = [Utilities isIPad] ? 8 : 4;
    
    for (int i = 0; i < numberOfMonster; i++)
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
        monsterImageView.contentMode = UIViewContentModeRedraw;
        
        if([Utilities isIPad] == NO)
        {
            // On iPhones reduce monsters size..
            CGRect newFrame = monsterImageView.frame;
            newFrame.size.height = newFrame.size.height * 0.4;
            newFrame.size.width = newFrame.size.width * 0.4;
            
            monsterImageView.frame = newFrame;
        }
        
        // Calculate random offsets to slighly scatter the monsters image views.
        // Random offsets will be between 0 and the monsters images' size-1.

        monsterViewXOffset = (arc4random() % (int)monsterImageView.frame.size.width);
        monsterViewYOffset = (arc4random() % (int)monsterImageView.frame.size.height);

        // Change sign to get more random positions.
        if(monsterViewXOffset % 2 == 0) { monsterViewXOffset = -monsterViewXOffset; };
        if(monsterViewYOffset % 2 == 0) { monsterViewYOffset = -monsterViewYOffset; };
        
        // Place the monsters views. Having slight different start positions the views will behavior
        // in more chaotic way when added to the animator.

        monsterImageView.center = CGPointMake(CGRectGetMidX(self.view.bounds) + monsterViewXOffset,
                                              CGRectGetMidY(self.view.bounds) + monsterViewYOffset);
        
        // Add tap gesture to monster views. On tap restart animation.
        UITapGestureRecognizer *tapRecog = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self
                                                        action:@selector(monsterWasTapped)];
        
        tapRecog.numberOfTapsRequired = 1;
        
        monsterImageView.userInteractionEnabled = YES;
        [monsterImageView addGestureRecognizer:tapRecog];

        // Add the monster view just created to the array of the currenty used in the animation.

        [self.monsterViews addObject:monsterImageView];

        // Add the monster view just created to the controller's view.

        [self.view addSubview:monsterImageView];
    }

    // Be sure all the main menu buttons are in foreground. This is to avoid monsters views to
    // animate over buttons.

    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            // If it's a button, push it to the front.

            [self.view bringSubviewToFront:view];
        }
    }

    // Create an instance of the custom behavior, intialised with all the monsters views created.

    MemoransBehavior *memoransBehavior = [[MemoransBehavior alloc] initWithItems:self.monsterViews];

    // Add this behavior to the dynamic animator and start the monsters animation.

    [self.dynamicAnimator addBehavior:memoransBehavior];
}

- (void)monsterWasTapped {

    // When monsters are tapped start a new animation.
    [self addAndAnimateMonsterViews];
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
