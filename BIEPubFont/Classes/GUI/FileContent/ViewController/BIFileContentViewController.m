//
//  BIFileContentViewController.m
//  BIEPubFont
//
//  Created by Bogdan Iusco on 09/06/14.
//  Copyright (c) 2014 Grigaci. All rights reserved.
//

#import "BIEPubFontLib.h"
#import "OZLib.h"

#import "NSBundle+FullPath.h"
#import "NSString+CSSFile.h"
#import "NSArray+Search.h"
#import "BIFileContentViewController.h"
#import "BIFileContentView.h"

@interface BIFileContentViewController ()

@property (nonatomic, strong) BIFileContentView *fileContentView;

@end

@implementation BIFileContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.fileContentView];
    [self.fileContentView.addCustomCssFilesButton addTarget:self action:@selector(addCustonCSSFiles:) forControlEvents:UIControlEventTouchDown];
    [self addCloseButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.fileContentView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self enableAddCustomCssFilesButtonIsNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self listFileContent];
}

#pragma mark - Property

- (BIFileContentView *)fileContentView {
    if (!_fileContentView) {
        _fileContentView = [[BIFileContentView alloc] initWithFrame:self.view.bounds];
    }
    return _fileContentView;
}

- (void)setFile:(NSString *)file {
    if ([_file isEqualToString:file]) {
        return;
    }
    _file = [file copy];
    self.title = file;
}

#pragma mark - Private

- (void)addCustonCSSFiles:(id)sender {
    self.fileContentView.addCustomCssFilesButton.enabled = NO;
    NSString *fullPath = [[NSBundle mainBundle] fullPathForFile:self.file];
    BIEPubFile *epubFile = [BIEPubFile epubFileAtPath:fullPath];
    NSOrderedSet *fontSet = [NSOrderedSet orderedSetWithObjects:@"Arial", nil];
    [epubFile createFontSupportFileForFonts:fontSet];
    [self listFileContent];
}

- (void)listFileContent {
    self.fileContentView.addCustomCssFilesButton.enabled = NO;
    NSString *fullPath = [[NSBundle mainBundle] fullPathForFile:self.file];
    OZZipFile *zipFile = [[OZZipFile alloc] initWithFileName:fullPath mode:OZZipFileModeUnzip];
    NSArray *allFiles= [zipFile listFileInZipInfos];
    NSArray *allCustomCSSFiles = [self allCustomCSSFilePaths];

    [self printRegularText:@"===== Printing epub content ====="];

    for (OZFileInZipInfo *fileInZip in allFiles) {
        NSString *fileName = fileInZip.name;
        if ([allCustomCSSFiles containsString:fileName]) {
            [self printCustomCSSFilePath:fileName];
        } else if ([fileName isCSSFile]) {
            [self printOriginalCSSFilePath:fileName];
        } else {
            [self printRegularText:fileName];
        }
    }
    [self printRegularText:@"===== Finished =====\n"];
    [self enableAddCustomCssFilesButtonIsNeeded];
}

- (void)enableAddCustomCssFilesButtonIsNeeded {
    NSString *fullPath = [[NSBundle mainBundle] fullPathForFile:self.file];
    BIEPubFile *epubFile = [BIEPubFile epubFileAtPath:fullPath];
    self.fileContentView.addCustomCssFilesButton.enabled = ![epubFile doesEPubContainFontSupportFile];
}

- (void)addCloseButton {
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(closeButtonPressed:)];
    self.navigationItem.rightBarButtonItem = closeButton;
}

- (void)closeButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray *)allCustomCSSFilePaths {
    NSMutableArray *allCustomCSSFiles = [NSMutableArray new];
    NSString *fullPath = [[NSBundle mainBundle] fullPathForFile:self.file];
    BIEPubFile *epubFile = [BIEPubFile epubFileAtPath:fullPath];
    BIFontSupportFile *fontSupportFile = epubFile.fontSupportFile;
    if (!fontSupportFile) {
        return @[];
    }
    NSArray *allOriginalCssFiles = [fontSupportFile allOriginalCSSFiles];
    for (NSString *originalCSSFile in allOriginalCssFiles) {
        NSArray *associatedCSSFiles = [fontSupportFile allCustomCSSFilesFor:originalCSSFile];
        [allCustomCSSFiles addObjectsFromArray:associatedCSSFiles];
    }
    return allCustomCSSFiles;
}

- (void)printRegularText:(NSString *)text {
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    [self printText:text withAttributes:attributes];
}

- (void)printOriginalCSSFilePath:(NSString *)text {
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor blueColor]};
    [self printText:text withAttributes:attributes];
}

- (void)printCustomCSSFilePath:(NSString *)text {
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor greenColor]};
    [self printText:text withAttributes:attributes];
}

- (void)printText:(NSString *)text withAttributes:(NSDictionary *)attributes {
    NSString *modifiedText = [NSString stringWithFormat:@"%@\n", text];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:modifiedText attributes:attributes];
    [self.fileContentView appendText:attributedString];
}

@end
