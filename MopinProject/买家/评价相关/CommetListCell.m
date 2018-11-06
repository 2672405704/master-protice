//
//  CommetListCell.m
//  MopinProject
//
//  Created by xhd945 on 15/12/14.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "CommetListCell.h"
#import "XHDHelper.h"
#import "CommentListMod.h"
#import "UIKit+AFNetworking.h"


#pragma mark -- 书家回复视图
@interface ReCommentView : UIView
@property(nonatomic,strong)NSString*replyDate; //回复时间
@property(nonatomic,strong)NSString*replyContent;//回复内容

@property(nonatomic,strong)UILabel* reCommentDateLab; //回复时间
@property(nonatomic,strong)UILabel *reCommentContentLab; //回复内容

@end


@implementation ReCommentView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self initSubView];
        [self setClipsToBounds:YES];
        self.layer.cornerRadius = 5;
    }
    return self;
}
-(void)initSubView
{
    //书家回复
    UILabel *penManReplyLab = [[UILabel alloc]initWithFrame:mRect(10, 5, 60, 15)];
    penManReplyLab.text = @"书家回复";
    penManReplyLab.textColor = [UIColor whiteColor];
    penManReplyLab.font = UIFONT(13.5);
    [self addSubview:penManReplyLab];
    //回复日期
    _reCommentDateLab = [[UILabel alloc]initWithFrame:mRect(0, 5,150, 15)];
    _reCommentDateLab.textColor = [UIColor lightGrayColor];
    _reCommentDateLab.text = _replyDate;
    _reCommentDateLab.textAlignment = NSTextAlignmentRight;
    _reCommentDateLab.font = UIFONT(12);
    _reCommentDateLab.right = self.right-30;
    [self addSubview:_reCommentDateLab];
    //回复内容
    _reCommentContentLab = [[UILabel alloc]initWithFrame:mRect(penManReplyLab.origin.x, penManReplyLab.bottom+5, self.width-20, 20)];
    _reCommentContentLab.textColor = [UIColor whiteColor];
    _reCommentContentLab.text = _replyContent.length?_replyContent:@"感谢你的支持，推荐使用无框装裱效果最好。";
    _reCommentContentLab.font = UIFONT(12);
    _reCommentContentLab.numberOfLines = 0;
    [self addSubview:_reCommentContentLab];


}

- (void)layoutSubviews
{
   _reCommentDateLab.text = _replyDate;
    _reCommentContentLab.text = _replyContent.length?_replyContent:@"感谢你的支持，推荐使用无框装裱效果最好。";
    CGFloat height = [XHDHelper heightOfString:_replyContent font:_reCommentContentLab.font maxSize:CGSizeMake(_reCommentContentLab.width, 1000)].height;
    _reCommentContentLab.height = height>20.0f?height:20;
    self.height = height>20.f?height+35:55;
}

@end

#pragma mark  --  图片列表
@interface PicListViw : UIView

@property(nonatomic,strong)NSArray *picArr; //图片列表
-(void)updateUI;
@end

@implementation PicListViw
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self _initUI];
    }
    return self;
}
-(void)setPicArr:(NSArray *)picArr
{
   if(picArr!=_picArr)
   {
       _picArr = picArr;
   }
    [self _initUI];
}

-(void)_initUI
{
    for(UIView *subView in self.subviews)
    {
        [subView removeFromSuperview];
    }
    if(_picArr.count>0)
    {
        for(NSInteger i= 0;i<_picArr.count;i++)
        {
            NSString *picUrl = _picArr[i][@"EPicPath"];
            
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:mRect(i*((kkDeviceWidth-73)/3.0+10),0,(kkDeviceWidth-73)/3.0, (kkDeviceWidth-73)/3.0)];
            imageView.tag = 990+i;
            imageView.userInteractionEnabled = YES;
            [imageView setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:mImageByName(PlaceHeaderSquareImage)];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomImage:)];
            [imageView addGestureRecognizer:tap];
            [self addSubview:imageView];
            
        }
    }
}
-(void)updateUI
{
    if(_picArr.count==0)
    {
        self.height = 0;
    }
    else{
    
        self.height = 50;
        for(NSInteger i = 0;i<self.subviews.count;i++)
        {
            UIImageView *tem = self.subviews[990+i];
            [tem setImageWithURL:[NSURL URLWithString:_picArr[i]] placeholderImage:mImageByName(PlaceHeaderIconImage)];
        }
    }
   
}
/*查看评价的大图片*/
-(void)zoomImage:(UITapGestureRecognizer*)tap
{
    UIImageView *imgV = (UIImageView*)tap.view;
    NSInteger index = imgV.tag - 990;
    NSMutableArray *imgArr = [[NSMutableArray alloc]init];
    for(NSDictionary *dic in _picArr)
    {
       NSString *picUrl = dic[@"EPicPath"];
        NSURL *url = [NSURL URLWithString:picUrl];
        [imgArr addObject:url];
    }
    NSDictionary *dic = @{@"index":@(index),@"imageArr":imgArr};
    [mNotificationCenter postNotificationName:@"checkZoomImage" object:nil userInfo:dic];
}

