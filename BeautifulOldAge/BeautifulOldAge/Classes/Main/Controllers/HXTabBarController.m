//
//  HXTabBarController.m
//  BeautifulOldAge
//
//  Created by Mac on 2018/6/6.
//  Copyright © 2018年 hncoon. All rights reserved.
//

#import "HXTabBarController.h"

@interface HXTabBarController ()

@end

@implementation HXTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建tabBar上按钮信息数组
    NSArray *array = @[@{@"ViewController" : @"HXHotViewController", @"normalImage" : @"首页",@"highlightImage" : @"首页(1)", @"title" : @"热门"},
                         @{@"ViewController" : @"HXServiceViewController", @"normalImage" : @"导览",@"highlightImage" : @"导览(1)", @"title" : @"服务"},
                         @{@"ViewController" : @"HXMallViewController", @"normalImage" : @"周边",@"highlightImage" : @"周边(1)", @"title" : @"商城"},
                         @{@"ViewController" : @"HXPersonalViewController", @"normalImage" : @"我",@"highlightImage" : @"我(1)", @"title" : @"我的"}];
    // 遍历数组,初始化按钮
    for (NSDictionary *dict in array) {
        [self addChildViewControllerWithDict:dict];
        self.tabBar.tintColor = [UIColor colorWithHexString:@"#93BEFF"];
    }
    
}

#pragma mark - 初始化tabBar
- (void)addChildViewControllerWithDict:(NSDictionary *)dict {
    Class class = NSClassFromString(dict[@"ViewController"]);
    UIViewController *viewController = [[class alloc]init];
    viewController.tabBarItem.image = [UIImage imageNamed:dict[@"normalImage"]];
    viewController.tabBarItem.selectedImage = [UIImage imageNamed:dict[@"highlightImage"]];
    viewController.tabBarItem.title = dict[@"title"];
    viewController.title = dict[@"title"];
    // 创建导航控制器
    HXNavigationController *navigationController = [[HXNavigationController alloc]initWithRootViewController:viewController];
    [self addChildViewController:navigationController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
