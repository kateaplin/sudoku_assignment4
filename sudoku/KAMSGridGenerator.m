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
    NSString *readString = [KAMSGridGenerator readFromRandomFile];
    NSString *randomLine = [KAMSGridGenerator getRandomLine:readString];
    return [KAMSGridGenerator parseLine:randomLine];
}

/**
 * Assumes that grid1.txt and grid2.txt are available as supporting files,
 * and that these files each contain valid sudoku grids represented as
 * a line of numbers and periods.
 */
+ (NSString*) readFromRandomFile
{
    int fileNum = (arc4random() % 2) + 1;
    NSString *fileName = [[NSString alloc] initWithFormat:@"grid%d", fileNum];
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName
        ofType:@"txt"];
    NSError *error;
    NSString *readString = [[NSString alloc] initWithContentsOfFile:path
        encoding:NSUTF8StringEncoding error:&error];
    return readString;
}

/**
 * Assumes that sudokuLine is a valid sudoku grid represented as
 * a line of numbers and periods.
 */
+ (NSMutableArray*) parseLine:(NSString*)sudokuLine
{
    NSString *cleanLine =
        [sudokuLine stringByReplacingOccurrencesOfString:@"." withString:@"0"];
    NSMutableArray *grid = [[NSMutableArray alloc] initWithCapacity:9];
    for (int row = 0; row < 9; row++) {
        NSMutableArray *rowArray = [[NSMutableArray alloc] initWithCapacity:9];
        for (int col = 0; col < 9; col++) {
            int index = row * 9 + col;
            NSString *atIndex = [cleanLine
                substringWithRange:NSMakeRange(index, 1)];
            NSInteger integer = [atIndex integerValue];
            NSNumber *number = [NSNumber numberWithInteger:integer];
            [rowArray addObject:number];
        }
        [grid addObject:rowArray];
    }
    return grid;
}

/**
 * Assumes that allGrids is a string from a file where each line is a valid
 * sudoku grid represented as a line of numbers and periods.
 */
+ (NSString*) getRandomLine:(NSString*)allGrids
{
    NSArray *allLines = [allGrids componentsSeparatedByCharactersInSet:
        [NSCharacterSet newlineCharacterSet]];
    int lineNum = arc4random() % [allLines count];
    return [allLines objectAtIndex:lineNum];
}

@end
