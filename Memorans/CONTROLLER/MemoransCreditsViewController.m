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

@end

@implementation MemoransCreditsViewController

#pragma mark - ACTIONS AND NAVIGATION

- (IBAction)backToMenuButtonTouched { [self.navigationController popViewControllerAnimated:YES]; }

#pragma mark - VIEWS MANAGEMENT AND UPDATE

- (void)viewDidLoad
{
    [super viewDidLoad];

    MemoransBackgroundView *backgroundView = (MemoransBackgroundView *)self.view;

    backgroundView.backgroundImage = @"StarsOnBlue";
    backgroundView.backgroundText = @"Programming\n \nMonsters Images\n \nMusic\n";

    NSAttributedString *backToMenuString = [[NSAttributedString alloc]
        initWithString:@"⬅︎"
            attributes:[Utilities stringAttributesWithAlignement:NSTextAlignmentLeft
                                                       withColor:nil
                                                         andSize:60]];

    [self.backToMenuButton setAttributedTitle:backToMenuString forState:UIControlStateNormal];

    self.backToMenuButton.exclusiveTouch = YES;
}

- (BOOL)prefersStatusBarHidden { return YES; }

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

@end
