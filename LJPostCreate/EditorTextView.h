//
//  EditorTextView.h
//  LJPostCreate
//
//  Created by Korovkina Ekaterina on 02.11.15.
//  Copyright © 2015 Korovkina Ekaterina. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * Selectors NAMES in case you want to write your own Menu Controller, or any other method to add formatting to text
 * All methods take Exectly ONE argument (the sender of the action), it can be nil.
 */
extern NSString *const kSetSelectionBoldSelectorName;
extern NSString *const kSetSelectionItalicSelectorName;
extern NSString *const kSetSelectionStrikethroughSelectorName;
extern NSString *const kSetSelectionUnderlineSelectorName;

/*
 * Типы форматирования, поддерживаемые EditorTextView
 */
typedef NS_OPTIONS(NSUInteger, EditorFormatType){
    EditorFormatTypeBold = 1 << 0,
    EditorFormatTypeItalic = 1 << 2,
    EditorFormatTypeUnderline = 1 << 3,
    EditorFormatTypeStrikethrough = 1 << 4,
    EditorFormatTypeAll = EditorFormatTypeBold | EditorFormatTypeItalic | EditorFormatTypeStrikethrough | EditorFormatTypeUnderline
};

/*
 * протокол настройки возможностей TextEditor
 */
@protocol EditorTextViewDataSettings <NSObject>

@optional
/*
 * Метод запроса поддерживаемых типов форматирования для TextEditor. 
 * Если делегат не реализует этот метод, по умолчанию будут поддержаны все
 */
- (EditorFormatType)supportedTextEditorParameters;

@end


@interface EditorTextView : UITextView

/*
 * Delegate to get Text Editor Settings
 */
@property (nonatomic, weak) id<EditorTextViewDataSettings> settingsDelegate;


#pragma mark - Protected Methods
/*
 * Method is used to configure menuController, which is used to add control to format text
 * Overwrite it, in case you need your custom MenuController
 */
- (void)configureFormatingMenuControllerForTextView;
@end
