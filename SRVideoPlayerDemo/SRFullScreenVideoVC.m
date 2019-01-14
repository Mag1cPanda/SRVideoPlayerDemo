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
    
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// 播放器相关
    self.player = [[ZFPlayerController alloc] initWithPlayerManager:playerManager containerView:[UIApplication sharedApplication].keyWindow];

    //禁用左右滑快进快退手势
//    ZFPlayerDisableGestureTypesDoubleTap
    self.player.disableGestureTypes = ZFPlayerDisableGestureTypesPan;
    self.player.controlView = self.controlView;
    self.player.orientationObserver.supportInterfaceOrientation = ZFInterfaceOrientationMaskLandscape;
    [self.player enterFullScreen:YES animated:NO];
    
//    https://www.apple.com/105/media/us/iphone-x/2017/01df5b43-28e4-4848-bf20-490c34a926a7/films/feature/iphone-x-feature-tpl-cc-us-20170912_1280x720h.mp4
    playerManager.assetURL = [NSURL URLWithString:@"http://zhimei.hntv.tv/bbvideo/2018/8/31/3-4syzwsrf.mp4"];
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

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastProgressView.allowTapped = NO;
        _controlView.fastProgressView.isHideSliderBlock = YES;
    }
    return _controlView;
}



@end
