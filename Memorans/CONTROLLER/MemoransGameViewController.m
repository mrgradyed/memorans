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
@property(strong, nonatomic) MemoransGameEngine *game;
@property(strong, nonatomic) NSMutableAttributedString *scoreAttString;
@property(nonatomic) NSInteger numOfTappedTiles;

@end

@implementation MemoransGameViewController

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

- (NSMutableAttributedString *)scoreAttString
{

    _scoreAttString = [[NSMutableAttributedString alloc]
        initWithString:[NSString stringWithFormat:@"Score: %d", self.game.gameScore]
            attributes:@{
                          NSFontAttributeName : [UIFont boldSystemFontOfSize:30],
                          NSForegroundColorAttributeName : self.tileArea.backgroundColor
                       }];

    return _scoreAttString;
}

- (void)addWobblingAnimationToView:(UIView *)delegateView
{
    CABasicAnimation *wobbling = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];

    [wobbling setFromValue:[NSNumber numberWithFloat:0.05]];

    [wobbling setToValue:[NSNumber numberWithFloat:-0.05]];

    [wobbling setDuration:0.1];

    [wobbling setAutoreverses:YES];

    [wobbling setRepeatCount:5];

    wobbling.delegate = delegateView;

    [delegateView.layer addAnimation:wobbling forKey:@"wobbling"];
}

- (NSMutableArray *)tileViews
{
    if (!_tileViews)
    {
        _tileViews = [[NSMutableArray alloc] init];
    }
    return _tileViews;
}

- (MemoransGameEngine *)game
{
    if (!_game)
    {
        _game = [[MemoransGameEngine alloc] init];
    }
    return _game;
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

    [self syncUIWithModel];
}

- (void)tileTapped:(UITapGestureRecognizer *)tileTapRec
{

    MemoransTileView *tappedTileView = (MemoransTileView *)tileTapRec.view;

    if (tappedTileView.paired || tappedTileView.shown || self.numOfTappedTiles == 2)
    {
        return;
    }

    self.numOfTappedTiles++;

    NSInteger tileIndex = [self.tileViews indexOfObject:tappedTileView];

    if (tileIndex == NSNotFound)
    {
        return;
    }

    [self.game playTileAtIndex:tileIndex];

    tappedTileView.shown = YES;

    [UIView transitionWithView:tappedTileView
        duration:1.0
        options:UIViewAnimationOptionTransitionFlipFromRight
        animations:^{}
        completion:^(BOOL completed) {
            if (self.numOfTappedTiles == 2)
            {
                [self syncUIWithModel];
            }
        }];
}

- (void)syncUIWithModel
{

    MemoransTile *gameTile;
    NSInteger tileIndex;

    for (MemoransTileView *tileView in self.tileViews)
    {
        tileIndex = [self.tileViews indexOfObject:tileView];

        if (tileIndex == NSNotFound)
        {
            return;
        }

        gameTile = [self.game tileOnBoardAtIndex:tileIndex];

        tileView.imageID = gameTile.tileID;
        tileView.paired = gameTile.paired;

        if (tileView.shown && !tileView.paired && self.numOfTappedTiles == 2)
        {

            [self addWobblingAnimationToView:tileView];
        }
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
