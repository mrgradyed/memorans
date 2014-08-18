//
//  MemoransCreditsViewController.m
//  Memorans
//
//  Created by emi on 06/08/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransCreditsViewController.h"
#import "Utilities.h"

@interface MemoransCreditsViewController ()

#pragma mark - OUTLETS

@property(weak, nonatomic) IBOutlet UIButton *backToMenuButton;
@property(weak, nonatomic) IBOutlet UITextView *creditsText;

@end

@implementation MemoransCreditsViewController

#pragma mark - ACTIONS AND NAVIGATION

- (IBAction)backToMenuButtonTouched
{
    [Utilities playPopSound];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - VIEWS MANAGEMENT AND UPDATE

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    NSAttributedString *backToMenuString = [Utilities
                                            defaultStyledAttributedStringWithString:@"⬅︎"
                                            andAlignement:NSTextAlignmentLeft
                                            andColor:nil
                                            andSize:60];

    [self.backToMenuButton setAttributedTitle:backToMenuString forState:UIControlStateNormal];

    self.backToMenuButton.exclusiveTouch = YES;

    self.creditsText.editable = NO;
    self.creditsText.selectable = YES;
    self.creditsText.dataDetectorTypes = UIDataDetectorTypeLink;
    self.creditsText.backgroundColor = [UIColor clearColor];

    [self.view sendSubviewToBack:self.creditsText];
}

- (BOOL)prefersStatusBarHidden { return YES; }

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

@end
