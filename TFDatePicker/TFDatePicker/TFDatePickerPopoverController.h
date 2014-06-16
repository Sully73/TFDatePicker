//
//  DatePickerPopoverController.h
//  ShootStudio
//
//  Created by Tom Fewster on 03/10/2011.
//  Copyright (c) 2011 Tom Fewster. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TFDatePickerPopoverController : NSViewController <NSPopoverDelegate>;

@property (strong, readonly) NSDatePicker *datePicker;
@property (strong) NSPopover *popover;
@property (weak) id <NSPopoverDelegate> delegate;
@property (assign) BOOL allowEmptyDate;
@property (assign) BOOL updateControlValueOnClose;

- (IBAction)showDatePickerRelativeToRect:(NSRect)rect inView:(NSView *)view completionHander:(void(^)(NSDate *selectedDate))completionHandler;

@end