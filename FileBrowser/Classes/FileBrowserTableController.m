//
//  FileBrowserTableController.m
//  FileBrowser
//
//  Created by Mike on 16/8/2.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "FileBrowserTableController.h"
#import "FileBrowserCell.h"
#import "Masonry.h"

@interface FileBrowserTableController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation FileBrowserTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, FLT_EPSILON)];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, FLT_EPSILON)];
    tableView.sectionHeaderHeight = 0.f;
    tableView.sectionFooterHeight = 0.f;
    tableView.dataSource = self;
    tableView.delegate = self;
}

- (void)setPath:(NSString *)path {
    _path = path;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    _dataArray = [fileManager contentsOfDirectoryAtPath:path error:NULL].mutableCopy;
}

- (void)reloadData {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseId = @"reuseIdentifier";
    FileBrowserCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[FileBrowserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.fullPath = [_path stringByAppendingPathComponent:self.dataArray[indexPath.row]];
    return cell;
}

#pragma mark - tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *selectedPath = [_path stringByAppendingPathComponent:self.dataArray[indexPath.row]];
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    BOOL isDirectory = YES;
    if ([defaultManager fileExistsAtPath:selectedPath isDirectory:&isDirectory] && isDirectory) {
        if ([self.fileBrowserDelegate respondsToSelector:@selector(fileBrowserTableController:didSelectFolderWithPath:)]) {
            [self.fileBrowserDelegate fileBrowserTableController:self didSelectFolderWithPath:selectedPath];
        }
    } else {
        NSDictionary *fileAttributes = [defaultManager attributesOfItemAtPath:selectedPath error:NULL];
        if ([self.fileBrowserDelegate respondsToSelector:@selector(fileBrowserTableController:didSelectFileWithPath:fileAttributes:)]) {
            [self.fileBrowserDelegate fileBrowserTableController:self didSelectFileWithPath:selectedPath fileAttributes:fileAttributes];
        }
    }
}

@end
