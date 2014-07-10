//
//  MemoransGameViewController.m
//  Memorans
//
//  Created by emi on 03/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransGameViewController.h"
#import "MemoransTileView.h"
#import "MemoransTile.h"
#import "MemoransGameEngine.h"

@interface MemoransGameViewController ()

@property(weak, nonatomic) IBOutlet UIView *tileArea;
@property(weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property(strong, nonatomic) NSMutableArray *tileViews;
@property(strong, nonatomic) MemoransGameEngine *currentGame;
@property(strong, nonatomic) NSMutableAttributedString *scoreAttString;
@property(nonatomic) NSInteger numOfTappedTiles;

@end

@implementation MemoransGameViewController

- (NSMutableAttributedString *)scoreAttString
{

    _scoreAttString = [[NSMutableAttributedString alloc]
        initWithString:[NSString stringWithFormat:@"Score: %d", self.currentGame.gameScore]
            attributes:@{
                          NSFontAttributeName : [UIFont boldSystemFontOfSize:30],
                          NSForegroundColorAttributeName : self.tileArea.backgroundColor
                       }];

    return _scoreAttString;
}

- (NSMutableArray *)tileViews
{

    if (!_tileViews)
    {
        _tileViews = [[NSMutableArray alloc] init];
    }
    return _tileViews;
}

- (MemoransGameEngine *)currentGame
{

    if (!_currentGame)
    {
        _currentGame = [[MemoransGameEngine alloc] init];
    }
    return _currentGame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tileArea.layer.cornerRadius = 5;

    MemoransTileView *tileView;

    UITapGestureRecognizer *tileTapRecog;

    for (int i = 0; i < numberOfRows; i++)
    {
        for (int j = 0; j < numberOfCols; j++)
        {
            tileView = [[MemoransTileView alloc]
                initWithFrame:[MemoransGameViewController frameForTileAtRow:i
                                                                        Col:j
                                                           inContainerFrame:self.tileArea.frame]];

            tileTapRecog =
                [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tileTapped:)];

            tileTapRecog.numberOfTapsRequired = 1;
            tileTapRecog.numberOfTouchesRequired = 1;

            [tileView addGestureRecognizer:tileTapRecog];

            [self.tileViews addObject:tileView];

            [self.tileArea addSubview:tileView];
        }
    }

    self.scoreLabel.attributedText = self.scoreAttString;

    [self updateUI];
}

- (void)tileTapped:(UITapGestureRecognizer *)tileTapRec
{

    MemoransTileView *tappedTileView = (MemoransTileView *)tileTapRec.view;

    if (tappedTileView.paired || tappedTileView.selected || self.numOfTappedTiles == 2)
    {
        return;
    }

    self.numOfTappedTiles++;

    NSInteger tileIndex = [self.tileViews indexOfObject:tappedTileView];

    [UIView transitionWithView:tappedTileView
        duration:1.0
        options:UIViewAnimationOptionTransitionFlipFromRight
        animations:^{ tappedTileView.selected = YES; }
        completion:^(BOOL completed) {
            [self.currentGame playTileAtIndex:tileIndex];
            [self updateUI];
        }];
}

- (void)updateUI
{
    MemoransTile *gameTile;
    NSInteger tileIndex;

    for (MemoransTileView *tileView in self.tileViews)
    {
        tileIndex = [self.tileViews indexOfObject:tileView];
        gameTile = [self.currentGame tileOnBoardAtIndex:tileIndex];

        tileView.tileViewContent = [gameTile tileContent];
        tileView.paired = gameTile.paired;
        tileView.selected = gameTile.selected;
    }

    self.scoreLabel.attributedText = self.scoreAttString;

    if (self.numOfTappedTiles == 2)
    {
        self.numOfTappedTiles = 0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - STATIC VARS AND METHODS

static const NSInteger numberOfCols = 7;
static const NSInteger numberOfRows = 4;
static const NSInteger tileWidth = 120;
static const NSInteger tileHeight = tileWidth;

+ (CGRect)frameForTileAtRow:(NSInteger)i Col:(NSInteger)j inContainerFrame:(CGRect)frame
{
    NSInteger colWidth = frame.size.width / numberOfCols;
    NSInteger colHeight = frame.size.height / numberOfRows;

    CGFloat tileMarginX = (colWidth - tileWidth) / 2;
    CGFloat tileMarginY = (colHeight - tileHeight) / 2;

    CGFloat frameOriginX = j * colWidth + tileMarginX;
    CGFloat frameOriginY = i * colHeight + tileMarginY;

    return CGRectMake(frameOriginX, frameOriginY, tileWidth, tileHeight);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before
navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
