//
//  UserCommentCell.m
//  MopinProject
//
//  Created by happyzt on 15/12/18.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "UserCommentCell.h"
#import "XHDHelper.h"
#import "UIImageView+WebCache.h"


#pragma mark  --  图片列表
@interface PiListViw : UIView

@property(nonatomic,strong)NSArray *picArr; //图片列表


@end

@implementation PiListViw
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self _initUI];
    }
    return self;
}
-(void)_initUI
{
    if(_picArr.count>0)
    {
        for(NSInteger i= 0;i<_picArr.count;i++)
        {
            NSString *picUrl = _picArr[i];
            
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:mRect(i*55,0,50, 50)];
            imageView.tag = 990+i;
            [imageView setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:mImageByName(PlaceHeaderIconImage)];
            [self addSubview:imageView];
        }
    }
}
-(void)layoutSubviews
{
    if(_picArr.count==0)
    {
        self.height = 0;
    }
    else{
        
        self.height = 50;
        for(NSInteger i = 0;i<self.subviews.count;i++)
        {
            UIImageView *tem = self.subviews[i];
            [tem setImageWithURL:[NSURL URLWithString:_picArr[i]] placeholderImage:mImageByName(PlaceHeaderIconImage)];
        }
    }
    
}

@end

@implementation UserCommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self _initUI];
        
        //监听回复内容
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReplyContentNotification:) name:@"ReplyContentNotification" object:nil];
    }
    
    return self;
}

-(void)_initUI
{
    //样品 --的评价
    TitleLab = [XHDHelper createLabelWithFrame:mRect(20, 10, mScreenWidth-40, 20) andText:_titleName.length?[NSString stringWithFormat:@"%@ 的评价",_titleName]:@"样品标题的评论" andFont:UIFONT_Tilte(16) AndBackGround:[UIColor clearColor] AndTextColor:TitleFontColor];
//    TitleLab.backgroundColor = [UIColor redColor];
    TitleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:TitleLab];
    
    //用户头像
    customHeaderIcon = [XHDHelper createImageViewWithFrame:mRect(mScreenWidth/2.0-30, TitleLab.bottom+10, 60, 60) AndImageName:@"bg04@2x.png" AndCornerRadius:30 andGestureRecognizer:0 AndTarget:nil AndAction:nil];
    customHeaderIcon.layer.cornerRadius = 30;
    [self addSubview:customHeaderIcon];
    
    //买家昵称
    UIColor *clearColor = [UIColor clearColor];
    customNikeNameLab = [XHDHelper createLabelWithFrame:mRect(mScreenWidth/2.0-100, customHeaderIcon.bottom+5, 200, 25) andText:_NikeName.length?_NikeName:@"匿名" andFont:[UIFont systemFontOfSize:15] AndBackGround:clearColor AndTextColor:MainFontColor];
    customNikeNameLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:customNikeNameLab];
    
    //发布时间
    publishDateLab =[XHDHelper createLabelWithFrame:mRect(mScreenWidth/2.0-100, customNikeNameLab.bottom+2, 200, 10) andText:_PulishDate.length?_PulishDate:@"2015年10月" andFont:[UIFont systemFontOfSize:10] AndBackGround:clearColor AndTextColor:TipsFontColor];
    publishDateLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:publishDateLab];
    
    //评论内容
    contentLab = [XHDHelper createLabelWithFrame:mRect(25, customNikeNameLab.bottom+8, mScreenWidth-50, 40) andText:_Content.length?_Content:@"2015年10月" andFont:[UIFont systemFontOfSize:11] AndBackGround:clearColor AndTextColor:TipsFontColor];
    contentLab.numberOfLines = 0;
    [self addSubview:contentLab];
    
    //书家回复
    
    
    //图片列表
    PiListViw *commentPicView = [[PiListViw alloc]initWithFrame:mRect(contentLab.origin.x, contentLab.bottom+5, self.width-50,55)];
    commentPicView.picArr = _ImageArr;
    [self addSubview:commentPicView];
    
    //按钮
    NSArray *buttonContent = @[@"回复",@"置顶"];
    for (int i = 0; i <2; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(40+(140*i+15), contentLab.bottom+20, 120, 40)];
        button.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        button.layer.borderWidth = 0.5;
        button.layer.cornerRadius = 5;
        button.tag = 300+i;
        [button setTitle:buttonContent[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(replayAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:button];
    }
   
}


//TODO:书家回复
- (void)ReplyContentNotification:(NSNotification *)notification {
     UIView *replayBgView = [[UIView alloc] initWithFrame:CGRectMake(25, contentLab.bottom+10, mScreenWidth-50, 60)];
    replayBgView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:replayBgView];
}


- (void)replayAction:(UIButton *)button {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CommentButtonActionNotification"
                                                        object:self
                                                      userInfo:@{@"buttonTag":[NSString stringWithFormat:@"%ld",button.tag]}];
    
}

@end
