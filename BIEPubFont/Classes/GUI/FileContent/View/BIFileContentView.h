//
//  BIFileContentView.h
//  BIEPubFont
//
//  Created by Bogdan Iusco on 09/06/14.
//  Copyright (c) 2014 Grigaci. All rights reserved.
//

@import UIKit;

@interface BIFileContentView : UIView

@property (nonatomic, strong, readonly) UIButton *addCustomCssFilesButton;
@property (nonatomic, strong, readonly) UITextView *textView;

- (void)appendText:(NSAttributedString *)text;

@end
