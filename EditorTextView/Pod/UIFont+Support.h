//
//  UIFont+Support.h
//  LJPostCreate
//
//  Created by Korovkina Ekaterina on 08.05.15.
//  Copyright (c) 2015 Korovkina Ekaterina. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * Category on fonts with additional helpers
 */
@interface UIFont (Support)

/*
 * Returns font with the same as current except for Bold property: 
 * if the font is bold, function returns non-bold version and vice versa
 */
- (UIFont *)invertBoldPropertyForCurrentFont;

/*
 * Returns font with the same as current except for Italic property:
 * if the font is italic, function returns non-bold version and vice versa
 */
- (UIFont *)invertItalicPropertyForCurrentFont;

/*
 * Returns font with the same as current with switched on Bold property:
 * if the font is bold, function returns itself, else it returns font with added Bold property
 */
- (UIFont *)boldFontFromCurrent;

/*
 * Returns font with the same as current with switched on Italic property:
 * if the font is italic, function returns itself, else it returns font with added Italic property
 */
- (UIFont *)italicFontFromCurrent;

@end
