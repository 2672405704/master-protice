//
//  AllSampleCommentCell.m
//  MopinProject
//
//  Created by rt008 on 16/1/9.
//  Copyright © 2016年 rt008. All rights reserved.
//

#import "AllSampleCommentCell.h"
#import "UIImageView+WebCache.h"
#import "CommentListMod.h"
#import "UIButton+WebCache.h"
#import "ImgShowViewController.h"

@interface AllSampleCommentCell()

@property (weak, nonatomic) IBOutlet UIView *imageBgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;

@property (weak, nonatomic) IBOutlet UIView *replyBgView;
@property (weak, nonatomic) IBOutlet UILabel *replyDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyContentLabel;

@end

@implementation AllSampleCommentCell
{
    CommentListMod *_commentListModel;
}
- (void)awakeFromNib {
    // Initialization code
    _headImageView.layer.cornerRadius=GETVIEWHEIGHT(_headImageView)/2;
    _headImageView.layer.masksToBounds=YES;
}
- (void)reloadCellWithModel:(CommentListMod *)model
{
    _commentListModel=model;
    
    _titleLabel.text=[NSString stringWithFormat:@"%@ 的评价",model.ArtName];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.PhotoPath] placeholderImage:mImageByName(PlaceHeaderSquareImage)];
    _nameLabel.text=model.Nickname;
//    NSArray *dateArr=[model.EDate componentsSeparatedByString:@"-"];
//    if(dateArr.count>2)
//    {
//        _timeLabel.text=[NSString stringWithFormat:@"%d年%d月%d日",[dateArr[0] intValue],[dateArr[1] intValue],[dateArr[2] intValue]];
//    }
    _timeLabel.text=model.EDate;
    _contentLabel.text=model.Content;
    
    CGFloat height;
    if(IOS7_AND_LATER){
        height=[_contentLabel.text boundingRectWithSize:CGSizeMake(kkDeviceWidth-60,MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_contentLabel.font} context:nil].size.height;
    }else{
        height=[_contentLabel.text sizeWithFont:_contentLabel.font constrainedToSize:CGSizeMake(kkDeviceWidth-60,MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
    }
    CGRect frame=_contentLabel.frame;
    frame.size.height=height;
    _contentLabel.frame=frame;
    
    frame=_lineImageView.frame;
    frame.size.height=0.5;
    _lineImageView.frame=frame;
    
    if(model.ImageData.count!=0){
        for(int i=0;i<model.ImageData.count;i++){
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake((60+10)*i, 0, 60, 60);
            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:model.ImageData[i][@"EPicPath"]] forState:UIControlStateNormal placeholderImage:mImageByName(PlaceHeaderSquareImage)];
            [button addTarget:self action:@selector(showBigPhoto:) forControlEvents:UIControlEventTouchUpInside];
            button.tag=100+i;
            [_imageBgView addSubview:button];
            
            button.imageView.contentMode=UIViewContentModeScaleAspectFill;
            button.imageView.clipsToBounds=YES;
        }
        frame=_imageBgView.frame;
        frame.size.height=60;
        frame.origin.y=CGRectGetMaxY(_contentLabel.frame)+20;
        _imageBgView.frame=frame;
    }else{
        frame=_imageBgView.frame;
        frame.origin.y=CGRectGetMaxY(_contentLabel.frame);
        _imageBgView.frame=frame;
    }
    //如果有回复
    if(model.ReContent.length!=0){
        _replyContentLabel.text=model.ReContent;
        _replyDateLabel.text=model.ReTime;
        if(IOS7_AND_LATER){
            height=[_replyContentLabel.text boundingRectWithSize:CGSizeMake(kkDeviceWidth-60,MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_replyContentLabel.font} context:nil].size.height;
        }else{
            height=[_replyContentLabel.text sizeWithFont:_replyContentLabel.font constrainedToSize:CGSizeMake(kkDeviceWidth-60,MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
        }
        frame=_replyContentLabel.frame;
        frame.size.height=height;
        _replyContentLabel.frame=frame;
        
        frame=_replyBgView.frame;
        frame.origin.y=CGRectGetMaxY(_imageBgView.frame)+25;
        frame.size.height=CGRectGetMaxY(_replyContentLabel.frame)+15;
        _replyBgView.frame=frame;
        _replyBgView.hidden=NO;
        
    }else{
        
        frame=_replyBgView.frame;
        frame.size.height=0;
        frame.origin.y=CGRectGetMaxY(_imageBgView.frame);
        _replyBgView.frame=frame;
        _replyBgView.hidden=YES;
    }
    
    frame=_bgView.frame;
    frame.size.height=CGRectGetMaxY(_replyBgView.frame)+15;
    _bgView.frame=frame;
    
}
- (void)showBigPhoto:(UIButton *)button
{
    NSMutableArray *imageArr=[[NSMutableArray alloc]init];
    for(NSDictionary *imageDic in _commentListModel.ImageData){
        [imageArr addObject:[NSURL URLWithString:imageDic[@"EPicPath"]]];
    }
    
    ImgShowViewController *showVC = [[ImgShowViewController alloc]initWithSourceData:imageArr withIndex:button.tag-100];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:showVC];
    [_delegate.navigationController presentViewController:navi animated:YES completion:nil];
}
+ (CGFloat)getHeightWithModel:(CommentListMod *)model
{
    CGFloat height;
    if(IOS7_AND_LATER){
        height=[model.Content boundingRectWithSize:CGSizeMake(kkDeviceWidth-60,MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    }else{
        height=[model.Content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(kkDeviceWidth-60,MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
    }
    height=208+height;
    
    if(model.ImageData.count!=0){
        height+=80;
    }
    CGFloat replyHeight;
    if(model.ReContent.length!=0){
        if(IOS7_AND_LATER){
            replyHeight=[model.ReContent boundingRectWithSize:CGSizeMake(kkDeviceWidth-60,MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
        }else{
            replyHeight=[model.ReContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(kkDeviceWidth-60,MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
        }
        height+=replyHeight+37+15+25;
    }
    height+=15+15;
    
    return height;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
