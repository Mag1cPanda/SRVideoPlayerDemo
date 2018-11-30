//
//  ViewController.m
//  SRVideoPlayerDemo
//
//  Created by longrise on 2018/11/30.
//  Copyright © 2018 longrise. All rights reserved.
//

#import "ViewController.h"
#import <JPVideoPlayerKit.h>
#import "JPVideoPlayerWeiBoViewController.h"
#import "JPVideoPlayerDouyinViewController.h"
#import "JPVPNetEasyViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)weibo:(id)sender {
    JPVideoPlayerWeiBoViewController *vc = [JPVideoPlayerWeiBoViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)douyin:(id)sender {
    JPVideoPlayerDouyinViewController *vc = [JPVideoPlayerDouyinViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)wangyi:(id)sender {
    JPVPNetEasyViewController *vc = [JPVPNetEasyViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
