//
//  SRDownloadVC.m
//  SRVideoPlayerDemo
//
//  Created by longrise on 2019/1/16.
//  Copyright © 2019 longrise. All rights reserved.
//

#import "SRDownloadVC.h"
#import "YCDownloadSession.h"
#import "SRSettingVC.h"
#import "SRDownLoadListCell.h"
#import "SRFullScreenVideoVC.h"

static NSString * const kDefinePauseAllTitle = @"暂停所有";
static NSString * const kDefineStartAllTitle = @"开始所有";

@interface SRDownloadVC ()
<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *downloadList;

@end

@implementation SRDownloadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"下载管理";
    
    [self getCacheVideoList];
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame = CGRectMake(0, 0, 44, 44);
    [settingBtn setTitle:@"设置" forState:0];
    [settingBtn setTitleColor:[UIColor blackColor] forState:0];
    settingBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [settingBtn addTarget:self action:@selector(settingBtnClicked) forControlEvents:1<<6];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    
    [self.view addSubview:self.table];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCacheVideoList) name:@"UserClearCacheNoti" object:nil];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getCacheVideoList
{
    [self.downloadList removeAllObjects];
    [self.downloadList addObjectsFromArray:[YCDownloadManager downloadList]];
    [self.downloadList addObjectsFromArray:[YCDownloadManager finishList]];
    [self.table reloadData];
//    self.navigationItem.rightBarButtonItem.enabled = self.downloadList.count>0;
}

#pragma mark - Private
-(void)settingBtnClicked
{
    SRSettingVC *vc = [SRSettingVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.downloadList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SRDownLoadListCell *cell = [SRDownLoadListCell cellWithTableView:tableView];
    YCDownloadItem *item = self.downloadList[indexPath.row];
    cell.item = item;
    item.delegate = cell;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SRDownLoadListCell rowHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YCDownloadItem *item = self.downloadList[indexPath.row];
    if (item.downloadStatus == YCDownloadStatusDownloading) {
        [YCDownloadManager pauseDownloadWithItem:item];
    }else if (item.downloadStatus == YCDownloadStatusPaused){
        [YCDownloadManager resumeDownloadWithItem:item];
    }else if (item.downloadStatus == YCDownloadStatusFailed){
        [YCDownloadManager resumeDownloadWithItem:item];
    }else if (item.downloadStatus == YCDownloadStatusWaiting){
        [YCDownloadManager pauseDownloadWithItem:item];
    }else if (item.downloadStatus == YCDownloadStatusFinished){
        SRFullScreenVideoVC *playerVC = [[SRFullScreenVideoVC alloc] init];
        playerVC.assetURL = item.savePath;
        playerVC.allowFastForward = NO;
        [self.navigationController pushViewController:playerVC animated:true];
    }
    [self.table reloadData];
}

#pragma mark - Lazy
-(UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:self.view.bounds];
        _table.delegate = self;
        _table.dataSource = self;
    }
    return _table;
}

-(NSMutableArray *)downloadList
{
    if (!_downloadList) {
        _downloadList = [NSMutableArray array];
    }
    return _downloadList;
}

@end
