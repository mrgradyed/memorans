//
//  MemoransCreditsViewController.m
//  Memorans
//
//  Created by emi on 06/08/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransCreditsViewController.h"
#import "MemoransBackgroundView.h"
#import "Utilities.h"

@interface MemoransCreditsViewController ()

#pragma mark - OUTLETS

@property(weak, nonatomic) IBOutlet UIButton *backToMenuButton;
@property(weak, nonatomic) IBOutlet UILabel *creditsLabel;

@end

@implementation MemoransCreditsViewController

#pragma mark - ACTIONS AND NAVIGATION

- (IBAction)backToMenuButtonTouched { [self.navigationController popViewControllerAnimated:YES]; }

#pragma mark - VIEWS MANAGEMENT AND UPDATE

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.multipleTouchEnabled = NO;

    if ([self.view isKindOfClass:[MemoransBackgroundView class]])
    {
        ((MemoransBackgroundView *)self.view).backgroundImage = @"StarsOnBlue";
        ((MemoransBackgroundView *)self.view).backgroundText =
            @"Programming\n \nMonsters Images\n \nMusic\n";
    }

    NSAttributedString *backToMenuString = [[NSAttributedString alloc]
        initWithString:@"⬅︎"
            attributes:[Utilities stringAttributesWithAlignement:NSTextAlignmentLeft
                                                       withColor:nil
                                                         andSize:60]];

    [self.backToMenuButton setAttributedTitle:backToMenuString forState:UIControlStateNormal];

    self.backToMenuButton.exclusiveTouch = YES;

    self.creditsLabel.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated { [self.view setNeedsDisplay]; }

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

- (BOOL)prefersStatusBarHidden { return YES; }



@end