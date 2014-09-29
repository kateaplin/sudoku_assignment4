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
#import "KAMSBestTimeView.h"
#import <AVFoundation/AVFoundation.h>
#include <AudioToolbox/AudioToolbox.h>

static float GRID_FRAME_SIZE_FACTOR = 0.8;

static float NUM_PAD_OFFSET_FACTOR = 0.1;
static float NUM_PAD_HEIGHT_FACTOR = 1.0 / 7;
static NSString *END_GAME_ALERT_TITLE = @"You've Won!";
static NSString *END_GAME_ALERT_MESSAGE =
    @"Press \"Play Again\" to start another round.";
static NSString *END_GAME_ALERT_CANCEL_BUTTON_TITLE = @"Play Again?";

static float TIME_FRAME_WIDTH = 200;
static float TIME_FRAME_Y_POSITION = 25;

@interface KAMSViewController () {
    KAMSGridView *_gridView;
    KAMSNumPadView *_numPadView;
    KAMSGridModel *_gridModel;
    KAMSStopwatchView *_stopwatchView;
    int _secondsElapsed;
    NSTimer *_timer;
    int _bestSecondsElapsed;
    KAMSBestTimeView *_bestTimeView;
    AVAudioPlayer *_clickAudioPlayer;
    AVAudioPlayer *_winGameAudioPlayer;
    AVAudioPlayer *_bgMusicPlayer;
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
    self.view.backgroundColor = [KAMSViewController backgroundColor];
    _bestSecondsElapsed = INT_MAX;
    [self initializeGridView];
    [self initializeNumPadView];
    [self initializeStopwatchView];
    [self initializeBestTimeView];
    [self initializeAudioPlayers];
    [_bgMusicPlayer play];
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
    [_winGameAudioPlayer play];
}

- (void)alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self startRound];
}

- (void)gridCellSelectedAtRow:(NSNumber*)row atColumn:(NSNumber*)column
{
    [self click];
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
    [_numPadView setTarget:self action:@selector(click)];
    [self.view addSubview:_numPadView];
}

- (void)initializeStopwatchView
{
    CGRect frame = self.view.frame;
    CGFloat overallFrameWidth = CGRectGetWidth(frame);
    CGFloat x = (overallFrameWidth / 4) - (TIME_FRAME_WIDTH / 2);
    CGRect stopwatchFrame = CGRectMake(x, TIME_FRAME_Y_POSITION,
        TIME_FRAME_WIDTH, TIME_FRAME_WIDTH / 2);
    _stopwatchView = [[KAMSStopwatchView alloc] initWithFrame:stopwatchFrame];
    [self.view addSubview:_stopwatchView];
}

- (void)initializeBestTimeView
{
    CGRect frame = self.view.frame;
    CGFloat overallFrameWidth = CGRectGetWidth(frame);
    CGFloat x = 3 * (overallFrameWidth / 4) - (TIME_FRAME_WIDTH / 2);
    CGRect stopwatchFrame = CGRectMake(x, TIME_FRAME_Y_POSITION,
        TIME_FRAME_WIDTH, TIME_FRAME_WIDTH / 2);
    _bestTimeView = [[KAMSBestTimeView alloc] initWithFrame:stopwatchFrame];
    [self.view addSubview:_bestTimeView];
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
    if (_bestSecondsElapsed > _secondsElapsed) {
        _bestSecondsElapsed = _secondsElapsed;
        [_bestTimeView setSeconds:_bestSecondsElapsed];
    }
    
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

- (void)initializeAudioPlayers
{
    // Audio source:
    // http://opengameart.org/content/click-sounds6
    // This audio is liscenced into the public domain (CC0).
    NSString *clickPath = [[NSBundle mainBundle]
        pathForResource:@"click_sound_1" ofType:@"mp3"];
    NSURL *clickURL = [NSURL fileURLWithPath:clickPath];
    _clickAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:clickURL
        error:nil];
    _clickAudioPlayer.numberOfLoops = 1;
    
    // Audio source:
    // http://opengameart.org/content/completion-sound
    // This audio is liscenced by CC 3.0.
    NSString *winPath = [[NSBundle mainBundle]
        pathForResource:@"gmae" ofType:@"wav"];
    NSURL *winURL = [NSURL fileURLWithPath:winPath];
    _winGameAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:winURL
        error:nil];
    _winGameAudioPlayer.numberOfLoops = 1;
    
    // Audio source:
    // http://opengameart.org/content/sunday-at-the-disco-scc-version
    // This audio is liscence by CC 3.0.
    NSString *bgPath = [[NSBundle mainBundle]
        pathForResource:@"Sunday at the disco SCC" ofType:@"wav"];
    NSURL *bgURL = [NSURL fileURLWithPath:bgPath];
    _bgMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:bgURL
        error:nil];
    // Infinitely loop background music.
    _bgMusicPlayer.numberOfLoops = -1;
}

- (void)click
{
    [_clickAudioPlayer play];
    NSLog(@"click sound!");
}

+ (UIColor*)backgroundColor
{
    return [UIColor colorWithRed:1.0 green:211.0 / 255.0 blue:224.0 / 255.0
        alpha:1.0];
}


@end
