//
//  KAMSResetView.m
//  sudoku
//
//  Created by Kathryn Aplin on 9/29/14.
//  Copyright (c) 2014 Kathryn Aplin Megan Shao. All rights reserved.
//

#import "KAMSResetView.h"
#import "KAMSSolidImageUtility.h"

@implementation KAMSResetView

static int LABEL_FONT_SIZE = 30;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:[KAMSSolidImageUtility
            imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        self.titleLabel.font = [KAMSResetView cellFontStyle];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitle:@"Reset" forState:UIControlStateNormal];
    }
    return self;
    
}

+ (UIFont*)cellFontStyle
{
    return [UIFont fontWithName:@"Helvetica-Bold" size:LABEL_FONT_SIZE];
}
@end
