//
//  UIFont+Support.m
//  LJPostCreate
//
//  Created by Korovkina Ekaterina on 08.05.15.
//  Copyright (c) 2015 Korovkina Ekaterina. All rights reserved.
//

#import "UIFont+Support.h"

@implementation UIFont (Support)

//==========================================================================================
- (UIFont *)invertBoldPropertyForCurrentFont
{
    CGFloat fontSize = [self pointSize];
    UIFontDescriptor * fontD = self.fontDescriptor;
    
    fontD = [fontD fontDescriptorWithSymbolicTraits:fontD.symbolicTraits ^  UIFontDescriptorTraitBold];
    
    UIFont *font = [UIFont fontWithDescriptor:fontD size:fontSize];
    return font;
}


//==========================================================================================
- (UIFont *)invertItalicPropertyForCurrentFont
{
    CGFloat fontSize = [self pointSize];
    UIFontDescriptor * fontD = self.fontDescriptor;
     
    fontD = [fontD fontDescriptorWithSymbolicTraits:fontD.symbolicTraits ^  UIFontDescriptorTraitItalic];

    UIFont *font = [UIFont fontWithDescriptor:fontD size:fontSize];
    return font;
}

@end
