//
//  KAMSGridView.m
//  sudoku
//
//  Created by Megan Shao on 9/12/14.
//  Copyright (c) 2014 Kathryn Aplin Megan Shao. All rights reserved.
//

#import "KAMSGridView.h"

float OUTER_GRID_RATIO = 0.5;
float INNER_GRID_RATIO = 0.25;

@interface KAMSGridView() {
    NSMutableArray* _cells;
    id _target;
    SEL _action;
}

@end

@implementation KAMSGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        CGFloat size = CGRectGetHeight(frame);
        
        CGFloat buttonSize = size / (9 + 4 * OUTER_GRID_RATIO + 6 * INNER_GRID_RATIO);
        
        _cells = [[NSMutableArray alloc] initWithCapacity: 9];
        // Create 81 buttons that each respond when pressed.
        for (int row = 0; row < 9; ++row) {
            NSMutableArray *currentRow = [[NSMutableArray alloc] initWithCapacity: 9];
            for (int col = 0; col < 9; ++col) {
            
                int offsetX = [KAMSGridView horizontalOffsetFromColumn:col forButtonSize:buttonSize];
                int offsetY = [KAMSGridView verticalOffsetFromRow:row forButtonSize:buttonSize];
                
                CGRect buttonFrame = CGRectMake(offsetX + col * buttonSize, offsetY + row * buttonSize, buttonSize, buttonSize);
                UIButton* gridButton = [[UIButton alloc] initWithFrame:buttonFrame];
                [gridButton setBackgroundImage:[KAMSGridView imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                [gridButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                // Each button's tag is [col][row]. So 87 means column 8 row 7.
                gridButton.tag = col * 10 + row;
                [gridButton addTarget:self action:@selector(cellSelected:) forControlEvents:UIControlEventTouchUpInside];
                
                [self addSubview:gridButton];
                [currentRow addObject:gridButton];
            }
            [_cells addObject:currentRow];
        }
    }
    return self;
}

+ (int)verticalOffsetFromRow:(int)row forButtonSize:(CGFloat)buttonSize
{
    return [KAMSGridView offsetFromAxis:row forButtonSize:buttonSize];
}

+ (int)horizontalOffsetFromColumn:(int)column forButtonSize:(CGFloat)buttonSize
{
    return [KAMSGridView offsetFromAxis:column forButtonSize:buttonSize];
}

+ (int)offsetFromAxis:(int) axis forButtonSize:(CGFloat) buttonSize
{
    return buttonSize * OUTER_GRID_RATIO + ((axis / 3) * (buttonSize * OUTER_GRID_RATIO)) + (((axis / 3) * 2) + (axis % 3)) * (buttonSize * INNER_GRID_RATIO);
}

// Obtained from http://stackoverflow.com/questions/6496441/
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/*
 * Sets the value of a cell at the given row, column to the given value.
 */
- (void)setValueAtRow:(int)row atColumn:(int)column toValue:(int)value
{
    UIButton* selected = [[_cells objectAtIndex:row] objectAtIndex:column];
    [selected setTitle:[NSString stringWithFormat:@"%d", value]
        forState:UIControlStateNormal];
}

- (void)cellSelected:(id)sender
{
    // Communicating with viewController.
    // First argument is row, second is column.
    [_target performSelector:_action
        withObject:[NSNumber numberWithInt:[sender tag] % 10]
        withObject:[NSNumber numberWithInt:[sender tag] / 10]];
}

/*
 * Sets the target and action for when a cell is slected in the grid.
 */
-(void) setTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

@end
