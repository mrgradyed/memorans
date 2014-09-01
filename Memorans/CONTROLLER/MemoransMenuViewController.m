//
//  MemoransMenuViewController.m
//  Memorans
//
//  Created by emi on 05/08/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
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

@property(weak, nonatomic) IBOutlet UIButton *playButton;
@property(weak, nonatomic) IBOutlet UIButton *musicButton;
@property(weak, nonatomic) IBOutlet UIButton *creditsButton;
@property(weak, nonatomic) IBOutlet UIButton *soundEffectsButton;
@property(weak, nonatomic) IBOutlet UIButton *fbButton;
@property(weak, nonatomic) IBOutlet UIButton *rateButton;
@property(weak, nonatomic) IBOutlet UIButton *languageButton;

#pragma mark - PROPERTIES

@property(strong, nonatomic) CAGradientLayer *gradientLayer;

@property(strong, nonatomic) UIDynamicAnimator *dynamicAnimator;

@property(strong, nonatomic) NSMutableArray *monsterViews;

@property(strong, nonatomic) AVAudioPlayer *musicPlayer;

@property(strong, nonatomic) MemoransSharedAudioController *sharedAudioController;

@property(strong, nonatomic) MemoransSharedLocalizationController *sharedLocalizationController;

@end

@implementation MemoransMenuViewController

#pragma mark - SETTERS AND GETTERS

- (CAGradientLayer *)gradientLayer
{
    if (!_gradientLayer)
    {
        _gradientLayer = [Utilities randomGradient];

        _gradientLayer.frame = self.view.bounds;
    }

    return _gradientLayer;
}

- (UIDynamicAnimator *)dynamicAnimator
{
    if (!_dynamicAnimator)
    {
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        _dynamicAnimator.delegate = self;
    }

    return _dynamicAnimator;
}

- (NSMutableArray *)monsterViews
{
    if (!_monsterViews)
    {
        _monsterViews = [[NSMutableArray alloc] init];
    }

    return _monsterViews;
}

- (MemoransSharedAudioController *)sharedAudioController
{
    if (!_sharedAudioController)
    {
        _sharedAudioController = [MemoransSharedAudioController sharedAudioController];
    }

    return _sharedAudioController;
}

- (MemoransSharedLocalizationController *)sharedLocalizationController
{
    if (!_sharedLocalizationController)
    {
        _sharedLocalizationController =
            [MemoransSharedLocalizationController sharedLocalizationController];
    }
    return _sharedLocalizationController;
}

#pragma mark - ACTIONS AND NAVIGATION

- (IBAction)playButtonTouched
{
    [self.sharedAudioController playPopSound];

    [self performSegueWithIdentifier:@"toLevelsController" sender:self];
}

- (IBAction)languageButtonTouched
{
    [self.sharedLocalizationController
        setAppLanguage:[self.sharedLocalizationController nextSupportedLanguage]];

    [self configureUIButtons];
}

- (IBAction)musicButtonTouched
{
    self.sharedAudioController.musicOff = !self.sharedAudioController.musicOff;

    [self.sharedAudioController playPopSound];

    NSString *overMusicOnOff =
        self.sharedAudioController.musicOff
            ? [self.sharedLocalizationController localizedStringForKey:@"Music Off"]
            : [self.sharedLocalizationController localizedStringForKey:@"Music On"];

    MemoransOverlayView *overlayView =
        [[MemoransOverlayView alloc] initWithString:overMusicOnOff andColor:nil andFontSize:150];

    [self.view addSubview:overlayView];

    [Utilities animateOverlayView:overlayView withDuration:0.5f];

    NSString *musicOnOff =
        self.sharedAudioController.musicOff
            ? [self.sharedLocalizationController localizedStringForKey:@"♬ Off"]
            : [self.sharedLocalizationController localizedStringForKey:@"♬ On"];

    NSAttributedString *musicButtonString =
        [Utilities styledAttributedStringWithString:musicOnOff
                                      andAlignement:NSTextAlignmentCenter
                                           andColor:nil
                                            andSize:50
                                     andStrokeColor:nil];

    [self.musicButton setAttributedTitle:musicButtonString forState:UIControlStateNormal];
}

- (IBAction)soundEffectsButtonTouched
{
    [self.sharedAudioController playPopSound];

    self.sharedAudioController.soundsOff = !self.sharedAudioController.soundsOff;

    [self.sharedAudioController playPopSound];

    NSString *overSoundsOnOff =
        self.sharedAudioController.soundsOff
            ? [self.sharedLocalizationController localizedStringForKey:@"Sounds Off"]
            : [self.sharedLocalizationController localizedStringForKey:@"Sounds On"];

    MemoransOverlayView *overlayView =
        [[MemoransOverlayView alloc] initWithString:overSoundsOnOff andColor:nil andFontSize:150];

    [self.view addSubview:overlayView];

    [Utilities animateOverlayView:overlayView withDuration:0.5f];

    NSString *soundsOnOff =
        self.sharedAudioController.soundsOff
            ? [self.sharedLocalizationController localizedStringForKey:@"♪ Off"]
            : [self.sharedLocalizationController localizedStringForKey:@"♪ On"];

    NSAttributedString *soundsButtonString =
        [Utilities styledAttributedStringWithString:soundsOnOff
                                      andAlignement:NSTextAlignmentCenter
                                           andColor:nil
                                            andSize:50
                                     andStrokeColor:nil];

    [self.soundEffectsButton setAttributedTitle:soundsButtonString forState:UIControlStateNormal];
}

