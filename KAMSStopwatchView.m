//
//  KAMSStopwatchView.m
//  sudoku
//
//  Created by Kathryn Aplin on 9/28/14.
//  Copyright (c) 2014 Kathryn Aplin Megan Shao. All rights reserved.
//

#import "KAMSStopwatchView.h"

@implementation KAMSStopwatchView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.text = @"Time: -- : --";
    }
    return self;
    
}

/**
 * Displays the given number of seconds.
 */
- (void)setSeconds:(int)seconds
{
    self.text = [NSString stringWithFormat:@"Time: %02.f : %02i",
        round(seconds / 60), seconds % 60];
}

@end
