//
//  ViewController.m
//  LJPostCreate
//
//  Created by Korovkina Ekaterina on 08.05.15.
//  Copyright (c) 2015 Korovkina Ekaterina. All rights reserved.
//

#import "ViewController.h"
#import "UIFont+Support.h"
#import <CoreLocation/CoreLocation.h>


typedef NS_ENUM(NSUInteger, FontStyleType) {
    FontStyleTypeBold,
    FontStyleTypeItalic
};


@interface ViewController () <UITextViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *editTextView;


@property (assign, nonatomic) BOOL shoudUseUnderlineText;
@property (assign, nonatomic) BOOL shouldUseStrikeText;
@property (assign, nonatomic) NSRange prevSelectedRange;
@property (nonatomic, strong)  CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self restorePostIfExist];
    
    // Add wiki button to UIMenuController
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    UIMenuItem *boldItem = [[UIMenuItem alloc] initWithTitle:@"Bold" action:@selector(setSelectionBold:)];
    UIMenuItem *italicItem = [[UIMenuItem alloc] initWithTitle:@"Italic" action:@selector(setSelectionItalic:)];
    UIMenuItem *strikeItem = [[UIMenuItem alloc] initWithTitle:@"Strike" action:@selector(setSelectionStrike:)];
    UIMenuItem *underlineItem = [[UIMenuItem alloc] initWithTitle:@"Underline" action:@selector(setSelectionUnderline:)];
//    UIMenuItem *linkItem = [[UIMenuItem alloc] initWithTitle:nil action:@selector(setLink:)];
//    [linkItem set];
    [menuController setMenuItems:@[boldItem, italicItem, strikeItem, underlineItem]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)restorePostIfExist
{
    [self.editTextView setText:nil];
}

#pragma mark - UITextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    UIFont *currentFont = textView.font;
    NSMutableDictionary *firstAttr = [NSMutableDictionary new];
    
    NSNumber *underlineValue = @0;
    NSNumber *strikeValue = @0;
    NSRange underlineEffectiveRange = NSMakeRange(0, 0);
    NSRange strikeEffectiveRange = NSMakeRange(0, 0);

    
    if (!text.length) {
        return YES;
    }
    if (textView.attributedText.length) {
        underlineValue =[textView.attributedText attribute:NSUnderlineStyleAttributeName atIndex:range.location-1 effectiveRange:&underlineEffectiveRange];
        strikeValue =[textView.attributedText attribute:NSStrikethroughStyleAttributeName atIndex:range.location-1 effectiveRange:&strikeEffectiveRange];
        firstAttr = [[textView.attributedText attributesAtIndex:range.location-1 effectiveRange:nil] mutableCopy];
    }
    
    BOOL didChangeText = NO;
    NSMutableAttributedString *attrString = [textView.attributedText mutableCopy];
    [attrString insertAttributedString:[[NSAttributedString alloc] initWithString:text] atIndex:range.location];

    
    if (self.shoudUseUnderlineText) {
        //if we keep continue underlying, then we'll use WIDE range for set underline attribute
        BOOL didContinueUnderline = underlineEffectiveRange.length && [underlineValue integerValue]>0;
        NSRange rangeToApplyUnderline = NSMakeRange(didContinueUnderline ? underlineEffectiveRange.location : range.location, (didContinueUnderline? underlineEffectiveRange.length : 0)+text.length);

        [attrString addAttribute:NSUnderlineStyleAttributeName value:@1 range:rangeToApplyUnderline];

        didChangeText = YES;
    }
    else if (!self.shoudUseUnderlineText && (underlineValue.integerValue && underlineEffectiveRange.length+underlineEffectiveRange.location == range.location)) {
        [attrString addAttribute:NSUnderlineStyleAttributeName value:@(0) range:range];

        didChangeText = YES;
    }
    if (self.shouldUseStrikeText) {
        BOOL didContinueStrike = strikeEffectiveRange.length && [strikeValue integerValue]>0;
        NSRange rangeToApplyStrike = NSMakeRange(didContinueStrike ? strikeEffectiveRange.location : range.location, (didContinueStrike? strikeEffectiveRange.length : 0)+text.length);
        
        [attrString addAttribute:NSStrikethroughStyleAttributeName value:@1 range:rangeToApplyStrike];

        didChangeText = YES;
    }
    else if (!self.shouldUseStrikeText && (strikeValue.integerValue && strikeEffectiveRange.length+strikeEffectiveRange.location == range.location)) {
        [attrString addAttribute:NSStrikethroughStyleAttributeName value:@(0) range:range];
        didChangeText = YES;
    }
    
    
    if (didChangeText) {
        
        
        [attrString addAttributes:firstAttr range:range];
        [attrString addAttribute:NSFontAttributeName value:currentFont range:NSMakeRange(range.location, text.length)];
        
        [textView setAttributedText:[attrString copy]];
        [textView setSelectedRange:NSMakeRange(range.location+text.length, 0)];
    }
    
    return !didChangeText;
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    NSRange range = textView.selectedRange;
    if (textView.attributedText.length && range.location != self.prevSelectedRange.location+1 && range.location > 1) {
        
        NSNumber *underlineValue = @0;
        NSNumber *strikeValue = @0;
        underlineValue =[textView.attributedText attribute:NSUnderlineStyleAttributeName atIndex:range.location-1 effectiveRange:nil];
        strikeValue =[textView.attributedText attribute:NSStrikethroughStyleAttributeName atIndex:range.location-1 effectiveRange:nil];
        self.shoudUseUnderlineText = [underlineValue integerValue] > 0;
        self.shouldUseStrikeText = [strikeValue integerValue] > 0;
    }
    self.prevSelectedRange = range;
}

