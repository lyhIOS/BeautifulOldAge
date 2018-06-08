//
//  HXSearchViewController.m
//  BeautifulOldAge
//
//  Created by Mac on 2018/6/7.
//  Copyright © 2018年 hncoon. All rights reserved.
//

#import "HXSearchViewController.h"

#define SearchTableview @"HXSearchTableview"

@interface HXSearchViewController ()<UISearchBarDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UITableView *tableView;
// 数据源数组
@property(nonatomic,strong)NSArray *dataSourceArray;
// 搜索结果数组
@property(nonatomic,strong)NSMutableArray *resultArray;

@end

@implementation HXSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 初始化UIsearchBar
    [self setBarButtonItem];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_searchBar.isFirstResponder) {
        [self.searchBar becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}

#pragma mark - 初始化UIsearchBar
- (void)setBarButtonItem {
    // 隐藏返回按钮
    [self.navigationItem setHidesBackButton:YES];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 7, kScreenWidth, 30)];
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    self.searchBar = searchBar;
    searchBar.delegate = self;
    // 默认提示文字
    searchBar.placeholder = @"搜索内容";
    // 显示取消按钮
    searchBar.showsCancelButton = YES;
    // 背景图片
    searchBar.backgroundImage = [UIImage imageNamed:@""];
    // 设置光标
    searchBar.tintColor = [UIColor colorWithHexString:@""];
    // 设置输入框
    UITextField *searchTextField = [searchBar valueForKey:@"_searchField"];
    searchTextField.font = [UIFont systemFontOfSize:15];
    searchTextField.backgroundColor = [UIColor colorWithHexString:@""];
    searchTextField.returnKeyType = UIReturnKeySearch;
//    searchTextField.delegate = self;
    // 设置取消按钮
    UIButton *cancelButton = [searchBar valueForKey:@"cancelButton"];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithHexString:@""] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:searchBar];
    self.navigationItem.titleView = view;
}

#pragma mark - UISearchBarDelegate
// 点击搜索框时调用
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}
// cancel按钮点击时调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
// 输入文本实时更新时调用
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // 清空搜索结果数组
    [self.resultArray removeAllObjects];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
    });
}
// 点击搜索按钮时调用
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"========================");
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchTableview forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    return cell;
}

#pragma mark - 事件处理
- (void)clickCancelButton {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:kScreenBounds];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SearchTableview];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
