//
//  KAMSGridGenerator.m
//  sudoku
//
//  Created by Kathryn Aplin on 9/25/14.
//  Copyright (c) 2014 Kathryn Aplin Megan Shao. All rights reserved.
//

#import "KAMSGridGenerator.h"

@implementation KAMSGridGenerator

+ (NSMutableArray*) generateGrid
{
    NSMutableArray *grid = [[NSMutableArray alloc] initWithCapacity:9];
    for (int row = 0; row < 9; row++) {
        NSMutableArray *rowArray = [[NSMutableArray alloc] initWithCapacity:9];
        for (int col = 0; col < 9; col++) {
            [rowArray addObject:@0];
        }
        [grid addObject:rowArray];
    }
#warning read values from file :)
    return grid;
}

@end
