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

@interface MemoransGameViewController () <UIDynamicAnimatorDelegate>

@property(weak, nonatomic) IBOutlet UIView *tileArea;
@property(weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property(weak, nonatomic) IBOutlet UIButton *aNewGameButton;

@property(strong, nonatomic) NSMutableArray *tileViews;
@property(strong, nonatomic) NSMutableArray *tileViewsLeft;
@property(strong, nonatomic) MemoransGameEngine *game;
@property(strong, nonatomic) NSString *gameTileSet;
@property(strong, nonatomic) NSMutableArray *tappedTileViews;
@property(strong, nonatomic) NSMutableAttributedString *scoreAttString;
@property(strong, nonatomic) NSDictionary *stringAttributes;

@property(nonatomic) NSInteger numOfTilesOnBoard;
@property(nonatomic) NSInteger numOfTilesCols;
@property(nonatomic) NSInteger numOfTilesRows;
@property(nonatomic) NSInteger tileWidth;
@property(nonatomic) NSInteger tileHeight;

@property(nonatomic) BOOL isWobbling;

@end

@implementation MemoransGameViewController

static const NSInteger tileMargin = 5;

- (CGRect)frameForTileAtRow:(NSInteger)i Col:(NSInteger)j
{
    NSInteger colWidth = self.tileArea.bounds.size.width / self.numOfTilesCols;
    NSInteger colHeight = self.tileArea.bounds.size.height / self.numOfTilesRows;

    CGFloat frameOriginX = j * colWidth + tileMargin;
    CGFloat frameOriginY = i * colHeight + tileMargin;

    return CGRectMake(frameOriginX, frameOriginY, self.tileWidth, self.tileHeight);
}

#pragma mark - SETTERS AND GETTERS

- (NSInteger)tileWidth
{
    NSInteger colWidth = self.tileArea.bounds.size.width / self.numOfTilesCols;

    _tileWidth = colWidth - tileMargin * 2;

    return _tileWidth;
}

- (NSInteger)tileHeight
{
    NSInteger colHeight = self.tileArea.bounds.size.height / self.numOfTilesRows;

    _tileHeight = colHeight - tileMargin * 2;

    return _tileHeight;
}

- (NSInteger)numOfTilesCols
{
    for (int r = 6; r >= 2; r--)
    {
        int c = (self.numOfTilesOnBoard / r);

        if (self.numOfTilesOnBoard % r == 0 && r <= c)
        {
            _numOfTilesCols = c;
            return _numOfTilesCols;
        }
    }

    return _numOfTilesCols;
}

- (NSInteger)numOfTilesRows
{
    for (int r = 6; r >= 2; r--)
    {
        int c = (self.numOfTilesOnBoard / r);

        if (self.numOfTilesOnBoard % r == 0 && r <= c)
        {
            _numOfTilesRows = r;
            return _numOfTilesRows;
        }
    }

    return _numOfTilesRows;
}

- (NSInteger)numOfTilesOnBoard
{
    if (!_numOfTilesOnBoard || _numOfTilesOnBoard % 2 != 0 || _numOfTilesOnBoard < 4)
    {
        _numOfTilesOnBoard = 6;
    }

    return _numOfTilesOnBoard;
}

- (NSMutableArray *)tileViewsLeft
{
    if (!_tileViewsLeft)
    {
        _tileViewsLeft = [self.tileViews mutableCopy];
    }

    return _tileViewsLeft;
}

- (NSMutableArray *)tappedTileViews
{

    if (!_tappedTileViews)
    {
        _tappedTileViews = [[NSMutableArray alloc] init];
    }

    return _tappedTileViews;
}

@synthesize gameTileSet = _gameTileSet;

- (void)setGameTileSet:(NSString *)gameTileSet
{
    if ([[MemoransTile allowedTileSets] containsObject:gameTileSet])
    {
        _gameTileSet = gameTileSet;
    }
}

- (NSString *)gameTileSet
{
    if (!_gameTileSet)
    {
        _gameTileSet = [[MemoransTile allowedTileSets] firstObject];
    }
    return _gameTileSet;
}

- (NSDictionary *)stringAttributes
{
    if (!_stringAttributes)
    {
        _stringAttributes = @{
            NSFontAttributeName : [UIFont boldSystemFontOfSize:40],
            NSForegroundColorAttributeName : self.tileArea.backgroundColor,
            NSTextEffectAttributeName : NSTextEffectLetterpressStyle,
        };
    }

    return _stringAttributes;
}

- (NSMutableAttributedString *)scoreAttString
{
    _scoreAttString = [[NSMutableAttributedString alloc]
        initWithString:[NSString stringWithFormat:@"Score: %d", (int)self.game.gameScore]
            attributes:self.stringAttributes];

    return _scoreAttString;
}

- (NSMutableArray *)tileViews
{
    if (!_tileViews)
    {
        _tileViews = [[NSMutableArray alloc] initWithCapacity:self.numOfTilesOnBoard];
    }
    return _tileViews;
}

- (MemoransGameEngine *)game
{
    if (!_game)
    {
        _game = [[MemoransGameEngine alloc] initGameWithNum:self.numOfTilesOnBoard
                                                fromTileSet:self.gameTileSet];
    }
    return _game;
}

#pragma mark - INSTANCE METHODS

- (BOOL)prefersStatusBarHidden { return YES; }

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tileArea.backgroundColor =
        [UIColor colorWithRed:255 / 255.0f green:211 / 255.0f blue:224 / 255.0f alpha:1];

    NSAttributedString *aNewGameString =
        [[NSAttributedString alloc] initWithString:@"New Game" attributes:self.stringAttributes];

    [self.aNewGameButton setAttributedTitle:aNewGameString forState:UIControlStateNormal];

    [self updateUIWithNewGame:YES];
}

