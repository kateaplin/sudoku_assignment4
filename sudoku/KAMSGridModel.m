//
//  KAMSGridModel.m
//  sudoku
//
//  Created by Kathryn Aplin on 9/20/14.
//  Copyright (c) 2014 Kathryn Aplin Megan Shao. All rights reserved.
//

#import "KAMSGridModel.h"
#import "KAMSGridGenerator.h"

@interface KAMSGridModel () {
    int _initialGrid[9][9];
    int _currentGrid[9][9];
}

@end

@implementation KAMSGridModel


/**
 * Generates a playable sudoku grid.
 */
-(void) generateGrid
{
    NSMutableArray *grid = [KAMSGridGenerator generateGrid];
    for (int row = 0; row < 9; row++) {
        NSMutableArray* rowArray = [grid objectAtIndex:row];
        for (int col = 0; col < 9; col++) {
            NSNumber *number = [rowArray objectAtIndex:col];
            int value = [number intValue];
            _initialGrid[row][col] = value;
            _currentGrid[row][col] = _initialGrid[row][col];
        }
    }
}

/**
 * Resets the grid to remove all user input. 
 */
-(void) resetGrid
{
    [self useGrid:_initialGrid];
}
/**
 * Forces the Grid Model to use a given grid.
 */
-(void) useGrid:(int[9][9])grid
{
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
            _initialGrid[row][col] = grid[row][col];
            _currentGrid[row][col] = _initialGrid[row][col];
        }
    }
}

/**
 * Gets the value of the current grid at the given coordinates.
 */
-(int) getValueAtRow:(int)row atColumn:(int)column
{
    return _currentGrid[row][column];
}

/**
 * Sets the value of the current grid at the given coordinates to the given
 * value. Assumes the given values are correct, following the architecture
 * discussed in class.
 */
-(void) setValueAtRow:(int)row atColumn:(int)column toValue:(int)value
{
    _currentGrid[row][column] = value;
}

/**
 * Checks whether the coordiantes are of an initial value.
 */
-(BOOL) isMutableAtRow:(int)row atColumn:(int)column
{
    return _initialGrid[row][column] == 0;
}

/**
 * Checks the given value at the given coordiates for consistency with sudoku
 * rules.
 */
-(BOOL) isConsistentAtRow:(int)row atColumn:(int)column forValue:(int)value
{
    BOOL rowConsistent = [self isRowConsistentAtRow:row forValue:value];
    BOOL colConsistent = [self isColumnConsistentAtColumn:column
        forValue:value];
    BOOL blockConsistent = [self isBlockConsistentAtRow:row atColumn:column
        forValue:value];
    BOOL isZero = value == 0;
    
    return (rowConsistent && colConsistent && blockConsistent) || isZero;
}

/**
 * Checks the given value at the given coordiates for Sudoku row consistency.
 */
-(BOOL) isRowConsistentAtRow:(int)row forValue:(int)value
{
    for (int col = 0; col < 9; col++) {
        if ([self getValueAtRow:row atColumn:col] == value) {
            return NO;
        }
    }
    return YES;
}

/**
 * Checks the given value at the given coordiates for Sudoku column consistency.
 */
-(BOOL) isColumnConsistentAtColumn:(int)column forValue:(int)value
{
    for (int row = 0; row < 9; row++) {
        if ([self getValueAtRow:row atColumn:column] == value) {
            return NO;
        }
    }
    return YES;
}

/**
 * Checks the given value at the given coordiates for Sudoku block consistency.
 */
-(BOOL) isBlockConsistentAtRow:(int)row atColumn:(int)column forValue:(int)value
{
    int startingCol = (column / 3) * 3;
    int startingRow = (row / 3) * 3;
    
    for (int row = startingRow; row < (startingRow + 3); row++) {
        for (int col = startingCol; col < (startingCol + 3); col++) {
            if ([self getValueAtRow:row atColumn:col] == value) {
                return NO;
            }
        }
    }
    return YES;
}

/**
 * Checks whether there are any unfilled cells
 */
-(BOOL)isGridFull
{
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
            if (_currentGrid[row][col] == 0) {
                return NO;
            }
        }
    }
    return YES;
}
@end
