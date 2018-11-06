//
//  PenmanDetailSampleCell.m
//  MopinProject
//
//  Created by rt008 on 15/12/10.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "PenmanDetailSampleCell.h"
#import "PenmanDetailSampleModel.h"
#import "UIImageView+WebCache.h"

@interface PenmanDetailSampleCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;//背景视图
@property (weak, nonatomic) IBOutlet UIImageView *publicImageIcon;//公益标识

@property (weak, nonatomic) IBOutlet UIButton *favoriteBnt;//点赞
@property (weak, nonatomic) IBOutlet UIButton *collectionBnt;//收藏
@property (weak, nonatomic) IBOutlet UIButton *finishBnt;//成交

@property (weak, nonatomic) IBOutlet UIImageView *divLine_1;
@property (weak, nonatomic) IBOutlet UIImageView *divLine_2;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;

@property (weak, nonatomic) IBOutlet UIButton *couponButton; //可用劵

@property (weak, nonatomic) IBOutlet UILabel *collectionNumLabel; //收藏数

@property (weak, nonatomic) IBOutlet UILabel *bookedNumLabel;//成交数
@property (weak, nonatomic) IBOutlet UILabel *zanNumLabel; //赞数

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;//图片



@end

@implementation PenmanDetailSampleCell

- (void)awakeFromNib {
   
    self.contentView.userInteractionEnabled = YES;
    _bgView.userInteractionEnabled = YES;
    
    _topImageView.contentMode=UIViewContentModeScaleAspectFill;
    _topImageView.backgroundColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.9 alpha:1];
    _topImageView.clipsToBounds=YES;
    
    
    self.backgroundColor =  [UIColor clearColor];
    _divLine_1.height = 0.5;
    _divLine_2.height = 0.5;
    
    /*配置按钮属性*/
    [_finishBnt setTitleColor:TipsFontColor forState:UIControlStateNormal];
    [_finishBnt setTitleColor:THEMECOLOR_1 forState:UIControlStateSelected];
    
    [_collectionBnt setTitleColor:TipsFontColor forState:UIControlStateNormal];
    [_collectionBnt setTitleColor:THEMECOLOR_1 forState:UIControlStateSelected];
    [_collectionBnt setImage:mImageByName(@"start_favorite")forState:UIControlStateNormal];
    [_collectionBnt setImage:mImageByName(@"start_favorite_s") forState:UIControlStateSelected];
    
    [_favoriteBnt setTitleColor:TipsFontColor forState:UIControlStateNormal];
    [_favoriteBnt setTitleColor:THEMECOLOR_1 forState:UIControlStateSelected];
    [_favoriteBnt setImage:mImageByName(@"good_easyicon")forState:UIControlStateNormal];
    [_favoriteBnt setImage:mImageByName(@"good_easyicon_s") forState:UIControlStateSelected];
    
    _bookedNumLabel.textColor = TipsFontColor;
    _zanNumLabel.textColor = TipsFontColor;
    _collectionNumLabel.textColor = TipsFontColor;
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _collectionBnt.selected = NO;
    _favoriteBnt.selected = NO;
    
    _nameLabel.text=_model.ProductName;
    _priceLabel.text=_model.Price.length?[NSString stringWithFormat:@"%ld",_model.Price.integerValue]:@"0";
    
    _favoriteBnt.selected = [_model.IsZan isEqualToString:@"2"]?YES:NO;
    _collectionBnt.selected = [_model.IsCollect isEqualToString:@"2"]?YES:NO;
    
    _zanNumLabel.textColor = _favoriteBnt.isSelected?THEMECOLOR_1:TipsFontColor;
    _collectionNumLabel.textColor = _collectionBnt.isSelected?THEMECOLOR_1:TipsFontColor;
    
    _styleLabel.text=[NSString stringWithFormat:@"%@/%@/%@",_model.ShowType,_model.WordType,_model.Size];
    [_couponButton setTitle:[NSString stringWithFormat:@"可用券：%@%%",_model.CouponsRatio.length?_model.CouponsRatio:@"0%"] forState:UIControlStateNormal];
    _zanNumLabel.text=_model.ZanNum.length?_model.ZanNum:@"0";
    _collectionNumLabel.text=_model.CollectNum.length?_model.CollectNum:@"0";
    _bookedNumLabel.text=_model.BookedNum.length?_model.BookedNum:@"0";
    
    [_topImageView sd_setImageWithURL:[NSURL URLWithString:_model.ArtPic] placeholderImage:mImageByName(PlaceHeaderSquareImage)];
    
    /*公益作品相关处理*/
    _publicImageIcon.hidden = YES;
    if([[[PublicWelfareManager shareInstance]getPublicWelfareState] isEqualToString:@"1"])
    {
        /*书家列表公益标签*/
        if([_model.IsPublicGoodSample isEqualToString:@"0"] ||_model.IsPublicGoodSample==0)
        {
            _publicImageIcon.hidden = YES;
            
        }else{
            
            _publicImageIcon.hidden = NO;
            if([_model.IsPublicGoodSample isEqualToString:@"1"])
            {
                _publicImageIcon.image = [UIImage imageNamed:@"red_sign"];
                
            }else if([_model.IsPublicGoodSample isEqualToString:@"2"])
            {
                _publicImageIcon.image = [UIImage imageNamed:@"gray"];
            }
            
        }
        
    }else{
        
        _publicImageIcon.hidden = YES;
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
/*点赞*/
- (IBAction)favoriteButtonAction:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    _zanNumLabel.textColor = sender.isSelected?THEMECOLOR_1:TipsFontColor;
    //没登陆就去登陆
    if(![PersonalInfoSingleModel shareInstance].isLogin)
    {
        if([_delegate respondsToSelector:@selector(gotoLogin)])
        {
            [_delegate gotoLogin];
        }
        return;
    }
    if(sender.isSelected)
    {
        _zanNumLabel.text = [NSString stringWithFormat:@"%ld",(_model.ZanNum.integerValue+1)];
        _model.ZanNum = [NSString stringWithFormat:@"%ld",_model.ZanNum.integerValue+1];
        
        [self favoriteOperationWithType:1];
        
    }
    else
    {
        _zanNumLabel.text = [NSString stringWithFormat:@"%ld",(_model.ZanNum.integerValue-1)];
        _model.ZanNum = [NSString stringWithFormat:@"%ld",_model.ZanNum.integerValue-1];
        [self favoriteOperationWithType:2];
        
    }

    
    NSLog(@"/*点赞*/");
    
}

