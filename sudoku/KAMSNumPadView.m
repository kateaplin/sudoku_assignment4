//
//  KAMSNumPadView.m
//  sudoku
//
//  Created by Kathryn Aplin on 9/20/14.
//  Copyright (c) 2014 Kathryn Aplin Megan Shao. All rights reserved.
//

#import "KAMSNumPadView.h"
#import "KAMSSolidImageUtility.h"

@implementation KAMSNumPadView {
    int _currentValue;
    NSMutableArray *_numberCells;
    id _target;
    SEL _action;
}

static float BORDER_RATIO = 0.5;
static int CELL_FONT_SIZE = 35;
static float NUMPAD_CORNER_RADIUS = 30.0;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberCells = [[NSMutableArray alloc] init];
        
        self.backgroundColor = [UIColor blackColor];
        
        CGFloat width = CGRectGetWidth(frame);
        CGFloat effectiveNumButtons = 9
        + (BORDER_RATIO * 10);
        
        CGFloat buttonSize = width / effectiveNumButtons;
        int offsetY = BORDER_RATIO * buttonSize;
        for (int i = 1; i <= 9; i++) {
            int offsetX = ((BORDER_RATIO * i) + (i - 1)) * buttonSize;
            CGRect buttonFrame = CGRectMake(offsetX, offsetY, buttonSize,
                buttonSize);
            UIButton *numberCell = [[UIButton alloc]
                initWithFrame: buttonFrame];
            [numberCell addTarget:self action:@selector(cellSelected:)
                 forControlEvents:UIControlEventTouchUpInside];
            [numberCell setBackgroundImage:[KAMSSolidImageUtility
                imageWithColor:[UIColor whiteColor]]
                forState:UIControlStateNormal];
            [numberCell setTitle:[NSString stringWithFormat:@"%d", i]
                forState:UIControlStateNormal];
            [numberCell setTitleColor:[UIColor blackColor]
                forState:UIControlStateNormal];
            [numberCell.titleLabel setFont:[KAMSNumPadView cellFontStyle]];
            numberCell.tag = i;
            
            [_numberCells addObject:numberCell];
            [self addSubview:numberCell];
        }
        
        // Initially, the number 1 is highlighted for the user.
        _currentValue = 1;
        [self setCellActive:1];
        
        [self.layer setCornerRadius:NUMPAD_CORNER_RADIUS];
    }
    return self;
}

- (int)getCurrentValue
{
    return _currentValue;
}

- (void)setTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

- (void)cellSelected:(id)sender
{
    int selectedNumber = (int)[sender tag];
    [self setCellActive:selectedNumber];
    [_target performSelector:_action];
}

-(void)setCellActive:(int)newCellIndex
{
    UIButton *previousCell = [_numberCells objectAtIndex:_currentValue - 1];
    [previousCell setBackgroundImage:[KAMSSolidImageUtility
        imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    UIButton *newCell = [_numberCells objectAtIndex:newCellIndex - 1];
    [newCell setBackgroundImage:[KAMSSolidImageUtility
        imageWithColor:[KAMSNumPadView highlightColor]] forState:UIControlStateNormal];
    _currentValue = newCellIndex;
}

+ (UIFont*)cellFontStyle
{
    return [UIFont fontWithName:@"Helvetica-Bold" size:CELL_FONT_SIZE];
}

+ (UIColor*)highlightColor
{
    return [UIColor colorWithRed:228.0 / 255.0 green:183.0 / 255.0
                            blue:240.0 / 255.0 alpha:1.0];
}
@end
