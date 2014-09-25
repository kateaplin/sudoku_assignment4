//
//  sudokuTests.m
//  sudokuTests
//
//  Created by Megan Shao on 9/11/14.
//  Copyright (c) 2014 Kathryn Aplin Megan Shao. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KAMSGridModel.h"

static int INITIAL_GRID[9][9] = {
    {7, 0, 0, 4, 2, 0, 0, 0, 9},
    {0, 0, 9, 5, 0, 0 ,0 ,0, 4},
    {0, 2, 0, 6, 9, 0, 5, 0, 0},
    {6, 5, 0, 0, 0, 0, 4, 3, 0},
    {0, 8, 0, 0, 0, 6, 0, 0, 7},
    {0, 1, 0, 0, 4, 5, 6, 0, 0},
    {0, 0, 0, 8, 6, 0, 0, 0, 2},
    {3, 4, 0, 9, 0, 0, 1, 0, 0},
    {8, 0, 0, 3, 0, 2, 7, 4, 0}
};

@interface sudokuTests : XCTestCase {
    KAMSGridModel *_testGridModel;
}

@end

@implementation sudokuTests

- (void)setUp
{
    [super setUp];
    _testGridModel = [[KAMSGridModel alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

/**
 * Tests getValueAtRowCol functions in Grid Model class by
 * verifying initial values.
 */
-(void)testGetValueAtRowCol
{
    [_testGridModel useGrid:INITIAL_GRID];
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
            int testGridModelValue = [_testGridModel
                getValueAtRow:row atColumn:col];
            int initialGridValue = INITIAL_GRID[row][col];
            XCTAssertTrue(testGridModelValue == initialGridValue,
                @"Checking grid generation correctness at row: %d and col: %d",
                row, col);
        }
    }
}

/**
 * Tests setValueAtRowCol for correctness in setting a specific value and then
 * retreiving it. Also done twice to explicitly check a known case where the 
 * value has changed.
 */
-(void)testSetValueAtRowCol
{
    [_testGridModel setValueAtRow:0 atColumn:0 toValue:4];
    XCTAssertTrue([_testGridModel getValueAtRow:0 atColumn:0] == 4,
        @"Checking the set value at row column function.");
    
    [_testGridModel setValueAtRow:0 atColumn:0 toValue:5];
    XCTAssertTrue([_testGridModel getValueAtRow:0 atColumn:0] == 5,
        @"Checking the set value at row column function knowing that the value \
                  should have changed.");
}

/**
 * Tests isMutableAtRowCol for a known mutable value. Takes advantage of knowing
 * what the initial grid is.
 */
-(void)testIsMutableAtRowColForKnownMutable
{
    [_testGridModel useGrid:INITIAL_GRID];
    
    XCTAssertTrue([_testGridModel isMutableAtRow:0 atColumn:1] == YES,
        @"Checking a known mutable value in the grid.");
}

/**
 * Tests isMutableAtRowCol for a known immutable value. Takes advantage of
 * knowing what the initial grid is.
 */
-(void)testIsMutableAtRowColForKnownImmutable
{
    [_testGridModel useGrid:INITIAL_GRID];
    
    XCTAssertTrue([_testGridModel isMutableAtRow:0 atColumn:0] == NO,
        @"Checking a known mutable value in the grid.");
}

/**
 * Tests isConsistentAtRowColForValue for a known to be consistent value and
 * location.
 */
-(void)testIsConsistentAtRowColForKnownConsistentValue
{
    [_testGridModel useGrid:INITIAL_GRID];
    XCTAssertTrue(
        [_testGridModel isConsistentAtRow:0 atColumn:1 forValue:3] == YES,
        @"Check consistency for known consistent value and location.");
    
}

/**
 * Tests isConsistentAtRowColForValue for a known to be inconsistent value
 * for a row.
 */
-(void)testIsConsistentAtRowColForKnownInconsistentValueAtRow
{
    [_testGridModel useGrid:INITIAL_GRID];
    XCTAssertTrue(
        [_testGridModel isRowConsistentAtRow:1 forValue:5] == NO,
        @"Check consistency for known inconsistent value for row.");
}

/**
 * Tests isConsistentAtRowColForValue for a known to be inconsistent value
 * for a column.
 */
-(void)testIsConsistentAtRowColForKnownInconsistentValueAtCol
{
    [_testGridModel useGrid:INITIAL_GRID];
    XCTAssertTrue(
        [_testGridModel isColumnConsistentAtColumn:1 forValue:5] == NO,
        @"Check consistency for known inconsistent value for column.");
}

/**
 * Tests isConsistentAtRowColForValue for a known to be inconsistent value
 * for a block.
 */
-(void)testIsConsistentAtRowColForKnownInconsistentValueAtBlock
{
    [_testGridModel useGrid:INITIAL_GRID];
    XCTAssertTrue(
        [_testGridModel isBlockConsistentAtRow:1 atColumn:0 forValue:2] == NO,
        @"Check consistency for known inconsistent value for block.");
}
@end
