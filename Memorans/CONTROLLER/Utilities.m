//
//  MemoransColorConverter.m
//  Memorans
//
//  Created by emi on 29/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

#pragma mark - CLASS METHODS

+ (UIColor *)colorFromHEXString:(NSString *)hexString
{
    if ([hexString hasPrefix:@"#"])
    {
        hexString = [hexString substringFromIndex:1];
    }

    if ([hexString length] != 6)
    {
        return nil;
    }

    NSString *red = [hexString substringWithRange:NSMakeRange(0, 2)];
    NSString *green = [hexString substringWithRange:NSMakeRange(2, 2)];
    NSString *blue = [hexString substringWithRange:NSMakeRange(4, 2)];

    NSScanner *scanner = [NSScanner scannerWithString:red];

    unsigned redInt;

    if (![scanner scanHexInt:&redInt])
    {
        return nil;
    }

    scanner = [NSScanner scannerWithString:green];

    unsigned greenInt;

    if (![scanner scanHexInt:&greenInt])
    {
        return nil;
    }

    scanner = [NSScanner scannerWithString:blue];

    unsigned blueInt;

    if (![scanner scanHexInt:&blueInt])
    {
        return nil;
    }

    return [UIColor colorWithRed:redInt / 255.0f
                           green:greenInt / 255.0f
                            blue:blueInt / 255.0f
                           alpha:1];
}

+ (NSDictionary *)stringAttributesWithColor:(UIColor *)color andSize:(CGFloat)size
{
    UIColor * dcolor = color ? color : [Utilities colorFromHEXString:@"#C643FC"];

    CGFloat dsize = size ? size : 32;

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];

    paragraphStyle.alignment = NSTextAlignmentLeft;

    return @
    {
        NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:dsize],
        NSForegroundColorAttributeName : dcolor,
        NSTextEffectAttributeName : NSTextEffectLetterpressStyle,
        NSParagraphStyleAttributeName : paragraphStyle,
    };
}

@end
