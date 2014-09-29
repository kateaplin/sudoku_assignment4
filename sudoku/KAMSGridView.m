//
//  KAMSGridView.m
//  sudoku
//
//  Created by Megan Shao on 9/12/14.
//  Copyright (c) 2014 Kathryn Aplin Megan Shao. All rights reserved.
//

#import "KAMSGridView.h"
#import "KAMSSolidImageUtility.h"

// Border to button size ratios.
static float LARGE_GRID_BORDER_RATIO = 0.5;
static float SMALL_GRID_BORDER_RATIO = 0.25;

static int NUM_LARGE_GRID_BORDERS = 4;
static int NUM_SMALL_GRID_BORDERS = 6;

static int CELL_FONT_SIZE = 35;
static float GRID_CORNER_RADIUS = 30.0;

@interface KAMSGridView() {
    NSMutableArray *_cells;
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
        
        // Treat buttonSize as an unit to fill screen with cells and borders.
        // effectiveNumButtons is the number of these units.
        CGFloat effectiveNumButtons = 9
            + (NUM_LARGE_GRID_BORDERS * LARGE_GRID_BORDER_RATIO)
            + (NUM_SMALL_GRID_BORDERS * SMALL_GRID_BORDER_RATIO);
        
        CGFloat buttonSize = size / effectiveNumButtons;
        
        _cells = [[NSMutableArray alloc] initWithCapacity: 9];
        // Create 81 buttons that each respond when pressed.
        for (int row = 0; row < 9; ++row) {
            NSMutableArray *currentRow =
                [[NSMutableArray alloc] initWithCapacity: 9];
            for (int col = 0; col < 9; ++col) {
            
                int horizontalOffset =
                    [KAMSGridView horizontalOffsetFromColumn:col
                    forButtonSize:buttonSize];
                int verticalOffset =
                    [KAMSGridView verticalOffsetFromRow:row
                    forButtonSize:buttonSize];
                
                CGRect buttonFrame = CGRectMake(horizontalOffset,
                    verticalOffset, buttonSize, buttonSize);
                UIButton *gridButton =
                    [[UIButton alloc] initWithFrame:buttonFrame];
                [gridButton setBackgroundImage:[KAMSSolidImageUtility
                    imageWithColor:[UIColor whiteColor]]
                    forState:UIControlStateNormal];
                [gridButton setTitleColor:[KAMSGridView cellTextColor]
                    forState:UIControlStateNormal];
                [gridButton.titleLabel setFont:[KAMSGridView cellFontStyle]];
                
                // Each button's tag is [col][row]. So 87 means column 8 row 7.
                gridButton.tag = col * 10 + row;
                [gridButton addTarget:self action:@selector(cellSelected:)
                     forControlEvents:UIControlEventTouchUpInside];
                
                [self addSubview:gridButton];
                [currentRow addObject:gridButton];
            }
            [_cells addObject:currentRow];
        }
        [self.layer setCornerRadius:GRID_CORNER_RADIUS];
    }
    return self;
}

/**
 * Clears all the cells in the grid. 
 */
-(void)clearCells
{
    for (int row = 0; row < 9; row ++) {
        for (int col = 0; col < 9; col++) {
            UIButton *cell = [[_cells objectAtIndex:row] objectAtIndex:col];
            [cell setEnabled:YES];
            [cell setTitle:@"" forState:UIControlStateNormal];
        }
    }
}

/**
 * Sets the value of a cell at the given row, column to the given value.
 */
- (void)setValueAtRow:(int)row atColumn:(int)column toValue:(int)value
{
    UIButton *selected = [[_cells objectAtIndex:row] objectAtIndex:column];
    NSString *title = @"";
    if (value != 0) {
        title = [NSString stringWithFormat:@"%d", value];
    }
    [selected setTitle:title forState:UIControlStateNormal];
}

/**
 * Set initial value of a cell at the given row, column to the given value.
 * Disables the cell, colors the cell differently.
 */
- (void)setInitialValueAtRow:(int)row atColumn:(int)column toValue:(int)value
{
    UIButton *cell = [[_cells objectAtIndex:row] objectAtIndex:column];
    [cell setTitleColor:[KAMSGridView initialCellTextColor]
        forState:UIControlStateNormal];
    [cell setBackgroundImage:[KAMSSolidImageUtility
        imageWithColor:[UIColor whiteColor]]
        forState:UIControlStateDisabled];
    [cell setEnabled:NO];
    [self setValueAtRow:row atColumn:column toValue:value];
}

/**
 * Sets the target and action for when a cell is slected in the grid.
 */
-(void) setTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

- (void)cellSelected:(id)sender
{
    // Communicating with viewController.
    // First argument is row, second is column.
    int selectedCell = (int)[sender tag];
    [_target performSelector:_action
                  withObject:[NSNumber numberWithInt:selectedCell % 10]
                  withObject:[NSNumber numberWithInt:selectedCell / 10]];
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
    int numBlocksPerAxis = 3;
    int currentBlock = axis / numBlocksPerAxis;
    int numInnerBordersPerBlock = 2;
    int numInnerBordersForCurrentBlock = axis % 3;
    
    int largeBorderOffsets = (currentBlock + 1) * LARGE_GRID_BORDER_RATIO
    * buttonSize;
    int smallBorderOffsets = ((currentBlock * numInnerBordersPerBlock)
                              + numInnerBordersForCurrentBlock)
    * (buttonSize * SMALL_GRID_BORDER_RATIO);
    int offsetsFromPreviousButtons = axis * buttonSize;
    
    return largeBorderOffsets + smallBorderOffsets + offsetsFromPreviousButtons;
}

+ (UIColor*)initialCellTextColor
{
    return [UIColor blackColor];
}

+ (UIColor*)cellTextColor
{
    return [UIColor darkGrayColor];
}

+ (UIFont*)cellFontStyle
{
    return [UIFont fontWithName:@"Helvetica-Bold" size:CELL_FONT_SIZE];

}

@end