#pragma mark - Additional Menu Items Selector
//==========================================================================================
- (void)setSelectionBold:(id)sender
{
    [self setSelectionStyleWithType:FontStyleTypeBold];
}

//==========================================================================================
- (void)setSelectionItalic:(id)sender
{
    [self setSelectionStyleWithType:FontStyleTypeItalic];
}


- (void)setSelectionStyleWithType:(FontStyleType)type {
    NSRange selectedRange = self.editTextView.selectedRange;
    
    NSMutableAttributedString *selectedString = [[self.editTextView.attributedText attributedSubstringFromRange:self.editTextView.selectedRange] mutableCopy];
    NSMutableAttributedString *currentString = [self.editTextView.attributedText mutableCopy];
    
    //Если будем менять шрифт для еще не набранного текста, просто получаем текущее значение шрифта у последнего элемента перед кареткой
    if (!selectedString.length) {
        UIFont *currentFont = currentString.length?[self.editTextView.attributedText attributesAtIndex:selectedRange.location-1 effectiveRange:nil][NSFontAttributeName]:self.editTextView.font;
        UIFont *invertedFont = [self fontWithInvertedType:type fromFont:currentFont];
        NSAttributedString *attributedStringWithCorrectFont = [[NSAttributedString alloc] initWithString:@"\u200b" attributes:@{NSFontAttributeName : invertedFont}];
        [currentString insertAttributedString:attributedStringWithCorrectFont atIndex:selectedRange.location];
        selectedRange = NSMakeRange(selectedRange.location+1, selectedRange.length);
    }
    
    //Для выделенного блока текста проходим в нем по всем значениям шрифта и инвертируем их значение Italic аттрибута
    else
    {
        NSMutableAttributedString *updationString = [selectedString mutableCopy];
        [selectedString enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, selectedString.length) options:0 usingBlock:^(UIFont *value, NSRange range, BOOL *stop) {
            [updationString addAttribute:NSFontAttributeName value:[self fontWithInvertedType:type fromFont:value] range:range];
        }];
        [currentString replaceCharactersInRange:self.editTextView.selectedRange withAttributedString:updationString];
    }
    [self.editTextView setAttributedText:currentString];
    
    //Возвращаем каретку на место
    self.editTextView.selectedRange = selectedRange;
}

- (UIFont *)fontWithInvertedType:(FontStyleType)fontStyle fromFont:(UIFont *)font {
    switch (fontStyle) {
        case FontStyleTypeBold:
            return [font invertBoldPropertyForCurrentFont];
            break;
        case FontStyleTypeItalic:
            return [font invertItalicPropertyForCurrentFont];
        default:
            break;
    }
}

//==========================================================================================
- (void)setSelectionStrike:(id)sender
{
    NSAttributedString *selectedString = [self.editTextView.attributedText attributedSubstringFromRange:self.editTextView.selectedRange];
    NSMutableAttributedString *newString = [[NSMutableAttributedString alloc] initWithAttributedString:selectedString];
    NSMutableAttributedString *currentString = self.editTextView.attributedText.length ? [self.editTextView.attributedText mutableCopy] : [NSMutableAttributedString new];
    
    if (selectedString.length) {
        [selectedString enumerateAttribute:NSStrikethroughStyleAttributeName inRange:NSMakeRange(0, selectedString.length) options:0 usingBlock:^(NSNumber *value, NSRange range, BOOL *stop) {
            [newString addAttribute:NSStrikethroughStyleAttributeName value:[value integerValue] ? @0 : @1 range:range];
        }];
        
        [currentString replaceCharactersInRange:self.editTextView.selectedRange withAttributedString:newString];
        [self.editTextView setAttributedText:currentString];
    }
    else
    {
        self.shouldUseStrikeText = !self.shouldUseStrikeText;
    }

}

//==========================================================================================
- (void)setSelectionUnderline:(id)sender
{
    NSAttributedString *selectedString = [self.editTextView.attributedText attributedSubstringFromRange:self.editTextView.selectedRange];
    NSMutableAttributedString *newString = [[NSMutableAttributedString alloc] initWithAttributedString:selectedString];
    if (selectedString.length) {
        [selectedString enumerateAttribute:NSUnderlineStyleAttributeName inRange:NSMakeRange(0, selectedString.length) options:0 usingBlock:^(NSNumber *value, NSRange range, BOOL *stop) {
            [newString addAttribute:NSUnderlineStyleAttributeName value:[value integerValue] ? @0 : @1 range:range];
            
        }];
        
        NSMutableAttributedString *currentString = [self.editTextView.attributedText mutableCopy];
        [currentString replaceCharactersInRange:self.editTextView.selectedRange withAttributedString:newString];
        [self.editTextView setAttributedText:currentString];
    }
    else
    {
        self.shoudUseUnderlineText = !self.shoudUseUnderlineText;
    }
    
}
@end
