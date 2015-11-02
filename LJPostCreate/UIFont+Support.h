//
//  UIFont+Support.h
//  LJPostCreate
//
//  Created by Korovkina Ekaterina on 08.05.15.
//  Copyright (c) 2015 Korovkina Ekaterina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Support)


- (UIFont *)invertBoldPropertyForCurrentFont;
- (UIFont *)invertItalicPropertyForCurrentFont;
- (UIFont *)boldFontFromCurrent;
- (UIFont *)italicFontFromCurrent;

@end
