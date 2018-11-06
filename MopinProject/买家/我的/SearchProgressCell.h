//
//  SearchProgressCell.h
//  MopinProject
//
//  Created by happyzt on 15/12/18.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProgressModel;

@interface SearchProgressCell : UITableViewCell {
    UILabel *TitleLab;
    UILabel *detetailLabel;
    UILabel *dateLabel;
    UILabel *idLabel;
    UILabel *kuDiInfoLabel;  //快递信息Lab
    NSInteger _tag;
    UIImageView *redImgView;
    UIImageView *grayImgView ;
}

@property(nonatomic,strong)NSString*titleName; //标题
@property(nonatomic,strong)ProgressModel *mod; //数据模型

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tag:(NSInteger)tag;   //1 查看进度  2  物流信息

-(void)_initUIWithMod:(ProgressModel*)mod;
-(void)_initDetailUIWithMod:(ProgressModel*)mod;

@end
