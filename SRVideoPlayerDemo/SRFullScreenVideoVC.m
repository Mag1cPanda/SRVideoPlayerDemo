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
#import "SRCatalogueView.h"
#import <Masonry.h>

@interface SRFullScreenVideoVC ()
<SRCatalogueViewDelegate>

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) ZFAVPlayerManager *playerManager;

@property (nonatomic, strong) SRCatalogueView *catalogueView;

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
    
    [self.controlView.landScapeControlView.catalogBtn addTarget:self action:@selector(catalogBtnClicked) forControlEvents:1<<6];
    [self.controlView.landScapeControlView addSubview:self.catalogueView];
    
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
        
        self.player.disableGestureTypes = (ZFPlayerDisableGestureTypesPan | ZFPlayerDisableGestureTypesDoubleTap) ;
    }
    
    if (!_assetURL) {
        NSString *URLStr = @"http://zhimei.hntv.tv/bbvideo/2018/8/31/3-1windows7dqdhgb.mp4";
        NSURL *fileURL = [NSURL URLWithString:URLStr];
        self.playerManager.assetURL = fileURL;
    }
    
    NSLog(@"%@",self.player.assetURL);

    
    self.player.playerPlayTimeChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSTimeInterval currentTime, NSTimeInterval duration) {
//        NSLog(@"%f/%f",currentTime,duration);
        if (currentTime == duration) {
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
            lbl.center = weak_self.controlView.center;
            lbl.text = @"学习完成";
            lbl.backgroundColor = [UIColor redColor];
            [weak_self.controlView addSubview:lbl];
            
        }
    };
    
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

#pragma mark - 目录按钮点击事件
- (void)catalogBtnClicked
{
    NSLog(@"catalogBtnClicked");
    [self.catalogueView showCatalogueView];
}

#pragma mark - SRCatalogueViewDelegate
-(void)sr_CatalogueViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    
        self.player.disableGestureTypes = (ZFPlayerDisableGestureTypesPan | ZFPlayerDisableGestureTypesDoubleTap);
    }
}

-(void)setAssetURL:(NSString *)assetURL
{
    _assetURL = assetURL;
    
    //网络地址和本地地址
    if ([assetURL hasPrefix:@"http"]) {
        self.player.assetURL = [NSURL URLWithString:assetURL];
    } else {
        self.player.assetURL = [NSURL fileURLWithPath:assetURL];
    }
    
}

#pragma mark - Lazy
- (SRCatalogueView *)catalogueView
{
    if (!_catalogueView) {
        //初始化时隐藏
        CGRect aRect = CGRectMake([UIScreen mainScreen].bounds.size.height, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        _catalogueView = [[SRCatalogueView alloc] initWithFrame:aRect];
        _catalogueView.delegate = self;
    }
    return _catalogueView;
}

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
