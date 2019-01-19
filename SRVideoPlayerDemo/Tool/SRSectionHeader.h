//
//  SRSectionHeader.h
//  QQSectionCopy
//
//  Created by Siren on 16/1/30.
//  Copyright © 2016年 Siren. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kHeaderHeight 47

@class SRSectionHeader;

@protocol SRSectionHeaderDelegate <NSObject>

-(void)sr_SectionHeader:(SRSectionHeader *)header didSelectedSection:(NSInteger)section;

@end

@interface SRSectionHeader : UITableViewHeaderFooterView

@property (nonatomic, weak) id<SRSectionHeaderDelegate> delegate;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIView *bottemView;

//标题栏按钮
@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, strong) UIImageView *icon;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel *finishLab;

@property (nonatomic, strong) UIImageView *arrow;



//标题栏分组
@property (nonatomic, assign) NSInteger section;
//是否展开
@property (nonatomic, assign) BOOL isOpen;

@end
