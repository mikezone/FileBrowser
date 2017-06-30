//
//  FormFillSubpageViewController.m
//  zichan
//
//  Created by Mike on 16/6/26.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "FileBrowserViewController.h"
#import "UIView+AdjustFrame.h"
#import "Masonry.h"
#import "FileBrowserCell.h"
#import "FileBrowserTableController.h"

#define MAIN_GREEN_COLOR ([UIColor colorWithRed:0.184313 green:0.725490 blue:0.615686 alpha:1.f])
#define kTopScrollHeight (40.f)

@interface FileBrowserViewController () <FileBrowserDelegate>

@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) NSMutableArray *levelPageStack;
@property (nonatomic, weak) UIView *topPathView;
@property (nonatomic, weak) UINavigationController *tableNav;

@end

@implementation FileBrowserViewController

#pragma mark - init

- (instancetype)initWithPath:(NSString *)path {
    if (self = [super init]) {
        _path = path?:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    }
    return self;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setInitialData];
    [self createUI];
    [self reloadTopPathView];
}

#pragma mark - base config

- (void)setInitialData {
    if (!_levelPageStack) {
        _levelPageStack = [[NSMutableArray alloc] init];
        if (_lockRootFolder) {
            NSString *lastComponent = [_path lastPathComponent];
            if (![lastComponent isEqualToString:@""]) {
                [_levelPageStack addObject:lastComponent];
            }
        } else {
            NSArray *array = [_path pathComponents];
            for (NSString *component in array) {
                if (![component isEqualToString:@""]) {
                    [_levelPageStack addObject:component];
                }
            }
        }
    }
}

- (void)createUI {
    [self reloadTopPathView];
    [self createContainerView];
}

- (void)reloadTopPathView {
    if (self.topPathView) {
        [self.topPathView removeFromSuperview];
        self.topPathView = nil;
    }
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTopScrollHeight)];
    scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    if (_levelPageStack.count) {
        CGFloat horizontialSpace = 5.f;
        NSMutableArray *buttonArray = [[NSMutableArray alloc] initWithCapacity:_levelPageStack.count];
        for (NSUInteger i = 0; i < _levelPageStack.count; i++) {
            NSString *title = nil;
            NSString *levelPath = _levelPageStack[i];
            if ([levelPath isKindOfClass:[NSString class]]) {
                title = levelPath;
            }
            UIButton *button = [[UIButton alloc] init];
            button.tag = i;
            [button setTitle:title forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:14.f];
            if (i == _levelPageStack.count - 1) {
                [button setTitleColor:MAIN_GREEN_COLOR forState:UIControlStateNormal];
            } else {
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            [button addTarget:self action:@selector(levelButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            [button sizeToFit];
            button.height = kTopScrollHeight;
            if (buttonArray.count != 0) {
                UIButton *previousButton = buttonArray[i - 1];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8.5, 11)];
                imageView.image = [UIImage imageNamed:@"right_arrow"];
                [scrollView addSubview:imageView];
                imageView.x = CGRectGetMaxX(previousButton.frame) + horizontialSpace;
                imageView.centerY = previousButton.centerY;
                button.x = CGRectGetMaxX(imageView.frame) + horizontialSpace;
                button.centerY = imageView.centerY;
            }
            [buttonArray addObject:button];
            [scrollView addSubview:button];
        }
        if (buttonArray.count) {
            UIButton *lastButton = buttonArray[buttonArray.count - 1];
            [self.view addSubview:scrollView];
            scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastButton.frame) + horizontialSpace, kTopScrollHeight);
            if (scrollView.bounds.size.width < scrollView.contentSize.width) {
                scrollView.contentOffset = CGPointMake(scrollView.contentSize.width - scrollView.bounds.size.width, 0);
            }
            self.topPathView = scrollView;
        }
    }
}

- (void)levelButtonDidClicked:(UIButton *)sender {
    NSInteger needPopCount = self.levelPageStack.count - 1 - sender.tag;
    if (needPopCount <= 0) {
        return;
    }
    NSInteger vcCount = self.tableNav.viewControllers.count;
    if (vcCount > needPopCount) {
        UIViewController *vc = self.tableNav.viewControllers[vcCount - 1 - needPopCount];
        [self.tableNav popToViewController:vc animated:YES];
    } else {
        NSMutableArray *vcArrays = self.tableNav.viewControllers.mutableCopy;
        NSMutableArray *tempLevelStack = _levelPageStack.mutableCopy;
        while (vcArrays.count) {
            [tempLevelStack removeLastObject];
            [vcArrays removeLastObject];
        }
        NSString *path = _path;
        while (tempLevelStack.count) {
            FileBrowserTableController *tableVC = [[FileBrowserTableController alloc] init];
            path = [path stringByDeletingLastPathComponent];
            tableVC.path = path;
            tableVC.fileBrowserDelegate = self;
            [vcArrays insertObject:tableVC atIndex:0];
            [tempLevelStack removeLastObject];
        }
        [vcArrays addObjectsFromArray:self.tableNav.viewControllers];
        self.tableNav.viewControllers = vcArrays.copy;
        
        UIViewController *vc = self.tableNav.viewControllers[vcArrays.count - 1 - needPopCount];
        [self.tableNav popToViewController:vc animated:YES];
    }
    while (needPopCount--) {
        [_levelPageStack removeLastObject];
    }
    [self reloadTopPathView];
}

- (void)createContainerView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(kTopScrollHeight);
    }];
    FileBrowserTableController *tableVC = [[FileBrowserTableController alloc] init];
    tableVC.path = self.path;
    tableVC.fileBrowserDelegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tableVC];
    nav.navigationBar.hidden = YES;
    [self addChildViewController:nav];
    self.tableNav = nav;
    if (nav && nav.viewControllers.count) {
        [view addSubview:nav.view];
        [nav.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        [tableVC reloadData];
    }
}

#pragma mark - FileBrowserDelegate

- (void)fileBrowserTableController:(FileBrowserTableController *)tableController didSelectFolderWithPath:(NSString *)path {
    FileBrowserTableController *tableVC = [[FileBrowserTableController alloc] init];
    tableVC.path = path;
    tableVC.fileBrowserDelegate = self;
    [self.tableNav pushViewController:tableVC animated:YES];
    [_levelPageStack addObject:[path lastPathComponent]];
    [self reloadTopPathView];
}

- (void)fileBrowserTableController:(FileBrowserTableController *)tableController didSelectFileWithPath:(NSString *)path fileAttributes:(NSDictionary *)fileAttributes {
    if ([self.fileBrowserViewControllerDelegate respondsToSelector:@selector(fileBrowserViewController:didSelectFileWithPath:fileAttributes:)]) {
        [self.fileBrowserViewControllerDelegate fileBrowserViewController:self didSelectFileWithPath:path fileAttributes:fileAttributes];
    }
}

@end