@end

#pragma  mark -- 评论列表的视图
@implementation CommetListCell
{
    UILabel *TitleLab;
    UIImageView*customHeaderIcon; //用户头像
    UILabel *customNikeNameLab; //用户昵称
    UILabel *publishDateLab; //发布时间
    UILabel *contentLab; //内容Lab
    PicListViw *commentPicView ; //回复的图片视图
    ReCommentView *replyCommentView; //书家回复视图
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //加一条分割线
        _divLine = [[UIView alloc]initWithFrame:mRect(0, self.height -1, kkDeviceWidth, 1)];
        _divLine.backgroundColor = DIVLINECOLOR_1;
        [self addSubview:_divLine];
        
    }
    return self;
}

/*样品详情中的评价*/
-(void)initUIWithCommentModInWorkDetail:(CommentListMod*)mod
{
    for(UIView *subView in self.subviews)
    {
        if(![subView isEqual:_divLine])
        {
           [subView removeFromSuperview];
        }
    }
    
    /*头像*/
    customHeaderIcon = [XHDHelper createImageViewWithFrame:mRect(kkDeviceWidth/2.0-30,25, 60, 60) AndImageName:mod.PhotoPath AndCornerRadius:30 andGestureRecognizer:0 AndTarget:nil AndAction:nil];
    [self addSubview:customHeaderIcon];
    
    /*买家ID*/
    UIColor *clearColor = [UIColor clearColor];
    customNikeNameLab = [XHDHelper createLabelWithFrame:mRect(kkDeviceWidth/2.0-100, customHeaderIcon.bottom+5, 200, 25) andText:mod.Nickname.length?mod.Nickname:@"匿名" andFont:[UIFont systemFontOfSize:15] AndBackGround:clearColor AndTextColor:MainFontColor];
    customNikeNameLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:customNikeNameLab];

    /*内容*/
    contentLab = [XHDHelper createLabelWithFrame:mRect(25, customNikeNameLab.bottom+10, kkDeviceWidth-50, 30) andText:mod.Content.length?mod.Content:@"2015年10月" andFont:[UIFont systemFontOfSize:12] AndBackGround:clearColor AndTextColor:TipsFontColor];
    contentLab.numberOfLines = 0;
    [self addSubview:contentLab];
    
    //图片列表
    if(mod.ImageData.count>0)
    {
        if( ((NSString*)mod.ImageData[0][@"EPicPath"]).length)
        {
        commentPicView = [[PicListViw alloc]initWithFrame:mRect(contentLab.origin.x, contentLab.bottom+10, kkDeviceWidth-50,80)];
        commentPicView.picArr = mod.ImageData;
        
        [self addSubview:commentPicView];
        }
    }
    
    //书家回复
    if(mod.ReContent.length>0)
    {
        replyCommentView = [[ReCommentView alloc]initWithFrame:mRect(contentLab.origin.x, contentLab.bottom+commentPicView.height+25, kkDeviceWidth-50, 55)];
        replyCommentView.replyDate = @"";
        mod.ReTime = @"";
        replyCommentView.replyContent = mod.ReContent;
        replyCommentView.reCommentDateLab.textColor = [UIColor whiteColor];
        replyCommentView.reCommentContentLab.numberOfLines = 0;
        replyCommentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self addSubview:replyCommentView];
    }
    
    [self UpdateUIWithMod:mod];
}

