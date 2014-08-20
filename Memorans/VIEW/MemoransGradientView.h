//
//  MemoransGradientView.h
//  Memorans
//
//  Created by emi on 18/08/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - PROPERTIES

@interface MemoransGradientView : UIView

@property(strong, nonatomic) UIColor *startColor;

@property(strong, nonatomic) UIColor *middleColor;

@property(strong, nonatomic) UIColor *endColor;

@property(strong, nonatomic) NSString *backgroundText;

@property(strong, nonatomic) UIColor *backgroundTextColor;

@property(nonatomic) CGFloat backgroundTextFontSize;

@end
