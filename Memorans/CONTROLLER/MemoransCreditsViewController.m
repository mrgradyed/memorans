//
//  MemoransCreditsViewController.m
//  Memorans
//
//  Created by emi on 06/08/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransCreditsViewController.h"
#import "MemoransSharedAudioController.h"
#import "Utilities.h"

@interface MemoransCreditsViewController ()

#pragma mark - OUTLETS

@property(weak, nonatomic) IBOutlet UIButton *backToMenuButton;
@property(weak, nonatomic) IBOutlet UITextView *creditsText;

#pragma mark - PROPERTIES

@property(strong, nonatomic) CAGradientLayer *gradientLayer;

@end

@implementation MemoransCreditsViewController

#pragma mark - SETTERS AND GETTERS

- (CAGradientLayer *)gradientLayer
{
    if (!_gradientLayer)
    {
        _gradientLayer = [Utilities randomGradient];

        _gradientLayer.frame = self.view.bounds;
    }

    return _gradientLayer;
}

#pragma mark - ACTIONS AND NAVIGATION

- (IBAction)backToMenuButtonTouched
{
    [[MemoransSharedAudioController sharedAudioController] playPopSound];

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - VIEWS MANAGEMENT AND UPDATE

- (void)viewDidLoad
{
    [super viewDidLoad];

    [Utilities configureButton:self.backToMenuButton withTitleString:@"⬅︎" andFontSize:50];

    self.creditsText.editable = NO;
    self.creditsText.selectable = YES;
    self.creditsText.dataDetectorTypes = UIDataDetectorTypeLink;
    self.creditsText.backgroundColor = [Utilities colorFromHEXString:@"#FFFDD0" withAlpha:1];

    self.creditsText.layer.borderColor =
        [Utilities colorFromHEXString:@"#2B2B2B" withAlpha:1].CGColor;
    self.creditsText.layer.borderWidth = 1;
    self.creditsText.layer.cornerRadius = 90;

    [self.view sendSubviewToBack:self.creditsText];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.view.layer insertSublayer:self.gradientLayer atIndex:0];

    [[MemoransSharedAudioController sharedAudioController] playMusicFromResource:@"TakeAChance"
                                                                          ofType:@"mp3"
                                                                      withVolume:0.8f];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    [self.gradientLayer removeFromSuperlayer];

    self.gradientLayer = nil;
}

- (BOOL)prefersStatusBarHidden { return YES; }

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

@end
