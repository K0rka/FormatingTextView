//
//  EditorTextView.h
//  LJPostCreate
//
//  Created by Korovkina Ekaterina on 02.11.15.
//  Copyright © 2015 Korovkina Ekaterina. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * Типы форматирования, поддерживаемые EditorTextView
 */
typedef NS_OPTIONS(NSUInteger, EditorFormatType){
    EditorFormatTypeBold = 0,
    EditorFormatTypeItalic = 1 << 0,
    EditorFormatTypeUnderline = 1 << 2,
    EditorFormatTypeStrikethrough = 1 << 3
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
 * Делегат для получения настроек
 */
@property (nonatomic, weak) id<EditorTextViewDataSettings> settingsDelegate;

@end
