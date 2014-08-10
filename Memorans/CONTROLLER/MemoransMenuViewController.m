//
//  MemoransMenuViewController.m
//  Memorans
//
//  Created by emi on 05/08/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransMenuViewController.h"
#import "MemoransBackgroundView.h"
#import "Utilities.h"

@interface MemoransMenuViewController ()

#pragma mark - OUTLETS

@property(weak, nonatomic) IBOutlet UIButton *playButton;
@property(weak, nonatomic) IBOutlet UIButton *creditsButton;

@end

@implementation MemoransMenuViewController

#pragma mark - ACTIONS AND NAVIGATION

- (IBAction)playButtonTouched
{
    [self performSegueWithIdentifier:@"toLevelsController" sender:self];
}

- (IBAction)creditsButtonTouched
{

    [self performSegueWithIdentifier:@"toCreditsController" sender:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = YES;


    self.view.multipleTouchEnabled = NO;

    if ([self.view isKindOfClass:[MemoransBackgroundView class]])
    {

        ((MemoransBackgroundView *)self.view).backgroundImage = @"SkewedWaves";
    }

    NSAttributedString *playGameString = [[NSAttributedString alloc]
        initWithString:@"Play"
            attributes:[Utilities stringAttributesWithAlignement:NSTextAlignmentCenter
                                                       withColor:nil
                                                         andSize:80]];

    [self.playButton setAttributedTitle:playGameString forState:UIControlStateNormal];

    self.playButton.exclusiveTouch = YES;

    NSAttributedString *creditsString = [[NSAttributedString alloc]
        initWithString:@"Credits"
            attributes:[Utilities stringAttributesWithAlignement:NSTextAlignmentCenter
                                                       withColor:nil
                                                         andSize:80]];

    [self.creditsButton setAttributedTitle:creditsString forState:UIControlStateNormal];

    self.creditsButton.exclusiveTouch = YES;
}


- (BOOL)prefersStatusBarHidden { return YES; }

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

@end
