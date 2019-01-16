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

@interface SRFullScreenVideoVC ()

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) ZFAVPlayerManager *playerManager;

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
    
    self.player.controlView = self.controlView;
    self.player.orientationObserver.supportInterfaceOrientation = ZFInterfaceOrientationMaskLandscape;
    [self.player enterFullScreen:YES animated:NO];
    
    NSString *coverURLStr = @"http://www.yxybb.com/LEAP/Web/FlashFiles/Model/logo.png";
    [self.controlView showTitle:@"11111" coverURLString:coverURLStr fullScreenMode:ZFFullScreenModeLandscape];
    
    //是否允许播放器快进
    if (_allowFastForward) {
        self.controlView.portraitControlView.slider.allowTapped = YES;
        self.controlView.landScapeControlView.slider.allowTapped = YES;
        
        self.player.disableGestureTypes = ZFPlayerDisableGestureTypesNone;
    } else {
        
        self.controlView.portraitControlView.slider.allowTapped = NO;
        self.controlView.landScapeControlView.slider.allowTapped = NO;
        
        self.player.disableGestureTypes = ZFPlayerDisableGestureTypesPan;
    }
    
    if (!_assetURL) {
        NSString *URLStr = @"http://zhimei.hntv.tv/bbvideo/2018/8/31/3-1windows7dqdhgb.mp4";
        NSURL *fileURL = [NSURL URLWithString:URLStr];
        self.playerManager.assetURL = fileURL;
    }

    
    //本地视频
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"designedByAppleInCalifornia" ofType:@"mp4"];
//    NSURL *fileURL = [NSURL fileURLWithPath:path];
//    self.playerManager.assetURL = fileURL;
    
//    NSString *downloadedPath = @"";
//    NSURL *fileURL = [NSURL fileURLWithPath:downloadedPath];
//    self.playerManager.assetURL = fileURL;
    
    //从网上下载好的视频
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLStr]];
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//
//    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithRequest:request];
//    [downloadTask resume];
//    self.downloadTask = downloadTask;
    
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

#pragma mark - setter
- (void)setAllowFastForward:(BOOL)allowFastForward
{
    _allowFastForward = allowFastForward;
    
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

-(void)setAssetURL:(NSString *)assetURL
{
    _assetURL = assetURL;
    self.player.assetURL = [NSURL URLWithString:assetURL];
}

#pragma mark - Lazy
- (ZFPlayerController *)player
{
    if (!_player) {
        _player = [[ZFPlayerController alloc] initWithPlayerManager:self.playerManager containerView:[UIApplication sharedApplication].keyWindow];
    }
    return _player;
}

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
