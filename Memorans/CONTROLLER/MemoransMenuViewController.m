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
#import "Utilities.h"

@interface MemoransMenuViewController () <AVAudioPlayerDelegate, UIDynamicAnimatorDelegate>

#pragma mark - OUTLETS

@property(weak, nonatomic) IBOutlet UIButton *playButton;
@property(weak, nonatomic) IBOutlet UIButton *musicButton;
@property(weak, nonatomic) IBOutlet UIButton *creditsButton;
@property(weak, nonatomic) IBOutlet UIButton *soundEffectsButton;

#pragma mark - PROPERTIES

@property(strong, nonatomic) CAGradientLayer *gradientLayer;

@property(strong, nonatomic) UIDynamicAnimator *dynamicAnimator;

@property(strong, nonatomic) NSMutableArray *monsterViews;

@property(strong, nonatomic) AVAudioPlayer *musicPlayer;

@property(nonatomic) BOOL playingFirstTrack;
@property(nonatomic) BOOL musicOff;

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

#pragma mark - ACTIONS AND NAVIGATION

- (IBAction)playButtonTouched
{
    [Utilities playPopSound];

    [self performSegueWithIdentifier:@"toLevelsController" sender:self];
}

- (IBAction)musicButtonTouched
{
    self.musicOff = !self.musicOff;

    [Utilities playPopSound];

    if (self.musicOff)
    {
        self.musicPlayer = nil;
        self.playingFirstTrack = NO;
    }
    else
    {
        [self startPlayingMusicFromResource:@"JauntyGumption" ofType:@"mp3"];
        self.playingFirstTrack = YES;
    }

    NSString *overMusicOnOff = self.musicOff ? NSLocalizedString(@"Music Off", @"Music overlay OFF")
                                             : NSLocalizedString(@"Music On", @"Music overlay ON");

    MemoransOverlayView *overlayView =
        [[MemoransOverlayView alloc] initWithString:overMusicOnOff andColor:nil andFontSize:150];

    [self.view addSubview:overlayView];

    [Utilities animateOverlayView:overlayView withDuration:0.5f];

    NSString *musicOnOff = self.musicOff ? NSLocalizedString(@"♬ Off", @"Music button OFF")
                                         : NSLocalizedString(@"♬ On", @"Music button ON");

    NSAttributedString *musicButtonString =
        [Utilities styledAttributedStringWithString:musicOnOff
                                      andAlignement:NSTextAlignmentCenter
                                           andColor:nil
                                            andSize:60
                                     andStrokeColor:nil];

    [self.musicButton setAttributedTitle:musicButtonString forState:UIControlStateNormal];
}

- (IBAction)soundEffectsButtonTouched
{
    [Utilities playPopSound];

    gSoundsOff = !gSoundsOff;

    [Utilities playPopSound];

    NSString *overSoundsOnOff = gSoundsOff ? NSLocalizedString(@"Sounds Off", @"Sounds overlay OFF")
                                           : NSLocalizedString(@"Sounds On", @"Sounds overlay ON");

    MemoransOverlayView *overlayView =
        [[MemoransOverlayView alloc] initWithString:overSoundsOnOff andColor:nil andFontSize:150];

    [self.view addSubview:overlayView];

    [Utilities animateOverlayView:overlayView withDuration:0.5f];

    NSString *soundsOnOff = gSoundsOff ? NSLocalizedString(@"♪ Off", @"Sounds button OFF")
                                       : NSLocalizedString(@"♪ On", @"Sounds button ON");

    NSAttributedString *soundsButtonString =
        [Utilities styledAttributedStringWithString:soundsOnOff
                                      andAlignement:NSTextAlignmentCenter
                                           andColor:nil
                                            andSize:60
                                     andStrokeColor:nil];

    [self.soundEffectsButton setAttributedTitle:soundsButtonString forState:UIControlStateNormal];
}

- (IBAction)creditsButtonTouched
{
    [Utilities playPopSound];

    [self performSegueWithIdentifier:@"toCreditsController" sender:self];
}

