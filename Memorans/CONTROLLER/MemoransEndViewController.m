//
//  MemoransEndViewController.m
//  Memorans
//
//  Created by emi on 21/08/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransEndViewController.h"
#import "MemoransBehavior.h"
#import "MemoransSharedAudioController.h"
#import "MemoransSharedLocalizationController.h"
#import "Utilities.h"

@interface MemoransEndViewController () <UIDynamicAnimatorDelegate>

#pragma mark - OUTLETS

@property(weak, nonatomic) IBOutlet UIButton *backToRootButton;

#pragma mark - PROPERTIES

@property(strong, nonatomic) CAGradientLayer *gradientLayer;

@property(strong, nonatomic) UIDynamicAnimator *dynamicAnimator;

@property(strong, nonatomic) NSMutableArray *monsterViews;

@end

@implementation MemoransEndViewController

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

#pragma mark - ACTIONS

- (IBAction)backToMenuTouched { [self.navigationController popToRootViewControllerAnimated:YES]; }

#pragma mark - VIEWS MANAGEMENT AND UPDATE

- (void)viewDidLoad
{
    [super viewDidLoad];

    [Utilities configureButton:self.backToRootButton withTitleString:@"⬅︎" andFontSize:50];

    CGFloat shortSide = MIN(self.view.bounds.size.width, self.view.bounds.size.height);
    CGFloat longSide = MAX(self.view.bounds.size.width, self.view.bounds.size.height);

    UILabel *backgroundLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0.8 * longSide, 0.3 * shortSide)];

    backgroundLabel.center = CGPointMake(longSide / 2, shortSide / 2);

    backgroundLabel.attributedText =
        [Utilities styledAttributedStringWithString:
                       [[MemoransSharedLocalizationController sharedLocalizationController]
                           localizedStringForKey:@"The End"]
                                      andAlignement:NSTextAlignmentCenter
                                           andColor:nil
                                            andSize:150
                                     andStrokeColor:nil];

    [self.view addSubview:backgroundLabel];
    [self.view bringSubviewToFront:backgroundLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.view.layer insertSublayer:self.gradientLayer atIndex:0];

    [self addAndAnimateMonsterViews];

    [[MemoransSharedAudioController sharedAudioController] playMusicFromResource:@"TakeAChance"
                                                                          ofType:@"mp3"
                                                                      withVolume:0.8f];
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

- (void)addAndAnimateMonsterViews
{
    if ([self.monsterViews count])
    {
        [self.monsterViews makeObjectsPerformSelector:@selector(removeFromSuperview)];

        self.monsterViews = nil;
        self.dynamicAnimator = nil;
    }

    [[MemoransSharedAudioController sharedAudioController] playIiiiSound];

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
        if ([view isKindOfClass:[UIButton class]] || [view isKindOfClass:[UILabel class]])
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
