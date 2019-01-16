//
//  SRSettingVC.m
//  SRVideoPlayerDemo
//
//  Created by longrise on 2019/1/16.
//  Copyright © 2019 longrise. All rights reserved.
//

#import "SRSettingVC.h"
#import "YCDownloadSession.h"

@interface SRSettingVC ()
<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) UISwitch *cellularDownloadSwitch;

@property (nonatomic, strong) UISwitch *cellularPlaySwitch;
@end

@implementation SRSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attributes = [fileManager attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    
    NSLog(@"容量%.2fG",[attributes[NSFileSystemSize] doubleValue] / (powf(1024, 3)));
    NSLog(@"可用%.2fG",[attributes[NSFileSystemFreeSize] doubleValue] / powf(1024, 3));
}

#pragma mark - Private
- (void)cellularSwitch:(UISwitch *)sender {
    if (sender == self.cellularPlaySwitch) {
//        [YCDownloadManager allowsCellularAccess:sender.isOn];
    }
    
    if (sender == self.cellularDownloadSwitch) {
        [YCDownloadManager allowsCellularAccess:sender.isOn];
    }
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"是否允许4G播放";
        cell.accessoryView = self.cellularPlaySwitch;
    }
    
    if (indexPath.row == 1) {
        cell.textLabel.text = @"是否允许4G下载";
        cell.accessoryView = self.cellularDownloadSwitch;
    }
    
    if (indexPath.row == 2) {
        cell.textLabel.text = @"磁盘剩余空间";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [YCDownloadUtils fileSizeStringFromBytes:[YCDownloadUtils fileSystemFreeSize]]];
    }
    
    if (indexPath.row == 3) {
        cell.textLabel.text = @"清空视频缓存";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [YCDownloadUtils fileSizeStringFromBytes:[YCDownloadManager videoCacheSize]]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"是否清空所有下载文件缓存？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //注意清空缓存的逻辑,YCDownloadSession单独下载的文件单独清理，这里的大小由YCDownloadManager控制
            [YCDownloadManager removeAllCache];
            [self.table reloadData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserClearCacheNoti" object:nil];
            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVc addAction:confirm];
        [alertVc addAction:cancel];
        [self presentViewController:alertVc animated:true completion:nil];
    }
}
    

#pragma mark - Lazy
-(UISwitch *)cellularDownloadSwitch
{
    if (!_cellularDownloadSwitch) {
        _cellularDownloadSwitch = [UISwitch new];
        [_cellularDownloadSwitch setOn:[YCDownloadManager isAllowsCellularAccess]];
        [_cellularDownloadSwitch addTarget:self action:@selector(cellularSwitch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cellularDownloadSwitch;
}

-(UISwitch *)cellularPlaySwitch
{
    if (!_cellularPlaySwitch) {
        _cellularPlaySwitch = [UISwitch new];
        [_cellularPlaySwitch setOn:[YCDownloadManager isAllowsCellularAccess]];
        [_cellularPlaySwitch addTarget:self action:@selector(cellularSwitch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cellularPlaySwitch;
}
@end