#pragma mark - VIEWS MANAGEMENT AND UPDATE

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = YES;

    self.view.multipleTouchEnabled = NO;

    NSAttributedString *playGameString =
        [Utilities styledAttributedStringWithString:NSLocalizedString(@"Play", @"Play button")
                                      andAlignement:NSTextAlignmentCenter
                                           andColor:nil
                                            andSize:60
                                     andStrokeColor:nil];

    [self.playButton setAttributedTitle:playGameString forState:UIControlStateNormal];

    NSAttributedString *musicButtonString =
        [Utilities styledAttributedStringWithString:NSLocalizedString(@"♬ On", @"Music button ON")
                                      andAlignement:NSTextAlignmentCenter
                                           andColor:nil
                                            andSize:60
                                     andStrokeColor:nil];

    [self.musicButton setAttributedTitle:musicButtonString forState:UIControlStateNormal];

    NSAttributedString *soundsButtonString = [Utilities
        styledAttributedStringWithString:NSLocalizedString(@"♪ On", @"Sounds button ON")
                           andAlignement:NSTextAlignmentCenter
                                andColor:nil
                                 andSize:60
                          andStrokeColor:nil];

    [self.soundEffectsButton setAttributedTitle:soundsButtonString forState:UIControlStateNormal];

    NSAttributedString *creditsString =
        [Utilities styledAttributedStringWithString:NSLocalizedString(@"Credits", @"Credits button")
                                      andAlignement:NSTextAlignmentCenter
                                           andColor:nil
                                            andSize:60
                                     andStrokeColor:nil];

    [self.creditsButton setAttributedTitle:creditsString forState:UIControlStateNormal];

    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            [self configureButton:(UIButton *)view];
        }
    }

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

    [self startPlayingMusicFromResource:@"JauntyGumption" ofType:@"mp3"];
    self.playingFirstTrack = YES;
}

- (void)configureButton:(UIButton *)button
{
    button.backgroundColor = [Utilities colorFromHEXString:@"#2B2B2B" withAlpha:1];
    button.multipleTouchEnabled = NO;
    button.exclusiveTouch = YES;
    button.clipsToBounds = YES;

    button.layer.borderColor = [Utilities colorFromHEXString:@"#2B2B2B" withAlpha:1].CGColor;
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 25;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.view.layer insertSublayer:self.gradientLayer atIndex:0];

    [self addAndAnimateMonsterViews];
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

    [Utilities playIiiiSound];

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

#pragma mark - MUSIC

- (void)startPlayingMusicFromResource:(NSString *)fileName ofType:(NSString *)fileType
{
    dispatch_queue_t globalDefaultQueue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_async(globalDefaultQueue, ^(void) {

        NSBundle *appBundle = [NSBundle mainBundle];

        NSData *musicData =
            [NSData dataWithContentsOfFile:[appBundle pathForResource:fileName ofType:fileType]];

        NSError *error;

        self.musicPlayer = nil;

        self.musicPlayer = [[AVAudioPlayer alloc] initWithData:musicData error:&error];

        self.musicPlayer.delegate = self;
        self.musicPlayer.numberOfLoops = 0;
        self.musicPlayer.volume = 0.4;

        [self.musicPlayer prepareToPlay];
        [self.musicPlayer play];
    });
}

#pragma mark - AVAudioPlayerDelegate PROTOCOL

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    if ([player isEqual:self.musicPlayer] && flags == AVAudioSessionInterruptionOptionShouldResume)
    {
        dispatch_queue_t globalDefaultQueue =
            dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

        dispatch_async(globalDefaultQueue, ^(void) { [self.musicPlayer play]; });
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if ([player isEqual:self.musicPlayer] && flag)
    {
        if (self.playingFirstTrack)
        {
            [self startPlayingMusicFromResource:@"PixelPeekerPolka-slower" ofType:@"mp3"];
            self.playingFirstTrack = NO;
        }
        else
        {
            [self startPlayingMusicFromResource:@"JauntyGumption" ofType:@"mp3"];
            self.playingFirstTrack = YES;
        }
    }
}

#pragma mark - UIDynamicAnimatorDelegate PROTOCOL

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator { [self addAndAnimateMonsterViews]; }

@end
