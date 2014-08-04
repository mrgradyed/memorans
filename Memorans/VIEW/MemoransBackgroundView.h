//
//  MemoransBackgroundView.h
//  Memorans
//
//  Created by emi on 18/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemoransBackgroundView : UIView

@property(nonatomic, strong) NSString *backgroundImage;

#pragma mark - PUBLIC METHODS

+ (NSArray *)allowedBackgrounds;

@end
