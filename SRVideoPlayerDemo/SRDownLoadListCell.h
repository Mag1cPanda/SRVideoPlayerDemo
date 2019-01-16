//
//  SRDownLoadListCell.h
//  SRVideoPlayerDemo
//
//  Created by longrise on 2019/1/16.
//  Copyright © 2019 longrise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCDownloadSession.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRDownLoadListCell : UITableViewCell
<YCDownloadItemDelegate>

@property (nonatomic, strong) YCDownloadItem *item;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *sizeLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)rowHeight;

@end

NS_ASSUME_NONNULL_END
