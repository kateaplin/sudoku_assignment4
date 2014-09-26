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

+ (NSMutableArray*) parseLine:(NSString*)sudokuLine
{
    NSMutableArray *grid = [[NSMutableArray alloc] initWithCapacity:9];
    for (int row = 0; row < 9; row++) {
        NSMutableArray *rowArray = [[NSMutableArray alloc] initWithCapacity:9];
        for (int col = 0; col < 9; col++) {
            int index = row * 9 + col;
            NSString *atIndex = [sudokuLine
                substringWithRange:NSMakeRange(index, 1)];
            NSInteger integer = [atIndex integerValue];
            NSNumber *number = [NSNumber numberWithInteger:integer];
            [rowArray addObject:number];
        }
        [grid addObject:rowArray];
    }
    return grid;
}

+ (NSString*) getRandomLine:(NSString*)allGrids
{
    NSArray *allLines = [allGrids componentsSeparatedByCharactersInSet:
        [NSCharacterSet newlineCharacterSet]];
    int lineNum = arc4random() % [allLines count];
    return [allLines objectAtIndex:lineNum];
}

@end
