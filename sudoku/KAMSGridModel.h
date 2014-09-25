//
//  KAMSGridModel.h
//  sudoku
//
//  Created by Kathryn Aplin on 9/20/14.
//  Copyright (c) 2014 Kathryn Aplin Megan Shao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KAMSGridModel : NSObject

-(void) generateGrid;
-(void) useGrid:(int[9][9]) grid;
-(int) getValueAtRow:(int)row atColumn:(int)column;
-(void) setValueAtRow:(int)row atColumn:(int)column toValue:(int)value;
-(BOOL) isMutableAtRow:(int)row atColumn:(int)column;
-(BOOL) isConsistentAtRow:(int)row atColumn:(int)column forValue:(int)value;
-(BOOL) isRowConsistentAtRow:(int)row forValue:(int)value;
-(BOOL) isColumnConsistentAtColumn:(int)column forValue:(int) value;
-(BOOL) isBlockConsistentAtRow:(int)row atColumn:(int)column
    forValue:(int)value;
-(BOOL) isGridFull;
@end
