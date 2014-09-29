//
//  KAMSNumPadView.h
//  sudoku
//
//  Created by Kathryn Aplin on 9/20/14.
//  Copyright (c) 2014 Kathryn Aplin Megan Shao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KAMSNumPadView : UIView

-(int) getCurrentValue;
-(void) setTarget:(id)target action:(SEL)action;

@end