- (IBAction)startNewGameButtonPressed
{
    for (MemoransTileView *tileView in self.tileViews)
    {
        [tileView removeFromSuperview];
    }

    self.tileViews = nil;
    self.tileViewsLeft = nil;
    self.game = nil;
    self.tappedTileViews = nil;
    self.isWobbling = NO;

    [self updateUIWithNewGame:YES];
}

- (void)tileTapped:(UITapGestureRecognizer *)tileTapRec
{
    MemoransTileView *tappedTileView = (MemoransTileView *)tileTapRec.view;

    if (tappedTileView.paired || tappedTileView.shown || [self.tappedTileViews count] == 2)
    {
        return;
    }

    [self playTappedTileView:tappedTileView];
}

- (void)playTappedTileView:(MemoransTileView *)tappedTileView
{
    [UIView transitionWithView:tappedTileView
        duration:0.5f
        options:UIViewAnimationOptionTransitionFlipFromRight
        animations:^{
            tappedTileView.shown = YES;
            [self.tappedTileViews addObject:tappedTileView];
        }
        completion:^(BOOL completed) {

            if ([self.tappedTileViews indexOfObject:tappedTileView] == 1)
            {
                [self.game playTileAtIndex:[self.tileViews indexOfObject:self.tappedTileViews[0]]];
                [self.game playTileAtIndex:[self.tileViews indexOfObject:self.tappedTileViews[1]]];

                [self updateUIWithNewGame:NO];

                if (!tappedTileView.paired)
                {
                    [self addWobblingAnimationToView:self.tappedTileViews[0]];
                    [self addWobblingAnimationToView:self.tappedTileViews[1]];
                }
                else
                {
                    [UIView transitionWithView:self.tappedTileViews[0]
                                      duration:0.5f
                                       options:UIViewAnimationOptionTransitionCurlUp
                                    animations:^{}
                                    completion:nil];

                    [UIView transitionWithView:self.tappedTileViews[1]
                        duration:0.5f
                        options:UIViewAnimationOptionTransitionCurlUp
                        animations:^{}
                        completion:^(BOOL finished) {

                            [self.tappedTileViews removeAllObjects];

                            if ([self.tileViewsLeft count] == 2)
                            {
                                [self playTappedTileView:self.tileViewsLeft[0]];
                                [self playTappedTileView:self.tileViewsLeft[1]];
                            }
                        }];
                }
            }
        }];
}

- (void)updateUIWithNewGame:(BOOL)restartGame
{
    if (restartGame)
    {
        self.tileArea.layer.cornerRadius = 5;

        MemoransTileView *tileView;

        CGRect tileOnBoardFrame;

        UITapGestureRecognizer *tileTapRecog;

        for (int i = 0; i < self.numOfTilesRows; i++)
        {
            for (int j = 0; j < self.numOfTilesCols; j++)
            {
                tileOnBoardFrame = [self frameForTileAtRow:i Col:j];

                tileView = [[MemoransTileView alloc] initWithFrame:tileOnBoardFrame];

                tileView.onBoardCenter = tileView.center;

                tileView.center = CGPointMake(
                    tileOnBoardFrame.origin.x + tileOnBoardFrame.size.width / 2,
                    (self.view.frame.origin.y - arc4random() % (int)self.view.frame.size.height) -
                        tileView.bounds.size.height);

                tileTapRecog =
                    [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(tileTapped:)];

                tileTapRecog.numberOfTapsRequired = 1;
                tileTapRecog.numberOfTouchesRequired = 1;

                [tileView addGestureRecognizer:tileTapRecog];

                [self.tileViews addObject:tileView];

                [self.tileArea addSubview:tileView];

                [UIView animateWithDuration:2.0f
                                      delay:0
                     usingSpringWithDamping:0.6f
                      initialSpringVelocity:0.4f
                                    options:0
                                 animations:^{ tileView.center = tileView.onBoardCenter; }
                                 completion:nil];
            }
        }
    }

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

        if (tileView.paired)
        {
            [self.tileViewsLeft removeObject:tileView];
        }
    }

    self.scoreLabel.attributedText = self.scoreAttString;
}

- (void)addWobblingAnimationToView:(UIView *)delegateView
{
    CABasicAnimation *wobbling = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];

    [wobbling setFromValue:[NSNumber numberWithFloat:0.05f]];

    [wobbling setToValue:[NSNumber numberWithFloat:-0.05f]];

    [wobbling setDuration:0.1f];

    [wobbling setAutoreverses:YES];

    [wobbling setRepeatCount:4];

    [wobbling setValue:@"wobbling" forKey:@"id"];

    wobbling.delegate = self;

    [delegateView.layer addAnimation:wobbling forKey:@"wobbling"];
}

- (void)animationDidStart:(CAAnimation *)anim { self.isWobbling = YES; }

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (!self.isWobbling)
    {
        return;
    }

    self.isWobbling = NO;

    for (MemoransTileView *tileView in self.tappedTileViews)
    {
        [UIView transitionWithView:tileView
            duration:0.3f
            options:UIViewAnimationOptionTransitionFlipFromLeft
            animations:^{ tileView.shown = NO; }
            completion:^(BOOL finished) {
                if ([self.tappedTileViews indexOfObject:tileView] == 1)
                {
                    [self.tappedTileViews removeAllObjects];
                }
            }];
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
