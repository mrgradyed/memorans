//
//  MemoransEndViewController.m
//  Memorans
//
//  Created by emi on 21/08/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransEndViewController.h"
#import "MemoransBehavior.h"
#import "Utilities.h"

@interface MemoransEndViewController () <UIDynamicAnimatorDelegate>

#pragma mark - OUTLETS

@property(weak, nonatomic) IBOutlet UITextView *endLabel;

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

    self.endLabel.attributedText = [Utilities
        styledAttributedStringWithString:NSLocalizedString(@"The End", @"End screen label")
                           andAlignement:NSTextAlignmentCenter
                                andColor:nil
                                 andSize:120
                          andStrokeColor:nil];

    NSAttributedString *backToRootString =
        [Utilities styledAttributedStringWithString:@"⬅︎"
                                      andAlignement:NSTextAlignmentLeft
                                           andColor:nil
                                            andSize:60
                                     andStrokeColor:nil];

    [self.backToRootButton setAttributedTitle:backToRootString forState:UIControlStateNormal];

    self.backToRootButton.exclusiveTouch = YES;
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
        if ([view isKindOfClass:[UIButton class]] || [view isKindOfClass:[UITextView class]])
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
