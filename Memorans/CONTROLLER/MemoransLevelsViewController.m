//
//  MemoransLevelsMenuControllerViewController.m
//  Memorans
//
//  Created by emi on 31/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransLevelsViewController.h"
#import "MemoransGameViewController.h"
#import "MemoransBackgroundView.h"
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

@property(strong, nonatomic) MemoransOverlayView *chooseLevelOverlay;

@property(strong, nonatomic) MemoransSharedLevelsPack *sharedLevelsPack;

@end

@implementation MemoransLevelsViewController

#pragma mark - SETTERS AND GETTERS

- (MemoransOverlayView *)chooseLevelOverlay
{
    if (!_chooseLevelOverlay)
    {
        _chooseLevelOverlay = [[MemoransOverlayView alloc]
            initWithString:@"Pick a level!"
                  andColor:[Utilities colorFromHEXString:@"#C643FC" withAlpha:1]
               andFontSize:180];

        [self.view addSubview:_chooseLevelOverlay];
    }

    return _chooseLevelOverlay;
}

- (MemoransSharedLevelsPack *)sharedLevelsPack
{
    if (!_sharedLevelsPack)
    {
        _sharedLevelsPack = [MemoransSharedLevelsPack sharedLevelsPack];
    }

    return _sharedLevelsPack;
}

#pragma mark - ACTIONS AND NAVIGATION

- (IBAction)backToMenuButtonTouched { [self.navigationController popViewControllerAnimated:YES]; }

- (IBAction)levelButtonTouched:(UIButton *)sender
{
    if ([sender isKindOfClass:[MemoransLevelButton class]])
    {
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

    ((MemoransBackgroundView *)self.view).backgroundImage = @"HorizontalWaves";

    NSAttributedString *backToMenuString = [[NSAttributedString alloc]
        initWithString:@"⬅︎"
            attributes:[Utilities stringAttributesWithAlignement:NSTextAlignmentLeft
                                                       withColor:nil
                                                         andSize:60]];

    [self.backToMenuButton setAttributedTitle:backToMenuString forState:UIControlStateNormal];

    self.backToMenuButton.exclusiveTouch = YES;

    MemoransGameLevel *level;

    int loopCount = 0;

    for (MemoransLevelButton *levelButton in self.levelButtonViews)
    {
        level = (MemoransGameLevel *)self.sharedLevelsPack.levelsPack[loopCount];

        levelButton.imageID =
            [NSString stringWithFormat:@"Level%d%@", (int)level.tilesInLevel, level.tileSetType];

        levelButton.exclusiveTouch = YES;

        if (loopCount < 2)
        {
            level.unlocked = YES;
        }

        loopCount++;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    MemoransGameLevel *level;

    int loopCount = 0;

    for (MemoransLevelButton *levelButton in self.levelButtonViews)
    {
        level = (MemoransGameLevel *)self.sharedLevelsPack.levelsPack[loopCount];

        levelButton.enabled = level.unlocked;

        loopCount++;
    }

    [Utilities animateOverlayView:self.chooseLevelOverlay withDuration:3];
}

- (BOOL)prefersStatusBarHidden { return YES; }

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

@end
