//
//  BIFileContentView.m
//  BIEPubFont
//
//  Created by Bogdan Iusco on 09/06/14.
//  Copyright (c) 2014 Grigaci. All rights reserved.
//

#import "BIFileContentView.h"

@interface BIFileContentView ()

@property (nonatomic, strong, readwrite) UIButton *addCustomCssFilesButton;
@property (nonatomic, strong, readwrite) UITextView *textView;

@end


@implementation BIFileContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.addCustomCssFilesButton];
        [self addSubview:self.textView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.addCustomCssFilesButton.frame = [self addCustomCssFilesButtonFrame];
    self.textView.frame = [self textViewFrame];
}

- (void)appendText:(NSAttributedString *)text {
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    [mutableString appendAttributedString:text];
    self.textView.attributedText = mutableString;
    NSRange range = NSMakeRange(mutableString.length - 1, 1);
    [self.textView scrollRangeToVisible:range];
}

#pragma mark - Property

- (UIButton *)addCustomCssFilesButton {
    if (!_addCustomCssFilesButton) {
        _addCustomCssFilesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_addCustomCssFilesButton setTitle:@"Add custom fonts" forState:UIControlStateNormal];
    }
    return _addCustomCssFilesButton;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        _textView.editable = NO;
    }
    return _textView;
}

#pragma mark - Private methods

- (CGRect)addCustomCssFilesButtonFrame {
    const CGFloat height = CGRectGetHeight(self.bounds) / 10;
    const CGFloat coordY = CGRectGetHeight(self.bounds) - height;
    return CGRectMake(0.0, coordY, CGRectGetWidth(self.bounds), height);
}

- (CGRect)textViewFrame {
    CGRect buttonFrame = [self addCustomCssFilesButtonFrame];
    const CGFloat height = CGRectGetHeight(self.bounds) - CGRectGetHeight(buttonFrame);
    return CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), height);
}

@end
