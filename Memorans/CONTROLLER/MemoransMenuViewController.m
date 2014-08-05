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

@property(weak, nonatomic) IBOutlet UIButton *startGameButton;
@property(weak, nonatomic) IBOutlet UIButton *creditsButton;

@end

@implementation MemoransMenuViewController

#pragma mark - ACTIONS AND NAVIGATION

- (IBAction)startButtonTouched
{
    [self performSegueWithIdentifier:@"toLevelsController" sender:self];
}

- (IBAction)creditsButtonTouched {

    [self performSegueWithIdentifier:@"toCreditsController" sender:self];

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = YES;

    if ([self.view isKindOfClass:[MemoransBackgroundView class]])
    {
        self.view.multipleTouchEnabled = NO;

        ((MemoransBackgroundView *)self.view).backgroundImage = @"SkewedWaves";
    }

    NSAttributedString *startGameString = [[NSAttributedString alloc]
        initWithString:@"Start Game"
            attributes:[Utilities stringAttributesCentered:NO withColor:nil andSize:60]];

    [self.startGameButton setAttributedTitle:startGameString forState:UIControlStateNormal];

    self.startGameButton.exclusiveTouch = YES;

    NSAttributedString *creditsString = [[NSAttributedString alloc]
        initWithString:@"Credits"
            attributes:[Utilities stringAttributesCentered:NO withColor:nil andSize:60]];

    [self.creditsButton setAttributedTitle:creditsString forState:UIControlStateNormal];

    self.creditsButton.exclusiveTouch = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before
navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)prefersStatusBarHidden { return YES; }

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

@end
