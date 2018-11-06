//
//  SearchProgressCell.m
//  MopinProject
//
//  Created by happyzt on 15/12/18.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "SearchProgressCell.h"
#import "XHDHelper.h"
#import "ProgressModel.h"

@implementation SearchProgressCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tag:(NSInteger)tag{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _tag = tag;
    }
    
    return self;
}

-(void)_initUIWithMod:(ProgressModel*)mod
{
    
    //进度
    TitleLab = [XHDHelper createLabelWithFrame:mRect(60, 0, mScreenWidth-110, 20) andText:mod.Type.length?[self getStatus:mod.Type]:@"0" andFont:[UIFont systemFontOfSize:16] AndBackGround:[UIColor clearColor] AndTextColor:TitleFontColor];
    TitleLab.textAlignment = NSTextAlignmentLeft;
    TitleLab.font = UIFONT_Tilte(15);
    [self addSubview:TitleLab];
    
    
    //进度详情
    detetailLabel = [XHDHelper createLabelWithFrame:mRect(60, TitleLab.bottom, mScreenWidth-110, 20) andText:mod.Content andFont:[UIFont systemFontOfSize:14] AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    detetailLabel.height = [XHDHelper getSizeWithText:detetailLabel.text font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(detetailLabel.width, detetailLabel.height)].height+10;
    detetailLabel.textAlignment = NSTextAlignmentLeft;
    detetailLabel.numberOfLines = 0;
    [self addSubview:detetailLabel];
    
    
    /*如果是type为6就添加物流信息*/
    BOOL haveKuDiInfo = [mod.Type isEqualToString:@"6"];
    if(haveKuDiInfo)
    {
        NSString *infoStr = [NSString stringWithFormat:@"物流单号:%@【%@】",mod.SendToMPCode,mod.CoName];
        kuDiInfoLabel = [XHDHelper createLabelWithFrame:mRect(60, detetailLabel.bottom, mScreenWidth-110, 40) andText:infoStr andFont:[UIFont systemFontOfSize:13] AndBackGround:[UIColor clearColor] AndTextColor:TipsFontColor];
        kuDiInfoLabel.numberOfLines = 0;
        [self addSubview:kuDiInfoLabel];
        /*右键*/
       UIButton*rightArrow =  [XHDHelper getRightArrowButtonWith:mRect(kuDiInfoLabel.right+10,kuDiInfoLabel.origin.y+2.5, 20, 20)];
        [self addSubview:rightArrow];
    }
    
    /*日期*/
    dateLabel = [XHDHelper createLabelWithFrame:mRect(60,haveKuDiInfo? detetailLabel.bottom+45:detetailLabel.bottom, mScreenWidth-100, 20) andText:mod.Createtime.length?[NSString stringWithFormat:@"%@",mod.Createtime]:@"2016.01.01 00:00" andFont:[UIFont systemFontOfSize:13] AndBackGround:[UIColor clearColor] AndTextColor:[UIColor lightGrayColor]];
    dateLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:dateLabel];
    
    
    //图片
    if (_tag == 2) {
        UIImageView *whiteImgView = [XHDHelper createImageViewWithFrame:mRect(34, TitleLab.top+2.5, 13, 13) AndImageName:@"point@2x.png" AndCornerRadius:0 andGestureRecognizer:0 AndTarget:self AndAction:@selector(followAction:)];
        [self addSubview:whiteImgView];
        [XHDHelper addDivLineWithFrame:mRect(whiteImgView.left+5.5, whiteImgView.bottom, 2, self.height*2+18)SuperView:self];
        
    }else {
        UIImageView *whiteImgView = [XHDHelper createImageViewWithFrame:mRect(32.5, TitleLab.top+2.5, 13, 13) AndImageName:@"point@2x.png" AndCornerRadius:0 andGestureRecognizer:0 AndTarget:self AndAction:@selector(followAction:)];
        [self addSubview:whiteImgView];
        
        redImgView = [XHDHelper createImageViewWithFrame:mRect(35.5, TitleLab.top+5, 8, 8) AndImageName:@"red_point_reminder@2x.png" AndCornerRadius:0 andGestureRecognizer:0 AndTarget:self AndAction:@selector(followAction:)];
        [self insertSubview:redImgView aboveSubview:whiteImgView];
        [XHDHelper addDivLineWithFrame:mRect(redImgView.left+3, whiteImgView.bottom, 2, self.height*2+18)SuperView:self];
    }
    
}
-(void)_initDetailUIWithMod:(ProgressModel*)mod
{
    //进度
    TitleLab = [XHDHelper createLabelWithFrame:mRect(60, 0, mScreenWidth-110, 20) andText:mod.Type.length?mod.Type:@"未知" andFont:[UIFont systemFontOfSize:16] AndBackGround:[UIColor clearColor] AndTextColor:TitleFontColor];
    TitleLab.textAlignment = NSTextAlignmentLeft;
    TitleLab.font = UIFONT_Tilte(15);
    [self addSubview:TitleLab];
    
    //进度详情
    detetailLabel = [XHDHelper createLabelWithFrame:mRect(60, TitleLab.bottom, mScreenWidth-110, 60) andText:mod.Content andFont:[UIFont systemFontOfSize:14] AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    detetailLabel.height = [XHDHelper getSizeWithText:detetailLabel.text font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(detetailLabel.width, detetailLabel.height)].height+8;
    detetailLabel.textAlignment = NSTextAlignmentLeft;
    detetailLabel.numberOfLines = 0;
    [self addSubview:detetailLabel];
    
    
       /*日期*/
    dateLabel = [XHDHelper createLabelWithFrame:mRect(60,detetailLabel.bottom, mScreenWidth-100, 20) andText:mod.Createtime.length?[NSString stringWithFormat:@"%@",mod.Createtime]:@"2016.01.01 00:00" andFont:[UIFont systemFontOfSize:13] AndBackGround:[UIColor clearColor] AndTextColor:[UIColor lightGrayColor]];
    dateLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:dateLabel];
    
    
    //图片
    if (_tag == 2) {
        UIImageView *whiteImgView = [XHDHelper createImageViewWithFrame:mRect(34, TitleLab.top+2.5, 13, 13) AndImageName:@"point@2x.png" AndCornerRadius:0 andGestureRecognizer:0 AndTarget:self AndAction:@selector(followAction:)];
        [self addSubview:whiteImgView];
        [XHDHelper addDivLineWithFrame:mRect(whiteImgView.left+5.5, whiteImgView.bottom, 2, self.height*2+18)SuperView:self];
        
    }else {
        UIImageView *whiteImgView = [XHDHelper createImageViewWithFrame:mRect(32.5, TitleLab.top+2.5, 13, 13) AndImageName:@"point@2x.png" AndCornerRadius:0 andGestureRecognizer:0 AndTarget:self AndAction:@selector(followAction:)];
        [self addSubview:whiteImgView];
        
        redImgView = [XHDHelper createImageViewWithFrame:mRect(35.5, TitleLab.top+5, 8, 8) AndImageName:@"red_point_reminder@2x.png" AndCornerRadius:0 andGestureRecognizer:0 AndTarget:self AndAction:@selector(followAction:)];
        [self insertSubview:redImgView aboveSubview:whiteImgView];
        [XHDHelper addDivLineWithFrame:mRect(redImgView.left+3, whiteImgView.bottom, 2, self.height*2+18)SuperView:self];
    }
    
}




- (void)followAction:(UIButton *)button
{
    
    
}

/*根据状态码得到转态*/
-(NSString*)getStatus:(NSString*)str
{
    NSString *statusStr;
    NSInteger code = str.intValue;
    switch (code) {
        case 3:
            statusStr = @"作品创作中";
            break;
        case 4:
            statusStr = @"作品装裱中";
            break;
        case 5:
            statusStr = @"作品已装裱";
            break;
        case 6:
            statusStr = @"作品已发货";
            break;
            
        default:
            break;
    }
    return statusStr;
}


@end
