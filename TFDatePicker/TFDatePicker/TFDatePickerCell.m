//
//  TFDatePickerCell.m
//  TFDatePicker
//
//  Created by Jonathan Mitchell on 14/05/2014.
//  Copyright (c) 2014 Tom Fewster. All rights reserved.
//

#import "TFDatePickerCell.h"
#import "TFDatePicker.h"

@implementation TFDatePickerCell

- (void)setShowsFirstResponder:(BOOL)showFR
{
    // prevent highlight from being drawn on empty
    TFDatePicker *datePicker = (id)self.controlView;
    if (datePicker.empty) {
        showFR = NO;
    }
    
    [super setShowsFirstResponder:showFR];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    controlView.layer.cornerRadius = cellFrame.size.height / 2;
    controlView.layer.borderWidth = 1.0f;
    controlView.layer.backgroundColor = [NSColor whiteColor].CGColor;
    controlView.layer.borderColor = [NSColor colorWithCalibratedRed:0.000f green:0.000f blue:0.000f alpha:0.15f].CGColor;
    controlView.layer.masksToBounds = NO;
    [super drawInteriorWithFrame:cellFrame inView:controlView];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    [super drawInteriorWithFrame:cellFrame inView:controlView];
}

@end
