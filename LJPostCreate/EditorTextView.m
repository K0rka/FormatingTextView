//
//  EditorTextView.m
//  LJPostCreate
//
//  Created by Korovkina Ekaterina on 02.11.15.
//  Copyright © 2015 Korovkina Ekaterina. All rights reserved.
//

#import "EditorTextView.h"

@implementation EditorTextView

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)configureFormatingMenuForTextView {
    
    EditorFormatType supportedFormatType;
    
    if ([self.settingsDelegate respondsToSelector:@selector(supportedTextEditorParameters)]) {
        supportedFormatType = [self.settingsDelegate supportedTextEditorParameters];
    }
    
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
@end
