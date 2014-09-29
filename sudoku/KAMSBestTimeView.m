//
//  KAMSBestTimeView.m
//  sudoku
//
//  Created by Kathryn Aplin on 9/28/14.
//  Copyright (c) 2014 Kathryn Aplin Megan Shao. All rights reserved.
//

#import "KAMSBestTimeView.h"
static int LABEL_FONT_SIZE = 30;

@implementation KAMSBestTimeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.font = [KAMSBestTimeView cellFontStyle];
        self.text = @"Best: -- : --";
    }
    return self;
}

/**
 * Displays the given number of seconds.
 */
- (void)setSeconds:(int)seconds
{
    self.text = [NSString stringWithFormat:@"Best: %02.f : %02i",
                 round(seconds / 60), seconds % 60];
}

+ (UIFont*)cellFontStyle
{
    return [UIFont fontWithName:@"Helvetica-Bold" size:LABEL_FONT_SIZE];
    
}

@end
