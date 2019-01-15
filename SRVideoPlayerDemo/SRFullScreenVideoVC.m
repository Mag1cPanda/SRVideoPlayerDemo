//
//  SRFullScreenVideoVC.m
//  SRVideoPlayerDemo
//
//  Created by longrise on 2019/1/14.
//  Copyright © 2019 longrise. All rights reserved.
//

#import "SRFullScreenVideoVC.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import "ZFPlayerControlView.h"
#import "YCDownloadSession.h"

@interface SRFullScreenVideoVC ()
<NSURLSessionDownloadDelegate>
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) ZFAVPlayerManager *playerManager;

//是否允许快进
@property (nonatomic, assign) BOOL allowFastForward;


//下载相关
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSData *resumData;
@end

@implementation SRFullScreenVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    @weakify(self)
    self.controlView.backBtnClickCallback = ^{
        @strongify(self)
        [self.player enterFullScreen:NO animated:NO];
        [self.player stop];
        [self.navigationController popViewControllerAnimated:NO];
    };
    
    self.player = [[ZFPlayerController alloc] initWithPlayerManager:self.playerManager containerView:[UIApplication sharedApplication].keyWindow];
    self.player.controlView = self.controlView;
    self.player.orientationObserver.supportInterfaceOrientation = ZFInterfaceOrientationMaskLandscape;
    [self.player enterFullScreen:YES animated:NO];
    
    //禁止播放器快进
    self.allowFastForward = YES;
    
    NSString *URLStr = @"http://zhimei.hntv.tv/bbvideo/2018/8/31/3-1windows7dqdhgb.mp4";
//    NSURL *fileURL = [NSURL URLWithString:URLStr];
    
    //本地视频
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"designedByAppleInCalifornia" ofType:@"mp4"];
//    NSURL *fileURL = [NSURL fileURLWithPath:path];
//    self.playerManager.assetURL = fileURL;
    
//    NSString *downloadedPath = @"";
//    NSURL *fileURL = [NSURL fileURLWithPath:downloadedPath];
//    self.playerManager.assetURL = fileURL;
    
    //从网上下载好的视频
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLStr]];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];

    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithRequest:request];
    [downloadTask resume];
    self.downloadTask = downloadTask;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.player.viewControllerDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

#pragma mark - NSURLSessionDownloadDelegate
/**
 *  写数据
 *
 *  @param session                   会话对象
 *  @param downloadTask              下载任务
 *  @param bytesWritten              本次写入的数据大小
 *  @param totalBytesWritten         下载的数据总大小
 *  @param totalBytesExpectedToWrite  文件的总大小
 */
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    //1. 获得文件的下载进度
    NSLog(@"%f",1.0 * totalBytesWritten/totalBytesExpectedToWrite);
}

/**
 *  当恢复下载的时候调用该方法
 *
 *  @param fileOffset         从什么地方下载
 *  @param expectedTotalBytes 文件的总大小
 */
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"%s",__func__);
}

/**
 *  当下载完成的时候调用
 *
 *  @param location     文件的临时存储路径
 */
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"%@",location);
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"%@",dirPaths);
    
    //1 拼接文件全路径
    NSString *fullPath = [[dirPaths lastObject] stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    
    //2 剪切文件
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPath] error:nil];
    NSLog(@"%@",fullPath);
    
    NSURL *fileURL = [NSURL fileURLWithPath:fullPath];
    self.playerManager.assetURL = fileURL;
}

/**
 *  请求结束
 */
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"didCompleteWithError");
}

#pragma mark - setter
- (void)setAllowFastForward:(BOOL)allowFastForward
{
    _allowFastForward = allowFastForward;
    
    if (!self.player) {
        NSAssert(NO, @"此属性需要在ZFPlayerControllers实例化之后设置");
    }
    
    if (allowFastForward) {
        self.controlView.portraitControlView.slider.allowTapped = YES;
        self.controlView.landScapeControlView.slider.allowTapped = YES;
        
        self.player.disableGestureTypes = ZFPlayerDisableGestureTypesNone;
    } else {
        
        self.controlView.portraitControlView.slider.allowTapped = NO;
        self.controlView.landScapeControlView.slider.allowTapped = NO;
    
        self.player.disableGestureTypes = ZFPlayerDisableGestureTypesPan;
    }
}

#pragma mark - Lazy
- (ZFPlayerControlView *)controlView
{
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
    }
    return _controlView;
}

- (ZFAVPlayerManager *)playerManager
{
    if (!_playerManager) {
        _playerManager = [ZFAVPlayerManager new];
    }
    return _playerManager;
}



@end
