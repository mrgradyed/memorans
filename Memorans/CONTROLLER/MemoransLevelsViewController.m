//
//  MemoransLevelsMenuControllerViewController.m
//  Memorans
//
//  Created by emi on 31/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransLevelsViewController.h"
#import "MemoransGameViewController.h"
#import "MemoransLevelButton.h"
#import "MemoransSharedLevelsPack.h"
#import "MemoransGameLevel.h"
#import "MemoransOverlayView.h"
#import "Utilities.h"

@interface MemoransLevelsViewController ()

#pragma mark - OUTLETS

@property(strong, nonatomic) IBOutletCollection(UIButton) NSArray *levelButtonViews;

@property(weak, nonatomic) IBOutlet UIButton *backToMenuButton;

#pragma mark - PROPERTIES

@property(strong, nonatomic) CAGradientLayer *gradientLayer;

@end

@implementation MemoransLevelsViewController

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

#pragma mark - ACTIONS AND NAVIGATION

- (IBAction)backToMenuButtonTouched
{
    [Utilities playPopSound];

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)levelButtonTouched:(UIButton *)sender
{
    if ([sender isKindOfClass:[MemoransLevelButton class]])
    {
        [Utilities playPopSound];

        [self performSegueWithIdentifier:@"toGameController" sender:sender];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toGameController"])
    {
        MemoransGameViewController *gameController = segue.destinationViewController;

        MemoransLevelButton *levelButton = (MemoransLevelButton *)sender;

        NSInteger levelNumber = [self.levelButtonViews indexOfObject:levelButton];

        gameController.currentLevelNumber = levelNumber;
    }
}

#pragma mark - VIEWS MANAGEMENT AND UPDATE

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.multipleTouchEnabled = NO;

    NSAttributedString *backToMenuString =
        [Utilities styledAttributedStringWithString:@"⬅︎"
                                      andAlignement:NSTextAlignmentLeft
                                           andColor:nil
                                            andSize:60
                                     andStrokeColor:nil];

    [self.backToMenuButton setAttributedTitle:backToMenuString forState:UIControlStateNormal];

    self.backToMenuButton.exclusiveTouch = YES;

    int loopCount = 0;

    NSString *levelButtonImage;

    for (MemoransLevelButton *levelButton in self.levelButtonViews)
    {
        levelButtonImage = [NSString stringWithFormat:@"Level%d", loopCount + 1];

        [levelButton setImage:[UIImage imageNamed:levelButtonImage] forState:UIControlStateNormal];

        levelButton.exclusiveTouch = YES;

        loopCount++;
    }

    // JUST FOR TESTING, TO BE REMOVED - START -

    // [[MemoransSharedLevelsPack sharedLevelsPack] deleteSavedLevelsStatus];

    // JUST FOR TESTING, TO BE REMOVED - END -
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.view.layer insertSublayer:self.gradientLayer atIndex:0];

    MemoransGameLevel *level;

    int loopCount = 0;
    int highestCompletedLevel = 0;

    for (MemoransLevelButton *levelButton in self.levelButtonViews)
    {
        level =
            (MemoransGameLevel *)[MemoransSharedLevelsPack sharedLevelsPack].levelsPack[loopCount];

        if (loopCount == 0)
        {
            level.completed = YES;
        }

        levelButton.enabled = level.completed;

        if (level.completed)
        {
            highestCompletedLevel = loopCount;
        }

        loopCount++;

        // JUST FOR TESTING, TO BE REMOVED - START -

        levelButton.enabled = YES;

        level.completed = YES;

        // JUST FOR TESTING, TO BE REMOVED - END -
    }

    if (highestCompletedLevel + 1 < [self.levelButtonViews count])
    {
        ((MemoransLevelButton *)self.levelButtonViews[highestCompletedLevel + 1]).enabled = YES;
    }

    MemoransOverlayView *overlayView = [[MemoransOverlayView alloc]
        initWithString:NSLocalizedString(@"Pick\na Level", @"Level choice")
              andColor:nil
           andFontSize:190];

    [self.view addSubview:overlayView];

    [Utilities animateOverlayView:overlayView withDuration:1.5f];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    [self.gradientLayer removeFromSuperlayer];

    self.gradientLayer = nil;
}

- (BOOL)prefersStatusBarHidden { return YES; }

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

@end
