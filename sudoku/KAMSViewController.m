//
//  KAMSViewController.m
//  sudoku
//
//  Created by Megan Shao on 9/11/14.
//  Copyright (c) 2014 Kathryn Aplin Megan Shao. All rights reserved.
//

#import "KAMSViewController.h"
#import "KAMSGridView.h"
#import "KAMSNumPadView.h"
#import "KAMSGridModel.h"


static float GRID_FRAME_SIZE_FACTOR = 0.8;

static float NUM_PAD_OFFSET_FACTOR = 0.1;
static float NUM_PAD_HEIGHT_FACTOR = 1.0 / 7;

@interface KAMSViewController () {
    KAMSGridView *_gridView;
    KAMSNumPadView *_numPadView;
    KAMSGridModel *_gridModel;
}

@end

@implementation KAMSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self startGame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) startGame
{
    [self initializeGridView];
    [self initializeNumPadView];
    [self startRound];
}

-(void) startRound
{
    [_gridView clearCells];
    [self initializeGridModel];
    [self setInitialGridValues];
}

-(void) endRound
{
    NSLog(@"inside end round");
    UIAlertView *winMessage = [[UIAlertView alloc] initWithTitle:@"title!" message:@"message" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles: nil];
    [winMessage show];
    
}

- (void)alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self startRound];
}

- (void)gridCellSelectedAtRow:(NSNumber*)row atColumn:(NSNumber*)column
{
    int rowIntVal = [row intValue];
    int colIntVal = [column intValue];
    
    if ([_gridModel isMutableAtRow:rowIntVal atColumn:colIntVal]) {
        int selectedNumber = [_numPadView getCurrentValue];
        if ([_gridModel isConsistentAtRow:rowIntVal atColumn:colIntVal
            forValue:selectedNumber]) {
            [_gridModel setValueAtRow:rowIntVal atColumn:colIntVal
                toValue:selectedNumber];
            [_gridView setValueAtRow:rowIntVal atColumn:colIntVal
                toValue:selectedNumber];
            
            if ([_gridModel isGridFull]) {
                [self endRound];
            }
        }
    }
}

// Uses code from ViewTutorial (Assignment 3).
- (void)initializeGridView
{
    float offsetFactor = (1 - GRID_FRAME_SIZE_FACTOR) / 2.0;
    
    CGRect frame = self.view.frame;
    CGFloat x = CGRectGetWidth(frame) * offsetFactor;
    CGFloat y = CGRectGetHeight(frame) * offsetFactor;
    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame))
        * GRID_FRAME_SIZE_FACTOR;
    CGRect gridFrame = CGRectMake(x, y, size, size);
    
    _gridView = [[KAMSGridView alloc] initWithFrame:gridFrame];
    
    [_gridView setTarget:self action:@selector(gridCellSelectedAtRow:atColumn:)];
    [self.view addSubview:_gridView];
}

- (void)initializeNumPadView
{
    float offsetFactor = (1 - GRID_FRAME_SIZE_FACTOR) / 2.0;
    
    CGRect frame = self.view.frame;
    CGFloat x = CGRectGetWidth(frame) * offsetFactor;
    CGFloat y = CGRectGetHeight(frame) * offsetFactor;
    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame))
    * GRID_FRAME_SIZE_FACTOR;
    CGRect gridFrame = CGRectMake(x, y + size + (size * NUM_PAD_OFFSET_FACTOR),
        size, size * NUM_PAD_HEIGHT_FACTOR);
    
    _numPadView = [[KAMSNumPadView alloc] initWithFrame:gridFrame];
    [self.view addSubview:_numPadView];
}

- (void)setInitialGridValues
{
    for (int col = 0; col < 9; ++col) {
        for (int row = 0; row < 9; ++row) {
            int value = [_gridModel getValueAtRow:row atColumn:col];
            // 0 represents an empty cell
            if (value != 0) {
                [_gridView setInitialValueAtRow:row atColumn:col toValue:value];
            }
        }
    }
}

- (void)initializeGridModel
{
    _gridModel = [[KAMSGridModel alloc] init];
    [_gridModel generateGrid];
}
@end
