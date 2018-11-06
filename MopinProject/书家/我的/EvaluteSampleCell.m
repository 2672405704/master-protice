//
//  EvaluteSampleCell.m
//  MopinProject
//
//  Created by rt008 on 15/12/2.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "EvaluteSampleCell.h"
#import "EvaluteListModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "PenmanDetailCommentModel.h"
#import "ImgShowViewController.h"

@interface EvaluteSampleCell()

@property (weak, nonatomic) IBOutlet UIView *imageBgView;
@property (weak, nonatomic) IBOutlet UIView *buttonBgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *stickBtn;
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;
@property (weak, nonatomic) IBOutlet UIView *replyBgView;
@property (weak, nonatomic) IBOutlet UILabel *replyDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyContentLabel;
@end

@implementation EvaluteSampleCell
{
    PenmanDetailCommentModel *_penmanDetailCommentModel;
}
- (void)awakeFromNib {
    // Initialization code
    _headImageView.layer.cornerRadius=CGRectGetWidth(_headImageView.frame)/2;
    _headImageView.layer.masksToBounds=YES;
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    _replyBgView.layer.cornerRadius=3;
    _replyBgView.layer.masksToBounds=YES;
}
- (void)reloadCell
{
    _titleLabel.text=[NSString stringWithFormat:@"%@ 的评价",_model.ArtName];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_model.PhotoPath] placeholderImage:mImageByName(PlaceHeaderSquareImage)];
    _nameLabel.text=_model.Nickname;
    NSArray *dateArr=[_model.EDate componentsSeparatedByString:@"-"];
    if(dateArr.count>2)
    {
      _timeLabel.text=[NSString stringWithFormat:@"%d年%d月%d日",[dateArr[0] intValue],[dateArr[1] intValue],[dateArr[2] intValue]];
    }
    
    _contentLabel.text=_model.Content;
    
    CGFloat height;
    if(IOS7_AND_LATER){
        height=[_contentLabel.text boundingRectWithSize:CGSizeMake(kkDeviceWidth-60,MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_contentLabel.font} context:nil].size.height;
    }else{
        height=[_contentLabel.text sizeWithFont:_contentLabel.font constrainedToSize:CGSizeMake(kkDeviceWidth-60,MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
    }
    CGRect frame=_contentLabel.frame;
    frame.size.height=height;
    _contentLabel.frame=frame;
    
    if(_model.ImageData.count!=0){
        for(int i=0;i<_model.ImageData.count;i++){
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake((60+10)*i, 0, 60, 60);
            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:_model.ImageData[i]] forState:UIControlStateNormal placeholderImage:mImageByName(PlaceHeaderSquareImage)];
            [_imageBgView addSubview:button];
            button.tag=100+i;
            [button addTarget:self action:@selector(showBigPhoto:) forControlEvents:UIControlEventTouchUpInside];
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
    if(_model.ReContent.length!=0){
        _replyContentLabel.text=_model.ReContent;
        _replyDateLabel.text=_model.ReTime;
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
        
        _replyBtn.hidden=YES;
        frame=_stickBtn.frame;
        frame.origin.x=(_buttonBgView.frame.size.width-frame.size.width)/2;
        _stickBtn.frame=frame;
    }else{
        _replyBtn.hidden=NO;
        frame=_replyBtn.frame;
        frame.origin.x=(_buttonBgView.frame.size.width-frame.size.width*2-10)/2;
        _replyBtn.frame=frame;
        
        frame=_stickBtn.frame;
        frame.origin.x=CGRectGetMaxX(_replyBtn.frame)+10;
        _stickBtn.frame=frame;
        
        frame=_replyBgView.frame;
        frame.size.height=0;
        frame.origin.y=CGRectGetMaxY(_imageBgView.frame);
        _replyBgView.frame=frame;
    }
    
    frame=_buttonBgView.frame;
    frame.origin.y=CGRectGetMaxY(_replyBgView.frame)+33;
    _buttonBgView.frame=frame;
    
    frame=_bgView.frame;
    frame.size.height=CGRectGetMaxY(_buttonBgView.frame);
    _bgView.frame=frame;
    
}
- (void)showBigPhoto:(UIButton *)button
{
    NSMutableArray *imageArr=[[NSMutableArray alloc]init];
    for(NSString *imageStr in _model.ImageData){
        [imageArr addObject:[NSURL URLWithString:imageStr]];
    }
    UIViewController *vc=(UIViewController *)_delegate;
    ImgShowViewController *showVC = [[ImgShowViewController alloc]initWithSourceData:imageArr withIndex:button.tag-100];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:showVC];
    [vc.navigationController presentViewController:navi animated:YES completion:nil];
}
//TODO:回复
- (IBAction)replyBtnClick:(id)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(replyEvalute:)]){
        [_delegate replyEvalute:_model];
    }
}
//TODO:置顶
- (IBAction)stickBtnClick:(id)sender {
    [SVProgressHUD show];

    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"CommentTop" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_model.EID forKey:@"EID"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000) {
            if(_delegate && [_delegate respondsToSelector:@selector(stickEvaluteList:)]){
                [_delegate stickEvaluteList:_model];
            }
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}
+ (CGFloat)getHeightWithModel:(EvaluteListModel *)model
{
    CGFloat height;
    if(IOS7_AND_LATER){
        height=[model.Content boundingRectWithSize:CGSizeMake(kkDeviceWidth-60,MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    }else{
        height=[model.Content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(kkDeviceWidth-60,MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
    }
    height=192+height;
    
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
    height+=103+10;
    
    return height;
}
- (void)reloadPenmanDetailCommentWithModel:(PenmanDetailCommentModel *)model
{
    _penmanDetailCommentModel=model;
    
    _titleLabel.hidden=YES;
    _buttonBgView.hidden=YES;
    _timeLabel.hidden=YES;
    _bgView.backgroundColor=toPCcolor(@"eeeeee");
    _imageBgView.backgroundColor=_bgView.backgroundColor;
//    _bgView.backgroundColor=[UIColor redColor];
    
    CGRect frame=_headImageView.frame;
    frame.origin.y=20;
    _headImageView.frame=frame;
    
    frame=_nameLabel.frame;
    frame.origin.y=CGRectGetMaxY(_headImageView.frame);
    _nameLabel.frame=frame;
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.EPhoto] placeholderImage:mImageByName(PlaceHeaderSquareImage)];
    _nameLabel.text=model.ENickName;
    _contentLabel.text=model.EContent;
    
    CGFloat height;
    if(IOS7_AND_LATER){
        height=[_contentLabel.text boundingRectWithSize:CGSizeMake(kkDeviceWidth-60,40) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_contentLabel.font} context:nil].size.height;
    }else{
        height=[_contentLabel.text sizeWithFont:_contentLabel.font constrainedToSize:CGSizeMake(kkDeviceWidth-60,40) lineBreakMode:NSLineBreakByCharWrapping].height;
    }
    frame=_contentLabel.frame;
    frame.origin.y=CGRectGetMaxY(_nameLabel.frame)+15;
    frame.size.height=height;
    _contentLabel.frame=frame;
    
    if(model.ImageDataArr.count!=0){
        for(int i=0;i<model.ImageDataArr.count;i++){
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake((60+10)*i, 0, 60, 60);
            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:model.ImageDataArr[i]] forState:UIControlStateNormal placeholderImage:mImageByName(PlaceHeaderSquareImage)];
            [_imageBgView addSubview:button];
            button.tag=100+i;
            [button addTarget:self action:@selector(showBigPhotoInPenmanDetail:) forControlEvents:UIControlEventTouchUpInside];
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
        if(IOS7_AND_LATER){
            height=[_replyContentLabel.text boundingRectWithSize:CGSizeMake(kkDeviceWidth-60,40) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_replyContentLabel.font} context:nil].size.height;
        }else{
            height=[_replyContentLabel.text sizeWithFont:_replyContentLabel.font constrainedToSize:CGSizeMake(kkDeviceWidth-60,40) lineBreakMode:NSLineBreakByCharWrapping].height;
        }
        frame=_replyContentLabel.frame;
        frame.size.height=height;
        _replyContentLabel.frame=frame;
        
        frame=_replyBgView.frame;
        frame.origin.y=CGRectGetMaxY(_imageBgView.frame)+25;
        frame.size.height=CGRectGetMaxY(_replyContentLabel.frame)+15;
        _replyBgView.frame=frame;
        
    }else{
        frame=_replyBgView.frame;
        frame.size.height=0;
        frame.origin.y=CGRectGetMaxY(_imageBgView.frame);
        _replyBgView.frame=frame;
    }
    
    frame=_bgView.frame;
    frame.size.height=CGRectGetMaxY(_replyBgView.frame)+15;
    _bgView.frame=frame;
}
//TODO:点击书家详情里的评论图片
- (void)showBigPhotoInPenmanDetail:(UIButton *)button
{
    NSMutableArray *imageArr=[[NSMutableArray alloc]init];
    for(NSString *imageStr in _penmanDetailCommentModel.ImageDataArr){
        [imageArr addObject:[NSURL URLWithString:imageStr]];
    }
    UIViewController *vc=(UIViewController *)_delegate;
    ImgShowViewController *showVC = [[ImgShowViewController alloc]initWithSourceData:imageArr withIndex:button.tag-100];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:showVC];
    [vc.navigationController presentViewController:navi animated:YES completion:nil];
}
+ (CGFloat)getHeightWithModelInPenmanDetail:(PenmanDetailCommentModel *)model
{
    CGFloat height;
    if(IOS7_AND_LATER){
        height=[model.EContent boundingRectWithSize:CGSizeMake(kkDeviceWidth-60,40) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    }else{
        height=[model.EContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(kkDeviceWidth-60,40) lineBreakMode:NSLineBreakByCharWrapping].height;
    }
    height=132+height;
    
    if(model.ImageDataArr.count!=0){
        height+=80;
    }
    CGFloat replyHeight;
    if(model.ReContent.length!=0){
        if(IOS7_AND_LATER){
            replyHeight=[model.ReContent boundingRectWithSize:CGSizeMake(kkDeviceWidth-60,40) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
        }else{
            replyHeight=[model.ReContent sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(kkDeviceWidth-60,40) lineBreakMode:NSLineBreakByCharWrapping].height;
        }
        height+=replyHeight+37+15+25;
    }
    height+=30;
    
    return height;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