/*样品评价列表*/
-(void)initUIWithSampleCommentListMod:(CommentListMod*)mod
{
    for(UIView *subView in self.subviews)
    {
        if(![subView isEqual:_divLine])
        {
            [subView removeFromSuperview];
        }
    }
    /*头像*/
    customHeaderIcon = [XHDHelper createImageViewWithFrame:mRect(kkDeviceWidth/2.0-30,25, 60, 60) AndImageName:mod.PhotoPath AndCornerRadius:30 andGestureRecognizer:0 AndTarget:nil AndAction:nil];
    [self addSubview:customHeaderIcon];
    
    /*买家ID*/
    UIColor *clearColor = [UIColor clearColor];
    customNikeNameLab = [XHDHelper createLabelWithFrame:mRect(kkDeviceWidth/2.0-100, customHeaderIcon.bottom+5, 200, 25) andText:mod.Nickname.length?mod.Nickname:@"匿名" andFont:[UIFont systemFontOfSize:15] AndBackGround:clearColor AndTextColor:MainFontColor];
    customNikeNameLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:customNikeNameLab];
    
    //发布时间
    publishDateLab =[XHDHelper createLabelWithFrame:mRect(kkDeviceWidth/2.0-100, customNikeNameLab.bottom+5, 200, 10) andText:mod.EDate.length?mod.EDate:@"2015年10月" andFont:[UIFont systemFontOfSize:11] AndBackGround:clearColor AndTextColor:TipsFontColor];
    publishDateLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:publishDateLab];
    
    /*内容*/
    contentLab = [XHDHelper createLabelWithFrame:mRect(25, publishDateLab.bottom+10, kkDeviceWidth-50, 30) andText:mod.Content.length?mod.Content:@"2015年10月" andFont:[UIFont systemFontOfSize:12] AndBackGround:clearColor AndTextColor:TipsFontColor];
    contentLab.numberOfLines = 0;
    [self addSubview:contentLab];
    
    //图片列表
    if(mod.ImageData.count>0)
    {
        if( ((NSString*)mod.ImageData[0][@"EPicPath"]).length)
        {
            commentPicView = [[PicListViw alloc]initWithFrame:mRect(contentLab.origin.x, contentLab.bottom+25, kkDeviceWidth-50,75)];
            commentPicView.picArr = mod.ImageData;
            [self addSubview:commentPicView];
        }else{
            commentPicView.frame = CGRectZero;
        }
    }
    
    //书家回复
    if(mod.ReContent.length>0)
    {
        replyCommentView = [[ReCommentView alloc]initWithFrame:mRect(contentLab.origin.x, contentLab.bottom+commentPicView.height+20, kkDeviceWidth-50, 55)];
        replyCommentView.replyDate = mod.ReTime;
        replyCommentView.replyContent = mod.ReContent;
        [self addSubview:replyCommentView];
    }

    [self UpdateUIWithMod:mod];
}

