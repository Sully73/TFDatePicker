//
//  DatePickerTextField.m
//  ShootStudio
//
//  Created by Tom Fewster on 16/06/2010.
//  Copyright 2010 Tom Fewster. All rights reserved.
//

#import "TFDatePicker.h"
#import "TFDatePickerCell.h"
#import "TFDatePickerPopoverController.h"

NSInteger buttonPadding = 3;
NSInteger buttonSize = 16;

@interface TFDatePicker ()
@property (strong) NSLayoutConstraint *widthConstraint;
@property (strong) TFDatePickerPopoverController *datePickerViewController;
@property (nonatomic) BOOL empty;
@property (strong) NSColor *prevTextColor;

- (void)performClick:(id)sender;
@end

@implementation TFDatePicker

@synthesize widthConstraint = _widthConstraint;
@synthesize datePickerViewController = _datePickerViewController;

+ (void)initialize
{
    // this is ignored when unarchiving from a nib
    [self setCellClass:[TFDatePickerCell class]];
}

- (void)awakeFromNib
{
    // cell class warning
    if (![self.cell isKindOfClass:[TFDatePickerCell class]]) {
        NSLog(@"%@ requires cell of class %@ to be set in the nib in order to function correctly", [self className], [[[self class] cellClass] className]);
    }
    
    // button
	NSButton *showPopoverButton = [[NSButton alloc] initWithFrame:NSZeroRect];
	showPopoverButton.buttonType = NSMomentaryChangeButton;
	showPopoverButton.bezelStyle = NSInlineBezelStyle;
	showPopoverButton.bordered = NO;
	showPopoverButton.imagePosition = NSImageOnly;

	NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
	showPopoverButton.image = [frameworkBundle imageForResource:@"calendar"];
	[showPopoverButton.cell setHighlightsBy:NSContentsCellMask];

	[showPopoverButton setTranslatesAutoresizingMaskIntoConstraints:NO];
	showPopoverButton.target = self;
	showPopoverButton.action = @selector(performClick:);
	[self addSubview:showPopoverButton];

    // button constraints
    // TODO: this only works when unarchiving. Refactor so that these constraints get added and removed when datePickerStyle is set.
	NSDictionary *views = NSDictionaryOfVariableBindings(showPopoverButton);
    if ([self.cell datePickerStyle] == NSTextFieldAndStepperDatePickerStyle) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[showPopoverButton(16)]-(20)-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(3)-[showPopoverButton(16)]" options:0 metrics:nil views:views]];
        
    } else {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[showPopoverButton(16)]-(4)-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(-2)-[showPopoverButton(16)]" options:0 metrics:nil views:views]];
    }
}

#pragma mark -
#pragma mark Auto layout

- (NSSize)intrinsicContentSize
{
    NSSize size = [super intrinsicContentSize];
    
   return NSMakeSize(size.width + 22.0f, size.height);
}

#pragma mark -
#pragma mark NSDatePickerCellDelegate

- (void)datePickerCell:(NSDatePickerCell *)aDatePickerCell validateProposedDateValue:(NSDate **)proposedDateValue timeInterval:(NSTimeInterval *)proposedTimeInterval {
	if (self.delegate) {
		[self.delegate datePickerCell:aDatePickerCell validateProposedDateValue:proposedDateValue timeInterval:proposedTimeInterval];
	}
}

#pragma mark -
#pragma mark Actions

- (void)performClick:(id)sender {
    
    if (self.datePickerViewController) {
        return;
    }
    
    self.datePickerViewController = [[TFDatePickerPopoverController alloc] init];
    
	if (self.isEnabled) {
        
        if (self.empty) {
            [self updateControlValue:[self referenceDate]];
        }
        
		self.datePickerViewController.datePicker.dateValue = self.dateValue;
		[self.datePickerViewController.datePicker setDatePickerElements:self.datePickerElements];
		self.datePickerViewController.delegate = self;
        self.datePickerViewController.allowEmptyDate = self.allowEmptyDate;
        
		[_datePickerViewController showDatePickerRelativeToRect:[sender bounds] inView:sender completionHander:^(NSDate *selectedDate) {
            
            [self updateControlValue:selectedDate];
            
		}];
	}
}


#pragma mark -
#pragma mark NSPopoverDelegate

- (void)popoverDidClose:(NSNotification *)notification
{
    self.datePickerViewController = nil;
}

#pragma mark -
#pragma mark Accessors

- (void)setDatePickerElements:(NSDatePickerElementFlags)elementFlags
{
    [super setDatePickerElements:elementFlags];
    [self invalidateIntrinsicContentSize];
}

- (void)setDateValue:(NSDate *)newStartDate
{
    if (self.allowEmptyDate) {
        self.empty = !newStartDate || (id)newStartDate == [NSNull null] ? YES : NO;
    } else {
        self.empty = NO;
    }
    
    if (self.empty) {
        newStartDate = [NSDate distantFuture];
        [self setNeedsDisplay];
    }
    
    [super setDateValue:newStartDate];
}

- (NSDate *)dateValue
{
    if (self.empty) {
        return nil;
    }
    
    return [super dateValue];
}

- (void)setEmpty:(BOOL)empty
{
    if (!self.allowEmptyDate) {
        empty = NO;
    }
    
    _empty = empty;
    
    // there is no effective way of overridding the cell interior drawing (believe me, I really really tried)
    // hence we camouflage the text.
    if (empty) {
        self.prevTextColor = self.textColor;
        self.textColor = self.backgroundColor;
    } else {
        if (self.prevTextColor) {
            self.textColor = self.prevTextColor;
        }
    }
}

- (NSDate *)referenceDate
{
    return [NSDate dateWithTimeIntervalSinceReferenceDate:0];
}

#pragma mark -
#pragma mark Binding support

- (void)updateControlValue:(NSDate *)date
{
    // if we have bindings, update the bound "value", otherwise just update the value in the datePicker
    NSDictionary *bindingInfo = [self infoForBinding:@"value"];
    if (bindingInfo) {
        NSString *keyPath = [bindingInfo valueForKey:NSObservedKeyPathKey];
        [[bindingInfo objectForKey:NSObservedObjectKey] setValue:date forKeyPath:keyPath];
        
    } else {
        self.dateValue = date;
    }
}

#pragma mark -
#pragma mark Event handling

- (void)keyDown:(NSEvent *)theEvent
{
    if (self.empty) {
        [self updateControlValue:[self referenceDate]];
    }
    [super keyDown:theEvent];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    // TODO: add a context menu to allow clearing of current date
    if (self.empty) {
        [self updateControlValue:[self referenceDate]];
    }
    [super mouseDown:theEvent];
}

@end
