//
//  ViewController.m
//  SRVideoPlayerDemo
//
//  Created by longrise on 2018/11/30.
//  Copyright © 2018 longrise. All rights reserved.
//

#import "ViewController.h"
#import <JPVideoPlayerKit.h>
#import "JPVideoPlayerWeiBoViewController.h"
#import "JPVideoPlayerDouyinViewController.h"
#import "JPVPNetEasyViewController.h"
#import "SRFullScreenVideoVC.h"
#import "SRSourceListVC.h"

@interface ViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) NSArray *vcArr;
@property (nonatomic, strong) NSArray *titleArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置为BarButtonItem时，只要设置了title，不给frame也能显示
    rightBtn.frame = CGRectMake(0, 0, 44, 44);
    [rightBtn setTitle:@"资源列表" forState:0];
    [rightBtn setTitleColor:[UIColor blackColor] forState:0];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn addTarget:self action:@selector(jumpToSourcelist) forControlEvents:1<<6];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    self.vcArr = @[@"JPVideoPlayerWeiBoViewController",
                   @"JPVideoPlayerDouyinViewController",
                   @"JPVPNetEasyViewController",
                   @"SRFullScreenVideoVC"];
    
    self.titleArr = @[@"微博",@"抖音",@"网易",@"全屏"];
}

- (void)jumpToSourcelist
{
    SRSourceListVC *vc = [SRSourceListVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.titleArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *classStr = self.vcArr[indexPath.row];
    
    UIViewController *vc = [NSClassFromString(classStr) new];
    
    BOOL animated = ![classStr isEqualToString:@"SRFullScreenVideoVC"];
    
    [self.navigationController pushViewController:vc animated:animated];
}


@end
