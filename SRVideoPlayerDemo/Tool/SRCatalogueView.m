//
//  SRCatalogueView.m
//  baobaotong
//
//  Created by longrise on 2018/10/19.
//  Copyright © 2018 zzy. All rights reserved.
//

#import "SRCatalogueView.h"
#import "SRSectionHeader.h"
#import "UIColor+RCColor.h"

//#define kScreenW [UIScreen mainScreen].bounds.size.width
//#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface SRCatalogueView ()
<UITableViewDelegate,
UITableViewDataSource,
SRSectionHeaderDelegate>

@property (nonatomic,assign) CGRect initialFrame;


@end

@implementation SRCatalogueView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.8];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCatalogueView)];
        [self addGestureRecognizer:tap];
        
        _initialFrame = frame;
        
        //竖屏
        CGFloat tableX = 0;
        CGFloat tableW = frame.size.width;
        CGFloat tableH = frame.size.height - 75;
        CGFloat lblX = 15.5;
        
        //横屏
        if (frame.size.width > frame.size.height) {
            CGFloat centerX = frame.size.width/2;
            tableX = centerX;
            tableW = centerX;
            lblX = centerX;
        }

        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.backgroundColor = [UIColor blueColor];//
        _closeBtn.frame = CGRectMake(frame.size.width-37, 30, 25, 25);
        [_closeBtn addTarget:self action:@selector(hideCatalogueView) forControlEvents:1<<6];
        [self addSubview:_closeBtn];
        
        
        
        
        _leftLbl = [[UILabel alloc] initWithFrame:CGRectMake(lblX,31.5,50,22)];
        _leftLbl.backgroundColor = [UIColor redColor];//
        _leftLbl.text = @"目录";
        _leftLbl.font = [UIFont systemFontOfSize:16];
        _leftLbl.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        [self addSubview:_leftLbl];
        
        
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(tableX, 75, tableW, tableH) style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor greenColor];
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        
    }
    return self;
}

-(void)setTblDataArr:(NSArray *)tblDataArr
{
    _tblDataArr = tblDataArr;
    [_tableView reloadData];
}

#pragma mark - Private
-(void)showCatalogueView
{
//    __weak typeof(self) weakSelf = self;
    //    CGFloat x = _initialFrame.size.width;
    //    CGFloat y = _initialFrame.origin.y;
    //    CGFloat w = _initialFrame.size.width;
    //    CGFloat h = _initialFrame.size.height;
    CGRect aRect = _initialFrame;
    aRect.origin.x = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = aRect;
    }];
}

-(void)hideCatalogueView
{
    __weak typeof(self) weakSelf = self;
//    CGFloat x = _initialFrame.size.width;
//    CGFloat y = _initialFrame.origin.y;
//    CGFloat w = _initialFrame.size.width;
//    CGFloat h = _initialFrame.size.height;
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = weakSelf.initialFrame;
    }];
}

#pragma mark - SRSectionHeaderDelegate
-(void)sr_SectionHeader:(SRSectionHeader *)header didSelectedSection:(NSInteger)section
{
    
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewStylePlain;
    cell.textLabel.text = @"UITableViewStylePlain";
    
    return cell;
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return [UIView new];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideCatalogueView];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
