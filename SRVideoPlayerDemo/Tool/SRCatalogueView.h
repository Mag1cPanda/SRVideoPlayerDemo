//
//  SRCatalogueView.h
//  baobaotong
//
//  Created by longrise on 2018/10/19.
//  Copyright © 2018 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SRCatalogueViewDelegate <NSObject>

@optional
-(void)sr_CatalogueViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface SRCatalogueView : UIView
@property (nonatomic, weak) id<SRCatalogueViewDelegate> delegate;

@property (nonatomic, strong) UILabel *leftLbl;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *tblDataArr;

//显示
-(void)showCatalogueView;

/**
 隐藏
 */
-(void)hideCatalogueView;

@end
