//
//  BaseTableViewController.m
//  FuKuaiDi
//
//  Created by 黄轩 on 16/5/10.
//  Copyright © 2016年 YISS. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@property (nonatomic,strong) MJRefreshNormalHeader *header;
@property (nonatomic,strong) MJRefreshAutoNormalFooter *footer;
@property (nonatomic,strong) UIButton *backToTopBtn;//返回顶部按钮

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self header];
    [self footer];
    [self.view addSubview:self.tableview];
    [self hideLoadMoreRefreshing];
}

#pragma mark - 网络请求

- (void)requestData {
    [self endRefreshing];
}

#pragma mark - 代理
#pragma mark UITableViewDataSource/UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - 返回顶部

//显示返回顶部按钮
- (void)showBackToTopBtn {
    if (nil == _backToTopBtn) {
        _backToTopBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 36 - 20, self.view.frame.size.height - 20 - 36, 36, 36)];
        [_backToTopBtn setBackgroundImage:[UIImage imageNamed:@"back_to_top"] forState:UIControlStateNormal];
        [_backToTopBtn addTarget:self action:@selector(onBackToTopBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backToTopBtn];
        
    }
    else{
        [self.view bringSubviewToFront:_backToTopBtn];
    }
    
    _backToTopBtn.alpha = 0.0f;
    [UIView animateWithDuration:0.3 animations:^{
        _backToTopBtn.alpha = 1.0;
    }];
}

//隐藏返回顶部按钮
- (void)hideBackToTopBtn {
    [UIView animateWithDuration:0.3 animations:^{
        _backToTopBtn.alpha = 0.0;
    }];
}

//返回顶部事件
- (void)onBackToTopBtnClick {
    [self.tableview setContentOffset:CGPointMake(0, -self.tableview.contentInset.top) animated:YES];
}

#pragma mark - MJRefresh上下拉加载

- (void)refresh {
    self.pageIndex = 1;
    [self requestData];
}

- (void)loadMore {
    self.pageIndex ++;
    [self requestData];
}

- (void)endRefreshing {
    if (_header) {
        [self.header endRefreshing];
    }
    if (_footer) {
        [self.footer endRefreshing];
    }
}

- (void)removedRefreshing {
    _header = nil;
    _footer = nil;
    self.tableview.mj_header = nil;
    self.tableview.mj_footer = nil;
}

- (void)showLoadMoreRefreshing {
    self.footer.hidden = NO;
}

- (void)hideLoadMoreRefreshing {
    self.footer.hidden = YES;
}

- (MJRefreshNormalHeader *)header {
    if (!_header) {
        __weak __typeof(self)weakSelf = self;
        _header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong __typeof(self)self = weakSelf;
            [self refresh];
        }];
        self.tableview.mj_header = _header;
    }
    return [self setRefreshNormalHeaderParameter:_header];
}

- (MJRefreshAutoNormalFooter *)footer {
    if (!_footer) {
        __weak __typeof(self)weakSelf = self;
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            __strong __typeof(self)self = weakSelf;
            [self loadMore];
        }];
        self.tableview.mj_footer = _footer;
    }
    return [self setRefreshAutoNormalFooterParameter:_footer];
}

#pragma mark - 懒加载

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.backgroundColor = [UIColor clearColor];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableview;
}

- (NSMutableArray *)dataAry {
    if (!_dataAry) {
        _dataAry = [NSMutableArray new];
    }
    return _dataAry;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
