//
//  HXHotViewController.m
//  BeautifulOldAge
//
//  Created by Mac on 2018/6/6.
//  Copyright © 2018年 hncoon. All rights reserved.
//

#import "HXHotViewController.h"

#define RandColor [UIColor colorWithRed:(arc4random_uniform(256))/255.0 green:(arc4random_uniform(256))/255.0 blue:(arc4random_uniform(256))/255.0 alpha:(arc4random_uniform(256))/255.0]
#define MaxLoadNum 13

@interface HXHotViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)NSMutableArray *array;
@property(nonatomic,strong)NSMutableArray *moreData;

@end

static NSInteger tag = 0;

@implementation HXHotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    self.array = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13"]];
    self.moreData = [NSMutableArray arrayWithArray:@[@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36"]];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }

    cell.textLabel.text = self.array[indexPath.row];
    cell.backgroundColor = RandColor;
    return cell;
}

#pragma mark - 事件处理
// 下拉刷新
- (void)loadNewTopic {
    [self.tableView reloadData];
    // 结束头部刷新
    [self.tableView.mj_header endRefreshing];
}

// 上拉加载数据
- (void)loadMoreTopic {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSInteger num = ((self.moreData.count - MaxLoadNum * tag) > MaxLoadNum * tag) ? MaxLoadNum : (self.moreData.count - MaxLoadNum * tag);
        // 判断数据是否加载完
        if (self.moreData.count <= (MaxLoadNum * tag)) {
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            return ;
        }
        // 给数据源加载新的数据
        for (int i = 0;i < num;i++) {
            NSLog(@"%d",i);
            [self.array addObject:[self.moreData objectAtIndex:i + MaxLoadNum * tag]];
        }
        NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:MaxLoadNum];
        for (int ind = 0; ind < num; ind++) {
            NSIndexPath *newPath = [NSIndexPath indexPathForRow:[self.array indexOfObject:[self.moreData objectAtIndex:ind + MaxLoadNum * tag]] inSection:0];
            [insertIndexPaths addObject:newPath];
        }
        tag ++;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        });
    });
    
//    [self.tableView reloadData];
    // 结束尾部刷新
    [self.tableView.mj_footer endRefreshing];
    
    
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:kScreenBounds];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        //下拉刷新
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic)];
        //自动更改透明度
        self.tableView.mj_header.automaticallyChangeAlpha = YES;
        //进入刷新状态
        [self.tableView.mj_header beginRefreshing];
        //上拉刷新
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
