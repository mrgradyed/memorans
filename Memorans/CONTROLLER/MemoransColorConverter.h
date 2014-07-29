//
//  MemoransColorConverter.h
//  Memorans
//
//  Created by emi on 29/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemoransColorConverter : NSObject

#pragma mark - PUBLIC METHODS

+ (UIColor *)colorFromHEXString:(NSString *)hexString;

@end
