//
//  MemoransMenuViewController.m
//  Memorans
//
//  Created by emi on 05/08/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

@import AVFoundation;

#import "MemoransMenuViewController.h"
#import "Utilities.h"
#import "MemoransBehavior.h"
#import "MemoransTile.h"
#import "MemoransGradientView.h"

@interface MemoransMenuViewController () <AVAudioPlayerDelegate, UIDynamicAnimatorDelegate>

#pragma mark - OUTLETS

@property(weak, nonatomic) IBOutlet UIButton *playButton;
@property(weak, nonatomic) IBOutlet UIButton *musicButton;
@property(weak, nonatomic) IBOutlet UIButton *creditsButton;
@property(weak, nonatomic) IBOutlet UIButton *soundEffectsButton;

#pragma mark - PROPERTIES

@property(strong, nonatomic) UIDynamicAnimator *dynamicAnimator;

@property(strong, nonatomic) NSMutableArray *monsterViews;

@property(strong, nonatomic) AVAudioPlayer *musicPlayer;

@property(nonatomic) BOOL playingFirstTrack;
@property(nonatomic) BOOL musicOff;
@property(nonatomic) BOOL soundsOff;

@end

@implementation MemoransMenuViewController

#pragma mark - SETTERS AND GETTERS

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

    NSAttributedString *musicButtonString =
        [Utilities styledAttributedStringWithString:self.musicOff ? @"Music: Off" : @"Music: On"
                                      andAlignement:NSTextAlignmentCenter
                                           andColor:nil
                                            andSize:70
                                     andStrokeColor:[UIColor clearColor]];

    [self.musicButton setAttributedTitle:musicButtonString forState:UIControlStateNormal];
}

- (IBAction)soundEffectsButtonTouched
{
    self.soundsOff = !self.soundsOff;

    if (self.soundsOff)
    {
        gSoundsOff = YES;
    }
    else
    {
        gSoundsOff = NO;
    }

    [Utilities playPopSound];

    NSAttributedString *soundsButtonString =
        [Utilities styledAttributedStringWithString:self.soundsOff ? @"Sounds: Off" : @"Sounds: On"
                                      andAlignement:NSTextAlignmentCenter
                                           andColor:nil
                                            andSize:70
                                     andStrokeColor:[UIColor clearColor]];

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
        [Utilities styledAttributedStringWithString:@"Play"
                                      andAlignement:NSTextAlignmentCenter
                                           andColor:nil
                                            andSize:70
                                     andStrokeColor:[UIColor clearColor]];

    [self.playButton setAttributedTitle:playGameString forState:UIControlStateNormal];

    NSAttributedString *musicButtonString =
        [Utilities styledAttributedStringWithString:@"Music: On"
                                      andAlignement:NSTextAlignmentCenter
                                           andColor:nil
                                            andSize:70
                                     andStrokeColor:[UIColor clearColor]];

    [self.musicButton setAttributedTitle:musicButtonString forState:UIControlStateNormal];

    NSAttributedString *soundsButtonString =
        [Utilities styledAttributedStringWithString:@"Sounds: On"
                                      andAlignement:NSTextAlignmentCenter
                                           andColor:nil
                                            andSize:70
                                     andStrokeColor:[UIColor clearColor]];

    [self.soundEffectsButton setAttributedTitle:soundsButtonString forState:UIControlStateNormal];

    NSAttributedString *creditsString =
        [Utilities styledAttributedStringWithString:@"Credits"
                                      andAlignement:NSTextAlignmentCenter
                                           andColor:nil
                                            andSize:70
                                     andStrokeColor:[UIColor clearColor]];

    [self.creditsButton setAttributedTitle:creditsString forState:UIControlStateNormal];

    [self configureButton:self.playButton];
    [self configureButton:self.musicButton];
    [self configureButton:self.soundEffectsButton];
    [self configureButton:self.creditsButton];

    [self startPlayingMusicFromResource:@"JauntyGumption" ofType:@"mp3"];
    self.playingFirstTrack = YES;
}

- (void)configureButton:(UIButton *)button
{
    button.backgroundColor = [Utilities colorFromHEXString:@"#FFFDD0" withAlpha:1];
    button.multipleTouchEnabled = NO;
    button.exclusiveTouch = YES;
    button.clipsToBounds = YES;

    button.layer.borderColor = [Utilities colorFromHEXString:@"#1F1F21" withAlpha:1].CGColor;
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 15;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.monsterViews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    self.monsterViews = nil;
    self.dynamicAnimator = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if ([self.view isKindOfClass:[MemoransGradientView class]])
    {
        MemoransGradientView *backgroundView = (MemoransGradientView *)self.view;

        backgroundView.startColor = [Utilities randomNiceColor];
        backgroundView.middleColor = [Utilities randomNiceColor];
        backgroundView.endColor = [Utilities randomNiceColor];
    }

    [self addAndAnimateMonsterViews];
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
    NSInteger monsterViewOffset;

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

        monsterViewOffset = (arc4random() % (int)monsterImageView.frame.size.width) +
                            (arc4random() % (int)monsterImageView.frame.size.width) +
                            monsterImageView.frame.size.width;

        if (i % 2 == 0)
        {
            monsterImageView.center = CGPointMake(monsterViewOffset, monsterViewOffset);
        }
        else
        {
            monsterImageView.center = CGPointMake(self.view.frame.size.width - monsterViewOffset,
                                                  self.view.frame.size.height - monsterViewOffset);
        }

        [self.monsterViews addObject:monsterImageView];

        [self.view addSubview:monsterImageView];

        [self.view sendSubviewToBack:monsterImageView];
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
