//
//  MemoransBackgroundView.m
//  Memorans
//
//  Created by emi on 18/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransBackgroundView.h"
#import "Utilities.h"

@implementation MemoransBackgroundView

#pragma mark - VIEW DRAWING

- (void)drawRect:(CGRect)rect
{
    if (self.backgroundImage)
    {
        UIImage *faceImage = [UIImage imageNamed:self.backgroundImage];

        [faceImage drawInRect:self.bounds];
    }

    if (self.backgroundText)
    {
        UIColor *backgroundTextColor = [Utilities colorFromHEXString:@"#FFCC00" withAlpha:1];

        NSDictionary *textAttributes =
            [Utilities stringAttributesWithAlignement:NSTextAlignmentCenter
                                            withColor:backgroundTextColor
                                              andSize:60];

        NSAttributedString *backgroundText =
            [[NSAttributedString alloc] initWithString:self.backgroundText
                                            attributes:textAttributes];

        CGRect textRect = CGRectMake(self.bounds.origin.x + 100, self.bounds.origin.y + 100,
                                     self.bounds.size.width - 200, self.bounds.size.height - 200);

        [backgroundText drawInRect:textRect];
    }
}

@end