/*评价管理*/
-(void)initUIWithCommentManagerListMod:(CommentListMod*)mod
{
    for(UIView *subView in self.subviews)
    {
        if(![subView isEqual:_divLine])
        {
            [subView removeFromSuperview];
        }
    }
  /*样品名称*/
    TitleLab = [XHDHelper createLabelWithFrame:mRect(20, 10,kkDeviceWidth-40, 20) andText:mod.ArtName.length?[NSString stringWithFormat:@"%@ 的评价",mod.ArtName]:@"样品标题的评论" andFont:UIFONT_Tilte(16) AndBackGround:[UIColor clearColor] AndTextColor:TitleFontColor];
    TitleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:TitleLab];
    
    /*头像*/
    customHeaderIcon = [XHDHelper createImageViewWithFrame:mRect(kkDeviceWidth/2.0-30, TitleLab.bottom+10, 60, 60) AndImageName:mod.PhotoPath AndCornerRadius:30 andGestureRecognizer:0 AndTarget:nil AndAction:nil];
    [self addSubview:customHeaderIcon];
    
    /*买家ID*/
    UIColor *clearColor = [UIColor clearColor];
    customNikeNameLab = [XHDHelper createLabelWithFrame:mRect(kkDeviceWidth/2.0-100, customHeaderIcon.bottom+5, 200, 25) andText:mod.Nickname.length?mod.Nickname:@"匿名" andFont:[UIFont systemFontOfSize:15] AndBackGround:clearColor AndTextColor:MainFontColor];
    customNikeNameLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:customNikeNameLab];
    //发布时间
    publishDateLab =[XHDHelper createLabelWithFrame:mRect(kkDeviceWidth/2.0-100, customNikeNameLab.bottom+2, 200, 10) andText:mod.EDate.length?mod.EDate:@"2015年10月" andFont:[UIFont systemFontOfSize:10] AndBackGround:clearColor AndTextColor:TipsFontColor];
    publishDateLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:publishDateLab];
    /*内容*/
    contentLab = [XHDHelper createLabelWithFrame:mRect(25, customNikeNameLab.bottom+8, kkDeviceWidth-50, 40) andText:mod.Content.length?mod.Content:@"2015年10月" andFont:[UIFont systemFontOfSize:11] AndBackGround:clearColor AndTextColor:TipsFontColor];
    contentLab.numberOfLines = 0;
    [self addSubview:contentLab];
    
    //图片列表
    if(mod.ImageData.count>0)
    {
        if( ((NSString*)mod.ImageData[0][@"EPicPath"]).length)
        {
        commentPicView = [[PicListViw alloc]initWithFrame:mRect(contentLab.origin.x, contentLab.bottom+5, kkDeviceWidth-50,75)];
        commentPicView.picArr = mod.ImageData;
        [self addSubview:commentPicView];
        }
    }
    
    //书家回复
    if(mod.ReContent.length>0)
    {
        replyCommentView = [[ReCommentView alloc]initWithFrame:mRect(contentLab.origin.x, contentLab.bottom+commentPicView.height+25, contentLab.width, 55)];
        replyCommentView.replyDate = mod.ReTime;
        replyCommentView.replyContent = mod.ReContent;
        [self addSubview:replyCommentView];
        /*改变Cell的高度*/
    }
    [self UpdateUIWithMod:mod];
}

#pragma mark -- 更新UI
-(void)UpdateUIWithMod:(CommentListMod*)mod
{
    if(TitleLab)
    {
       TitleLab.text  =  mod.ArtName.length?[NSString stringWithFormat:@"%@ 的评价",mod.ArtName]:@"样品标题的评论";
    }
    [customHeaderIcon setImageWithURL:[NSURL URLWithString:mod.PhotoPath] placeholderImage:mImageByName(@"tx_02")];
    customNikeNameLab.text = mod.Nickname.length?mod.Nickname:@"匿名";
    if(publishDateLab)
    {
       publishDateLab.text = mod.EDate.length?mod.EDate:@"2015年10月";
    }
    contentLab.text = mod.Content.length?mod.Content:@"";
    CGFloat height = [XHDHelper heightOfString:mod.Content font:contentLab.font maxSize:CGSizeMake(contentLab.width, 1000)].height;
    contentLab.height = height>contentLab.height?height:contentLab.height;
    if(commentPicView)
    {
        commentPicView.picArr = mod.ImageData;
        commentPicView.top = contentLab.bottom+5;
    }
    
    if(replyCommentView)
    {
        replyCommentView.replyDate = mod.ReTime;
        replyCommentView.replyContent = mod.ReContent;
        replyCommentView.top = contentLab.bottom+commentPicView.height+20;
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _divLine.frame = mRect(0, self.height -1, kkDeviceWidth, 1);

}

#pragma mark -- 获取高度
+(CGFloat)getCellHeightWithModel:(CommentListMod*)mod
{
    CGFloat  height = mod.EDate.length?180:160;//头像+昵称
    
    /*内容高度*/
    CGFloat height_content = [XHDHelper heightOfString:mod.Content.length?mod.Content:@"1234321" font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(kkDeviceWidth-50, 1000)].height;
    height_content = height_content>30?height_content:30;
    height += height_content;
    
    /*图片高度*/
    if(mod.ImageData.count>0)
    {
        if( ((NSString*)mod.ImageData[0][@"EPicPath"]).length)
        {
            height += 80;
        }
    }
    
    /*回复高度*/
    if(mod.ReContent.length)
    {
        height += 50;
        /*回复内容高度*/
        CGFloat height_reContent = [XHDHelper heightOfString:mod.ReContent font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(kkDeviceWidth-60, 1000)].height;
        height_reContent = height_reContent>20?height_reContent:20;
        
        height += height_reContent+10;
    }
    return height;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
