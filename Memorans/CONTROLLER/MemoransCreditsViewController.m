//
//  MemoransCreditsViewController.m
//  Memorans
//
//  Created by emi on 06/08/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransCreditsViewController.h"
#import "MemoransGradientView.h"
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

    if([self.view isKindOfClass:[MemoransGradientView class]]) {

        MemoransGradientView * backgroundView = (MemoransGradientView *)self.view;

        backgroundView.startColor = [Utilities colorFromHEXString:@"#D6CEC3" withAlpha:1];
        backgroundView.middleColor = [Utilities colorFromHEXString:@"#FFFDD0" withAlpha:1];
        backgroundView.endColor =[Utilities colorFromHEXString:@"#E4DDCA" withAlpha:1];
    }

    NSAttributedString *backToMenuString = [Utilities
                                            styledAttributedStringWithString:@"⬅︎"
                                            andAlignement:NSTextAlignmentLeft
                                            andColor:nil
                                            andSize:60 andStrokeColor:nil];

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