/*收藏*/
- (IBAction)collectionButtonAction:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
     _collectionNumLabel.textColor = sender.isSelected?THEMECOLOR_1:TipsFontColor;
    //没登陆就去登陆
    if(![PersonalInfoSingleModel shareInstance].isLogin)
    {
        if([_delegate respondsToSelector:@selector(gotoLogin)])
        {
            [_delegate gotoLogin];
        }
        return;
    }
    if(sender.isSelected)
    {
        _collectionNumLabel.text = [NSString stringWithFormat:@"%ld",(_model.CollectNum.integerValue+1)];
        _model.CollectNum = [NSString stringWithFormat:@"%ld",_model.CollectNum.integerValue+1];
        
        [self collectionOperationWithType:1];
        
    }else{
        
        _collectionNumLabel.text = [NSString stringWithFormat:@"%ld",(_model.CollectNum.integerValue-1)];
        _model.CollectNum = [NSString stringWithFormat:@"%ld",_model.CollectNum.integerValue-1];
        [self collectionOperationWithType:2];
    }
    
    NSLog(@"/*收藏*/");
    
}

#pragma mark -- 网络请求
/*点赞or取消   1：赞  2：取消赞*/
- (void)favoriteOperationWithType:(NSInteger)type
{
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"ZanDeal" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:[PersonalInfoSingleModel shareInstance].UserID forKey:@"UserID"];
    [parameterDic setValue:_model.ArtID forKey:@"ID"];
    [parameterDic setValue:[NSString stringWithFormat:@"%@",@(type)] forKey:@"Type"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000)
        {
            [mNotificationCenter postNotificationName:RefreshPenmanDetail object:nil];
            
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}
/*收藏or取消 1：收藏  2：取消收藏 */
- (void)collectionOperationWithType:(NSInteger)type
{
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"FavoritesDeal" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:[NSString stringWithFormat:@"%@",@(type)] forKey:@"Type"];
    [parameterDic setValue:[PersonalInfoSingleModel shareInstance].UserID forKey:@"UserID"];
    [parameterDic setValue:_model.ArtID forKey:@"ID"];
    
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFavorites object:nil]; //刷新收藏界面
            
            [mNotificationCenter postNotificationName:RefreshPenmanDetail object:nil];
            
            [SVProgressHUD showSuccessWithStatus:type==1?@"已收藏":@"已取消收藏"];
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}


@end
