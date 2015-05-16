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
   
    NSRect myRect = NSMakeRect(NSMinX(cellFrame) + 0.5, NSMinY(cellFrame) + 0.5, NSWidth(cellFrame) -20.0, NSHeight(cellFrame) - 1.0);
    // Rectangle Drawing
    CGFloat radius = (NSHeight(myRect) - 1.0) / 2;
    NSBezierPath* rectanglePath = [NSBezierPath bezierPathWithRoundedRect:myRect xRadius:radius yRadius:radius];
    [NSColor.whiteColor setFill];
    [rectanglePath fill];
    [[NSColor colorWithCalibratedRed:0.000f green:0.000f blue:0.000f alpha:0.15f] setStroke];
    [rectanglePath setLineWidth: 1];
    [rectanglePath stroke];
    
    [super drawWithFrame:cellFrame inView:controlView];
}


@end
