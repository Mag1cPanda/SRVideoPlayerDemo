//
//  SRSourceListVC.m
//  SRVideoPlayerDemo
//
//  Created by longrise on 2019/1/16.
//  Copyright © 2019 longrise. All rights reserved.
//

#import "SRSourceListVC.h"
#import "SRDownloadVC.h"
#import "YCDownloadSession.h"

@interface SRSourceListVC ()
<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation SRSourceListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"资源列表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置为BarButtonItem时，只要设置了title，不给frame也能显示
    rightBtn.frame = CGRectMake(0, 0, 44, 44);
    [rightBtn setTitle:@"下载管理" forState:0];
    [rightBtn setTitleColor:[UIColor blackColor] forState:0];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn addTarget:self action:@selector(jumpToDownloadManage) forControlEvents:1<<6];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.dataArr = @[@"http://zhimei.hntv.tv/bbvideo/2018/8/31/3-4syzwsrf.mp4",
                     @"http://zhimei.hntv.tv/bbvideo/2018/8/31/4-2wjywjjdjbcz.mp4",
                     @"http://zhimei.hntv.tv/bbvideo/2018/9/3/jgdjd.mp4",
                     @"http://zhimei.hntv.tv/bbvideo/2018/8/31/3-1windows7dqdhgb.mp4",
                     @"http://zhimei.hntv.tv/bbvideo/2018/8/31/3-3tbhckcz.mp4"];
    
    self.table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
}

-(void)jumpToDownloadManage
{
    SRDownloadVC *vc = [SRDownloadVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = self.dataArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YCDownloadItem *item = nil;
    NSString *URLStr = self.dataArr[indexPath.row];
    
    //文件保存的名字
    NSString *fileId = [NSString stringWithFormat:@"DownloadTest%zi",indexPath.row];
    
    //先根据fileId查找文件，没有则根据URL查找
    if (fileId) {
        item = [YCDownloadManager itemWithFileId:fileId];
    } else if (URLStr) {
        item = [YCDownloadManager itemsWithDownloadUrl:URLStr].firstObject;
    }
    
    //fileId和URL都没找到，则创建下载item
    if (!item) {
        item = [YCDownloadItem itemWithUrl:URLStr fileId:fileId];
//        item.extraData =
        [YCDownloadManager startDownloadWithItem:item];
    }
    
    SRDownloadVC *vc = [SRDownloadVC new];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
