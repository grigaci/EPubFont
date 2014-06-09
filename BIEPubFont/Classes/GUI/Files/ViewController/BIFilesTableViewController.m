//
//  BIFilesTableViewController.m
//  BIEPubFont
//
//  Created by Bogdan Iusco on 09/06/14.
//  Copyright (c) 2014 Grigaci. All rights reserved.
//

#import "BIEPubFontLib.h"

#import "BIFilesTableViewController.h"
#import "BIFIlesTableViewCell.h"
#import "BIFileContentViewController.h"
#import "NSBundle+FullPath.h"

@interface BIFilesTableViewController ()

@property (nonatomic, strong) NSOrderedSet *files;
@property (nonatomic, copy) NSString *cellIdentifier;

@end

@implementation BIFilesTableViewController

#pragma mark - UIViewController methods

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Available files";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[BIFilesTableViewCell class] forCellReuseIdentifier:self.cellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadCellAccessoryTypes];
}

#pragma mark - UITableViewDatasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.files count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BIFilesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    cell.file = [self.files objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BIFileContentViewController *viewController = [[BIFileContentViewController alloc] initWithNibName:nil bundle:nil];
    viewController.file = [self.files objectAtIndex:indexPath.row];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navController animated:YES completion:nil];

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    BIFilesTableViewCell *filesCell = (BIFilesTableViewCell *)cell;
    [self setAccessoryTypeForCell:filesCell];
}

#pragma mark - Property

- (NSOrderedSet *)files {
    if (!_files) {
        _files = [NSOrderedSet orderedSetWithObjects:@"accessible_epub_3-20121024.epub", nil];
    }
    return _files;
}

- (NSString *)cellIdentifier {
    if (!_cellIdentifier) {
        _cellIdentifier = NSStringFromClass([self class]);
    }
    return _cellIdentifier;
}

#pragma mark - Private methods

- (void)reloadCellAccessoryTypes {

    NSArray *visibleCellIndexPaths = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visibleCellIndexPaths) {
        BIFilesTableViewCell *cell = (BIFilesTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [self setAccessoryTypeForCell:cell];
    }
}

- (void)setAccessoryTypeForCell:(BIFilesTableViewCell *)cell {
    NSString *fullPath = [[NSBundle mainBundle] fullPathForFile:cell.file];
    BIEPubFile *epubFile = [BIEPubFile epubFileAtPath:fullPath];
    UITableViewCellAccessoryType type = [epubFile doesEPubContainFontSupportFile] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cell.accessoryType = type;
}

@end
