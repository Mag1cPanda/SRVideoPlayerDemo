//
//  SRDownLoadListCell.m
//  SRVideoPlayerDemo
//
//  Created by longrise on 2019/1/16.
//  Copyright © 2019 longrise. All rights reserved.
//

#import "SRDownLoadListCell.h"

@implementation SRDownLoadListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"SRDownLoadListCell";
    SRDownLoadListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SRDownLoadListCell" owner:nil options:nil].firstObject;
    }
    return cell;
}

+ (CGFloat)rowHeight
{
    return 100;
}

-(void)setItem:(YCDownloadItem *)item
{
    _item = item;
    
    self.titleLbl.text = item.downloadURL;
    
    [self changeSizeLblDownloadedSize:item.downloadedSize totalSize:item.fileSize];
    [self setDownloadStatus:item.downloadStatus];
}

- (void)setDownloadStatus:(YCDownloadStatus)status
{
    
    switch (status) {
        case YCDownloadStatusWaiting:
            self.statusLbl.text = @"正在等待";
            break;
        case YCDownloadStatusDownloading:
            self.statusLbl.text = @"正在下载";
            break;
        case YCDownloadStatusPaused:
            self.statusLbl.text = @"暂停下载";
            break;
        case YCDownloadStatusFinished:
            self.statusLbl.text = @"下载成功";
            self.progressView.progress = 1;
            break;
        case YCDownloadStatusFailed:
            self.statusLbl.text = @"下载失败";
            break;
            
        default:
            break;
    }
}

- (void)changeSizeLblDownloadedSize:(int64_t)downloadedSize totalSize:(int64_t)totalSize
{
    self.sizeLbl.text = [NSString stringWithFormat:@"%@ / %@",[YCDownloadUtils fileSizeStringFromBytes:downloadedSize], [YCDownloadUtils fileSizeStringFromBytes:totalSize]];
    
    float progress = 0;
    if (totalSize != 0) {
        progress = (float)downloadedSize / totalSize;
    }
    self.progressView.progress = progress;
}

#pragma mark - YCDownloadItemDelegate
- (void)downloadItemStatusChanged:(YCDownloadItem *)item
{
    [self setDownloadStatus:item.downloadStatus];
}

- (void)downloadItem:(YCDownloadItem *)item downloadedSize:(int64_t)downloadedSize totalSize:(int64_t)totalSize
{
    [self changeSizeLblDownloadedSize:downloadedSize totalSize:totalSize];
}

- (void)downloadItem:(YCDownloadItem *)item speed:(NSUInteger)speed speedDesc:(NSString *)speedDesc
{
    NSLog(@"%lu ----- %@", (unsigned long)speed, speedDesc);
}

@end