- (IBAction)creditsButtonTouched
{
    [self.sharedAudioController playPopSound];

    [self performSegueWithIdentifier:@"toCreditsController" sender:self];
}

- (IBAction)fbButtonTouched
{
    [self.sharedAudioController playPopSound];

    NSURL *fbURL = [NSURL URLWithString:@"https://www.facebook.com/memorans"];

    [[UIApplication sharedApplication] openURL:fbURL];
}

- (IBAction)rateButtonTouched
{
    [self.sharedAudioController playPopSound];

    // IMPORTANT: REMEMBER TO ADD APP ID TO URL!!
    NSURL *appURL = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/"];

    [[UIApplication sharedApplication] openURL:appURL];
}

#pragma mark - VIEWS MANAGEMENT AND UPDATE

- (void)configureUIButtons
{
    [Utilities configureButton:self.languageButton
               withTitleString:self.sharedLocalizationController.currentLanguageCode.uppercaseString
                   andFontSize:50];

    [Utilities configureButton:self.playButton
               withTitleString:[self.sharedLocalizationController localizedStringForKey:@"Play"]
                   andFontSize:50];

    NSString *musicOnOff = self.sharedAudioController.musicOff ? @"♬ Off" : @"♬ On";

    [Utilities configureButton:self.musicButton
               withTitleString:[self.sharedLocalizationController localizedStringForKey:musicOnOff]
                   andFontSize:50];

    NSString *soundsOnOff = self.sharedAudioController.soundsOff ? @"♪ Off" : @"♪ On";

    [Utilities configureButton:self.soundEffectsButton
               withTitleString:[self.sharedLocalizationController localizedStringForKey:soundsOnOff]
                   andFontSize:50];

    [Utilities configureButton:self.creditsButton
               withTitleString:[self.sharedLocalizationController localizedStringForKey:@"Credits"]
                   andFontSize:50];

    [Utilities configureButton:self.fbButton withTitleString:@"☍" andFontSize:50];

    [Utilities configureButton:self.rateButton withTitleString:@"★" andFontSize:50];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = YES;

    self.view.multipleTouchEnabled = NO;

    [self configureUIButtons];

    CGFloat shortSide = MIN(self.view.bounds.size.width, self.view.bounds.size.height);
    CGFloat longSide = MAX(self.view.bounds.size.width, self.view.bounds.size.height);

    UILabel *backgroundLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0.8 * longSide, 0.3 * shortSide)];

    backgroundLabel.center = CGPointMake(longSide / 2, shortSide / 2);

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
    [super viewWillAppear:animated];

    [self.view.layer insertSublayer:self.gradientLayer atIndex:0];

    [self addAndAnimateMonsterViews];

    [self.sharedAudioController playMusicFromResource:@"JauntyGumption"
                                               ofType:@"mp3"
                                           withVolume:0.3f];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    [self.gradientLayer removeFromSuperlayer];
    self.gradientLayer = nil;

    [self.monsterViews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    self.monsterViews = nil;
    self.dynamicAnimator = nil;
}

#pragma mark - ANIMATIONS

- (void)addAndAnimateMonsterViews
{
    if ([self.monsterViews count])
    {
        [self.monsterViews makeObjectsPerformSelector:@selector(removeFromSuperview)];

        self.monsterViews = nil;
        self.dynamicAnimator = nil;
    }

    UIImage *monsterImage;
    UIImageView *monsterImageView;
    NSInteger monsterViewXOffset;
    NSInteger monsterViewYOffset;

    NSMutableArray *imageIndexes = [[NSMutableArray alloc] init];
    NSInteger randomImageIndex = 0;

    for (int i = 0; i < 12; i++)
    {
        do
        {
            randomImageIndex = (arc4random() % 20) + 1;
        } while ([imageIndexes indexOfObject:@(randomImageIndex)] != NSNotFound);

        [imageIndexes addObject:@(randomImageIndex)];

        monsterImage =
            [UIImage imageNamed:[NSString stringWithFormat:@"Happy%d", (int)randomImageIndex]];

        monsterImageView = [[UIImageView alloc] initWithImage:monsterImage];

        monsterViewXOffset = monsterImageView.frame.size.width +
                             (arc4random() % (int)monsterImageView.frame.size.width);

        monsterViewYOffset = monsterImageView.frame.size.height +
                             (arc4random() % (int)monsterImageView.frame.size.height);

        monsterImageView.center = CGPointMake(monsterViewXOffset, monsterViewYOffset);

        [self.monsterViews addObject:monsterImageView];

        [self.view addSubview:monsterImageView];
    }

    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            [self.view bringSubviewToFront:view];
        }
    }

    MemoransBehavior *memoransBehavior = [[MemoransBehavior alloc] initWithItems:self.monsterViews];

    [self.dynamicAnimator addBehavior:memoransBehavior];
}

- (BOOL)prefersStatusBarHidden { return YES; }

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

#pragma mark - UIDynamicAnimatorDelegate PROTOCOL

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator { [self addAndAnimateMonsterViews]; }

@end
