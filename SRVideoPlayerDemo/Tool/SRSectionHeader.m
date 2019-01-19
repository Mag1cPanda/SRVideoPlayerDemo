//
//  SRSectionHeader.m
//  QQSectionCopy
//
//  Created by Siren on 16/1/30.
//  Copyright © 2016年 Siren. All rights reserved.
//

#import "SRSectionHeader.h"
#define kScreenW [UIScreen mainScreen].bounds.size.width

@implementation SRSectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
  
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.frame = CGRectMake(0, 0, kScreenW, kHeaderHeight);
        
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = self.bounds;
//        _btn.backgroundColor = UIColorFromRGB(0xF5F5F5);
        CGFloat centerY = _btn.frame.size.height/2;
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(12, 17, 12, 12)];
        _icon.image = [UIImage imageNamed:@"icon_study_ic_study_conte"];
        [_btn addSubview:_icon];
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(34, centerY-10, 200, 20)];
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.textColor = [UIColor darkGrayColor];
        [_btn addSubview:_titleLab];
        
        _finishLab = [[UILabel alloc] initWithFrame:CGRectMake(240, centerY-10, kScreenW-276, 20)];
        _finishLab.font = [UIFont systemFontOfSize:14];
        _finishLab.textColor = [UIColor darkGrayColor];
//        _finishLab.text = @"(1/12)";
        _finishLab.textAlignment = NSTextAlignmentRight;
        [_btn addSubview:_finishLab];
        
        _arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW-30, centerY-9, 18, 18)];
        _arrow.image = [UIImage imageNamed:@"Icons_My_ic_my_getmember_black-1"];
        [_btn addSubview:_arrow];
        
        [_btn addTarget:self action:@selector(clickButton) forControlEvents:1<<6];
    
        [self.contentView addSubview:_btn];
        
        CGFloat lineH = 0.5;
        
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, lineH)];
//        _topView.backgroundColor = UIColorFromRGB(0xE5E5E5);
        [self.contentView addSubview:_topView];
        
        _bottemView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeaderHeight-0.5, kScreenW, lineH)];
//        _bottemView.backgroundColor = UIColorFromRGB(0xE5E5E5);
        [self.contentView addSubview:_bottemView];
    }
    return self;
}

- (void)clickButton{
    
    //执行代理方法
    if ([_delegate respondsToSelector:@selector(sr_SectionHeader:didSelectedSection:)]) {
    
        [_delegate sr_SectionHeader:self didSelectedSection:self.section];
        
    }

}

#pragma mark - isOpen的setter方法
- (void)setIsOpen:(BOOL)isOpen{
    _isOpen = isOpen;
    CGFloat angle = isOpen ? M_PI : 0;

    [UIView animateWithDuration:0.5f animations:^{

        [_arrow setTransform:CGAffineTransformMakeRotation(angle)];

    }];
}

@end
