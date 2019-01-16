//
//  SRFullScreenVideoVC.h
//  SRVideoPlayerDemo
//
//  Created by longrise on 2019/1/14.
//  Copyright © 2019 longrise. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRFullScreenVideoVC : UIViewController

//文件URL 支持http://和file://
@property (nonatomic, copy) NSString *assetURL;

//是否允许快进
@property (nonatomic, assign) BOOL allowFastForward;

@end

NS_ASSUME_NONNULL_END
