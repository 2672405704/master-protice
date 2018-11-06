//
//  ExampleWorkCell.h
//  MopinProject
//
//  Created by xhd945 on 15/12/10.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExampleWorkModel; //样品model

@protocol ExampleWorkCellDelegate <NSObject>

- (void)cancelCollectionWithModel:(ExampleWorkModel *)model; //收藏列表 取消收藏回调

@end

@interface ExampleWorkCell : UITableViewCell

@property(nonatomic,strong)ExampleWorkModel*mod;
@property (nonatomic,weak) id<ExampleWorkCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIImageView *publicIcon;//公益图标
@property (weak, nonatomic) IBOutlet UIView *bgView;//背景
@property (weak, nonatomic) IBOutlet UIImageView *workPicture; //作品图片
@property (weak, nonatomic) IBOutlet UIView *priceBgView;//价格背景图片
@property (weak, nonatomic) IBOutlet UILabel *markLab;//￥
@property (weak, nonatomic) IBOutlet UILabel *priceLab;//价格Lab
@property (weak, nonatomic) IBOutlet UILabel *TitleLab;//作品名字
@property (weak, nonatomic) IBOutlet UILabel *attributeLab;//属性Lab
@property (weak, nonatomic) IBOutlet UILabel *enableJuan;//可用劵
@property (weak, nonatomic) IBOutlet UIImageView *personHeaderIcon;//书法家头像
@property (weak, nonatomic) IBOutlet UIView *bottomBtnBgView; //底部收藏按钮

@property(nonatomic,strong)UIViewController *target; //目标控制器

- (void)reloadCellExampleList; //样品列表
- (void)reloadCellSearchSampleList; //搜索样品
- (void)reloadCellCollectionSampleList;//收藏样品

@end
