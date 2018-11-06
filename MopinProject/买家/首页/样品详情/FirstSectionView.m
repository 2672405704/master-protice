//
//  FirstSectionView.m
//  MopinProject
//
//  Created by xhd945 on 15/12/10.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "FirstSectionView.h"
#import "XHDHelper.h"

@implementation FirstSectionView
{
    UIView *favoBgView; //点赞背景
    UILabel*_TitleLabel; //标题
    UILabel*_AttributeLabel;//属性
    UILabel*_EnableJuanLabel;//可用劵
    UILabel*_MoPinJuan;//磨品劵
    UILabel*_ShujiaJuan;//书家劵
    UILabel*_ArtIntroduceLabel;//作品介绍
    CustomControl *_favoriteBnt;//点赞按钮
    CustomControl*_collectionBnt;//收藏按钮
    CustomControl*_finishBnt;//成交按钮
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initUI];
    }
    return self;
}
- (void)initUI
{
    //标题
    _TitleLabel = [XHDHelper createLabelWithFrame:mRect(0, 10, self.width, 30) andText:_TitleStr.length?_TitleStr:@"标题字符串" andFont:UIFONT_Tilte(18) AndBackGround:[UIColor clearColor] AndTextColor:TitleFontColor];
    _TitleLabel.textAlignment =NSTextAlignmentCenter;
    [self addSubview:_TitleLabel];

    //属性
    _AttributeLabel = [XHDHelper createLabelWithFrame:mRect(0, _TitleLabel.bottom+2, self.width, 30) andText:_AttributeStr.length?_AttributeStr:@"中堂/行楷/90*120CM" andFont:[UIFont boldSystemFontOfSize:13] AndBackGround:[UIColor clearColor] AndTextColor:TipsFontColor];
    _AttributeLabel.textAlignment =NSTextAlignmentCenter;
    [self addSubview:_AttributeLabel];
    
    //可用劵
    _EnableJuanLabel = [XHDHelper createLabelWithFrame:mRect(self.width/2.0-50, _AttributeLabel.bottom+6, 100, 17) andText:_EnableJuanStr.length?_EnableJuanStr:@"可用劵：0%" andFont:[UIFont boldSystemFontOfSize:11] AndBackGround:[UIColor clearColor] AndTextColor:THEMECOLOR_1];
    _EnableJuanLabel.layer.borderColor = THEMECOLOR_1.CGColor;
    _EnableJuanLabel.layer.borderWidth = 0.5;
    _EnableJuanLabel.layer.cornerRadius = 4;
    _EnableJuanLabel.clipsToBounds =YES;
    _EnableJuanLabel.textAlignment =NSTextAlignmentCenter;
    [self addSubview:_EnableJuanLabel];
    
    //墨品劵
    _MoPinJuan = [XHDHelper createLabelWithFrame:mRect(0, _EnableJuanLabel.bottom+10, self.width, 20) andText:_MoPinJuanStr.length?_MoPinJuanStr: @"墨品劵 0%（￥0）" andFont:[UIFont boldSystemFontOfSize:13] AndBackGround:[UIColor clearColor] AndTextColor:TipsFontColor];
    _MoPinJuan.textAlignment =NSTextAlignmentCenter;
    [self addSubview:_MoPinJuan];
    
    //书家劵
    _ShujiaJuan = [XHDHelper createLabelWithFrame:mRect(0, _MoPinJuan.bottom+3, self.width, 20) andText:_ShujiaJuanStr.length?_ShujiaJuanStr: @"书家劵 0%（￥0）" andFont:[UIFont boldSystemFontOfSize:13] AndBackGround:[UIColor clearColor] AndTextColor:TipsFontColor];
    _ShujiaJuan.textAlignment =NSTextAlignmentCenter;
    [self addSubview:_ShujiaJuan];
    
    //分根线1
    [XHDHelper addDivLineWithFrame:mRect(20, _ShujiaJuan.bottom+10, self.width-40, 0.5) SuperView:self];
    
    /*TODO:介绍*/
    _ArtIntroduceLabel = [XHDHelper createLabelWithFrame:mRect(25, _ShujiaJuan.bottom+20, self.width-50, 60) andText:_ArtIntroduceStr.length?_ArtIntroduceStr:@"样品的详细介绍显示..." andFont:[UIFont systemFontOfSize:13] AndBackGround:[UIColor clearColor] AndTextColor:TipsFontColor];
    _ArtIntroduceLabel.numberOfLines = 0;
    [self addSubview:_ArtIntroduceLabel];
    
    
    //点赞背景
    favoBgView = [[UIView alloc]initWithFrame:mRect(20,_ArtIntroduceLabel.bottom+5, self.width-40,60)];
    [self addSubview:favoBgView];
    
    [XHDHelper addDivLineWithFrame:mRect(0,0, favoBgView.width, 0.5) SuperView:favoBgView];
    [XHDHelper addDivLineWithFrame:mRect(0, favoBgView.height-0.5, favoBgView.width, 0.5) SuperView:favoBgView];
    
    //3个按钮
    //赞
    _favoriteBnt = [[CustomControl alloc]initWithFrame:mRect(20, 15, (favoBgView.width-30)/3.0, favoBgView.height-10)];
    _favoriteBnt.Icon.image = mImageByName( _favoriteBnt.isSelected?@"good_easyicon_s":@"good_easyicon");
    _favoriteBnt.fuctionLabel.text = @"赞";
    _favoriteBnt.NumbelLab.text = _favoriteNum.length?_favoriteNum:@"0";
    _favoriteBnt.tag = 106;
    _favoriteBnt.selected = [_isZan isEqualToString:@"2"]?YES:NO;
    [favoBgView addSubview:_favoriteBnt];
    [_favoriteBnt addTarget:self action:@selector(customControlAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //收藏
    _collectionBnt = [[CustomControl alloc]initWithFrame:mRect(20+(favoBgView.width-30)/3.0, 15, (favoBgView.width-30)/3.0, favoBgView.height-10)];
    _collectionBnt.Icon.image = mImageByName( _collectionBnt.isSelected?@"start_favorite_s":@"start_favorite");
    _collectionBnt.fuctionLabel.text = @"收藏";
    _collectionBnt.tag = 107;
    _collectionBnt.NumbelLab.text = _collectionNum.length?_collectionNum:@"0";
    _collectionBnt.selected = [_isCollection isEqualToString:@"2"]?YES:NO;
    [_collectionBnt addTarget:self action:@selector(customControlAction:) forControlEvents:UIControlEventTouchUpInside];
    [favoBgView addSubview:_collectionBnt];
    
    //成交
    _finishBnt= [[CustomControl alloc]initWithFrame:mRect(20+(favoBgView.width-30)/3.0*2, 15, (favoBgView.width-30)/3.0, favoBgView.height-10)];
    _finishBnt.Icon.image =  mImageByName(_finishBnt.isSelected?@"cart":@"cart");
    _finishBnt.fuctionLabel.text = @"成交";
    _finishBnt.NumbelLab.text = _finishNum.length?_finishNum:@"0";
    [favoBgView addSubview:_finishBnt];
    
    
}

- (void)UpdateUI
{
  
    _TitleLabel.text = _TitleStr.length?_TitleStr:@"标题字符串";
    
    _AttributeLabel.text = _AttributeStr.length?_AttributeStr:@"中堂/行楷/90*120CM";
    
    _EnableJuanLabel.text = _EnableJuanStr.length?_EnableJuanStr:@"可用劵：0%";
    
    _MoPinJuan.text = _MoPinJuanStr.length?_MoPinJuanStr: @"墨品劵 0%（￥0）" ;
  
    _ShujiaJuan.text = _ShujiaJuanStr.length?_ShujiaJuanStr: @"书家劵 0%（￥0）";
    
    _ArtIntroduceLabel.text = _ArtIntroduceStr.length?_ArtIntroduceStr:@"样品的详细介绍显示";
    
    _favoriteBnt.selected = [_isZan isEqualToString:@"2"]?YES:NO;
    [favoBgView addSubview:_favoriteBnt];
    _collectionBnt.selected = [_isCollection isEqualToString:@"2"]?YES:NO;
    
    _favoriteBnt.Icon.image = mImageByName( _favoriteBnt.isSelected?@"good_easyicon_s":@"good_easyicon");
    _favoriteBnt.fuctionLabel.text = @"赞";
    _favoriteBnt.NumbelLab.text = _favoriteNum.length?_favoriteNum:@"0";
    _favoriteBnt.selected = [_isZan isEqualToString:@"2"]?YES:NO;
    [favoBgView addSubview:_favoriteBnt];
    _collectionBnt.Icon.image = mImageByName( _collectionBnt.isSelected?@"start_favorite_s":@"start_favorite");;
    _collectionBnt.fuctionLabel.text = @"收藏";
    _collectionBnt.NumbelLab.text = _collectionNum.length?_collectionNum:@"0";
    _collectionBnt.selected = [_isCollection isEqualToString:@"2"]?YES:NO;
    _finishBnt.Icon.image =  mImageByName(_finishBnt.isSelected?@"cart":@"cart");
    _finishBnt.fuctionLabel.text = @"成交";
    _finishBnt.NumbelLab.text = _finishNum.length?_finishNum:@"0";
    
    //自适应高度
    NSLog(@"%@====",_ArtIntroduceLabel.text);
    NSLog(@"%lf====",_ArtIntroduceLabel.width-5);
    CGFloat oldH = _ArtIntroduceLabel.height;
    CGFloat height =  [_ArtIntroduceLabel.text boundingRectWithSize:CGSizeMake(_ArtIntroduceLabel.width, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
    
    _ArtIntroduceLabel.height = height>60?height+10:60;
    self.height = self.height+ _ArtIntroduceLabel.height - oldH;
    
    favoBgView.top = _ArtIntroduceLabel.bottom+10;

}
#pragma mark -- 自定制按钮的点击事件
- (void)customControlAction:(CustomControl*)sender
{
    if(sender.tag == 106 || sender.tag == 107)
    {

        if(![PersonalInfoSingleModel shareInstance].isLogin)
        {
            if([_delegate respondsToSelector:@selector(gotoLogin)])
            {
                [_delegate gotoLogin];
            }
             return;
        }
       
    }
    sender.selected = !sender.isSelected;
    
    if(sender.tag == 106) //点赞
    {
        _favoriteBnt.Icon.image = mImageByName( _favoriteBnt.isSelected?@"good_easyicon_s":@"good_easyicon");
        if(sender.isSelected)
        {
            _favoriteBnt.NumbelLab.text = [NSString stringWithFormat:@"%ld",(_favoriteNum.integerValue+1)];
            _favoriteNum = [NSString stringWithFormat:@"%ld",_favoriteNum.integerValue+1];
            
            [self favoriteOperationWithType:1];
            
        }
        else
        {
            _favoriteBnt.NumbelLab.text = [NSString stringWithFormat:@"%ld",(_favoriteNum.integerValue-1)];
            _favoriteNum = [NSString stringWithFormat:@"%ld",_favoriteNum.integerValue-1];
            [self favoriteOperationWithType:2];
            
        }
        
        
    }
    else if(sender.tag == 107) //收藏
    {
        _collectionBnt.Icon.image = mImageByName( _collectionBnt.isSelected?@"start_favorite_s":@"start_favorite");;
        if(sender.isSelected)
        {
            _collectionBnt.NumbelLab.text = [NSString stringWithFormat:@"%ld",(_collectionNum.integerValue+1)];
            _collectionNum = [NSString stringWithFormat:@"%ld",_collectionNum.integerValue+1];
            
            [self collectionOperationWithType:1];
            
        }else{
            
            _collectionBnt.NumbelLab.text = [NSString stringWithFormat:@"%ld",(_collectionNum.integerValue-1)];
            _collectionNum = [NSString stringWithFormat:@"%ld",_collectionNum.integerValue-1];
            [self collectionOperationWithType:2];
        }
        
    }

    

}
#pragma mark -- 网络请求
/*点赞or取消   1：赞  2：取消赞*/
- (void)favoriteOperationWithType:(NSInteger)type
{
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"ZanDeal" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:[PersonalInfoSingleModel shareInstance].UserID forKey:@"UserID"];
    [parameterDic setValue:_ArtID forKey:@"ID"];
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
            [mNotificationCenter postNotificationName:RefreshPenmanAllSampleList object:nil];
            
            
            if (_delegate && [_delegate respondsToSelector:@selector(backToRefreshPenmanDetail)])  //刷新书家
            {
                [_delegate backToRefreshPenmanDetail];
            }
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
    [parameterDic setValue:_ArtID forKey:@"ID"];
   
    
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
            //刷新书家
            
            [mNotificationCenter postNotificationName:RefreshPenmanAllSampleList object:nil];
            //刷新全部样品
            
            if (_delegate && [_delegate respondsToSelector:@selector(backToRefreshPenmanDetail)]) //刷新书家
            {
                [_delegate backToRefreshPenmanDetail];
            }
            
            [SVProgressHUD showSuccessWithStatus:type==1?@"已收藏":@"已取消收藏"];
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}

@end


#pragma mark -- 自定制按钮
@implementation CustomControl

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self _initUI];
    }
    return self;
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
     if(selected == YES)
     {
       _fuctionLabel.textColor = THEMECOLOR_1;
         _NumbelLab.textColor = THEMECOLOR_1;
     }else
     {
       _fuctionLabel.textColor = TipsFontColor;
       _NumbelLab.textColor = TipsFontColor;
     }
}
-(void)_initUI
{
    _Icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 3.9, 15, 15)];
    _Icon.backgroundColor = [UIColor clearColor];
    [self addSubview:_Icon];

    _fuctionLabel  = [[UILabel alloc]initWithFrame:CGRectMake(_Icon.right+5, 5, 40, 15)];
    _fuctionLabel.text  = @"赞";
    _fuctionLabel.textColor = TipsFontColor;
    _fuctionLabel.textAlignment = NSTextAlignmentLeft;
    _fuctionLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_fuctionLabel];
    
    
    _NumbelLab  = [[UILabel alloc]initWithFrame:CGRectMake(_Icon.frame.origin.x, _Icon.bottom+2.5,_Icon.width+_fuctionLabel.width-10, 15)];
    _NumbelLab.text  = @"0";
    _NumbelLab.textColor = TipsFontColor;
    _NumbelLab.textAlignment = NSTextAlignmentCenter;
    _NumbelLab.font = [UIFont systemFontOfSize:13];
    [self addSubview:_NumbelLab];
    
}

@end