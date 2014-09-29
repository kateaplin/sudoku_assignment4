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
#import "KAMSStopwatchView.h"


static float GRID_FRAME_SIZE_FACTOR = 0.8;

static float NUM_PAD_OFFSET_FACTOR = 0.1;
static float NUM_PAD_HEIGHT_FACTOR = 1.0 / 7;
static NSString *END_GAME_ALERT_TITLE = @"You've Won!";
static NSString *END_GAME_ALERT_MESSAGE =
    @"Press \"Play Again\" to start another round.";
static NSString *END_GAME_ALERT_CANCEL_BUTTON_TITLE = @"Play Again?";

static float STOPWATCH_FRAME_WIDTH = 100;
static float STOPWATCH_FRAME_Y_POSITION = 25;

@interface KAMSViewController () {
    KAMSGridView *_gridView;
    KAMSNumPadView *_numPadView;
    KAMSGridModel *_gridModel;
    KAMSStopwatchView *_stopwatchView;
    int _secondsElapsed;
    NSTimer *_timer;
}

@end

@implementation KAMSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    [self initializeStopwatchView];
    [self startRound];
}

-(void) startRound
{
    [_gridView clearCells];
    [self initializeGridModel];
    [self setInitialGridValues];
    [self startStopwatch];
}

-(void) endRound
{
    [self stopStopwatch];
    UIAlertView *winMessage = [[UIAlertView alloc]
        initWithTitle:END_GAME_ALERT_TITLE message:END_GAME_ALERT_MESSAGE
        delegate:self cancelButtonTitle:END_GAME_ALERT_CANCEL_BUTTON_TITLE
        otherButtonTitles: nil];
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
    
    [_gridView setTarget:self
        action:@selector(gridCellSelectedAtRow:atColumn:)];
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

- (void)initializeStopwatchView
{
    CGRect frame = self.view.frame;
    CGFloat overallFrameWidth = CGRectGetWidth(frame);
    CGFloat x = (overallFrameWidth / 4) - (STOPWATCH_FRAME_WIDTH / 2);
    CGRect stopwatchFrame = CGRectMake(x, STOPWATCH_FRAME_Y_POSITION,
        STOPWATCH_FRAME_WIDTH, STOPWATCH_FRAME_WIDTH / 2);
    _stopwatchView = [[KAMSStopwatchView alloc] initWithFrame:stopwatchFrame];
    [self.view addSubview:_stopwatchView];
}

- (void)startStopwatch
{
    _secondsElapsed = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
        selector:@selector(tick:) userInfo:nil repeats:YES];
}

- (void)tick:(NSTimer*)timer
{
    _secondsElapsed++;
    [_stopwatchView setSeconds:_secondsElapsed];
}

- (void)stopStopwatch
{
    [_timer invalidate];
    _timer = nil;
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
