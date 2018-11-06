//
//  KuangBiaoChooseView.m
//  MopinProject
//
//  Created by xhd945 on 15/12/16.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "KuangBiaoChooseView.h"
#import "UIRadioControl.h"
#import "XHDHelper.h"
#import "UIKit+AFNetworking.h"
#import "ZhuanBiaoTypeMod.h"
#import "CommonEmptyTableBgView.h"  //空载页

/*默认选中的是第一个样式的第一个按钮*/
#define BntHeight 30

@interface ZBCustomButton : UIButton

@end
@implementation ZBCustomButton

-(instancetype)initWithFrame:(CGRect)frame AndTitle:(NSString*)title
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.selected = NO;
        self.frame = frame;
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateSelected];
        
        [self setTitleColor:MainFontColor forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        
    
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.borderColor = TipsFontColor.CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if(self.selected == YES)
    {
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.backgroundColor = THEMECOLOR_1;
        self.layer.borderWidth = 0.5;
        
    
    }else{
    
        self.layer.borderColor = TipsFontColor.CGColor;
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = 0.5;
    
    }
}

@end


/*要传入样式的字典数组，包括ID和图片的URL，以及转表后的尺寸和价格*/
@implementation KuangBiaoChooseView
{
    UIView * BaseView;
    UIView *headerBgView; //头部背景
    UIScrollView *buttonBgView;  //按钮背景
    NSString *chooseID;  //选中的
    UIImageView *displayImageView;//图片展示
    UILabel* sizeLabel;//尺寸
    UILabel *zhuanBiaoFee;//装裱费
    NSMutableArray *dataArr; //数据源
    
    NSString*oldSelectID;  //上次选中的ID
    NSString*oldSelectName; //上次选中的Name
    
    
}


- (instancetype)initWithFrame:(CGRect)frame  StyleID:(NSString*)StyleID StyleName:(NSString*)name
{
    self = [super initWithFrame:frame];
    if (self) {
        
        oldSelectID = StyleID;
        oldSelectName = name;
        self.backgroundColor = [UIColor whiteColor];
        dataArr = [[NSMutableArray alloc]init];
        [self initDisplay];
    }
    return self;
}

#pragma 设置数据源
- (void)setDataDic:(NSDictionary *)dataDic
{
    if(_dataDic!=dataDic)
    {
        _dataDic = dataDic;
    }
    /*解析字典，获取数组*/
    for(NSDictionary *dic in _dataDic[@"ZhBStyleData"])
    {
        ZhuanBiaoTypeMod *mod = [[ZhuanBiaoTypeMod alloc]init];
        [mod setValuesForKeysWithDictionary:dic];
        [dataArr addObject:mod];
    }
    [self initDisplay];
}

#pragma mark -- 初始化UI
- (void)initDisplay
{
    for(UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    
    BaseView = [[UIView alloc]initWithFrame:mRect(0, 0,self.width, 200)];
    BaseView.backgroundColor = [UIColor whiteColor];
    [self addSubview:BaseView];
    
    //按钮组件
    headerBgView = [[UIView alloc]initWithFrame:mRect(0, 0, self.width,50)];
    headerBgView.backgroundColor = [UIColor whiteColor];
    [BaseView addSubview:headerBgView];
    
    
    buttonBgView = [[UIScrollView alloc]initWithFrame:mRect(0, 15, self.width,30)];
    buttonBgView.contentSize = CGSizeMake(0,buttonBgView.height);
    buttonBgView.backgroundColor = [UIColor whiteColor];
    buttonBgView.userInteractionEnabled = YES;
    [headerBgView addSubview:buttonBgView];
    
    if(dataArr.count<=4)
    {
        buttonBgView.height = (dataArr.count-1)*5+BntHeight*dataArr.count;
        headerBgView.height = buttonBgView.height +30;
        buttonBgView.contentSize = CGSizeMake(buttonBgView.width, buttonBgView.height);
        
    }else{
        
        buttonBgView.height = BntHeight*4+15;
        headerBgView.height = buttonBgView.height +30;
        buttonBgView.contentSize = CGSizeMake(buttonBgView.width, (dataArr.count-1)*5+BntHeight*dataArr.count);
    }


    /*样式过多的时候得优化一下，用循环来弄*/
    if (dataArr.count>0)
    {
        for (int i = 0; i < dataArr.count; i++)
        {
            ZhuanBiaoTypeMod *mod_0 = dataArr[i];
            CGRect frame = CGRectMake(25,(BntHeight+5)*i, headerBgView.width-50, BntHeight);
            
            UIButton *commentButton = [[ZBCustomButton alloc ]initWithFrame:frame AndTitle:mod_0.ZhBStyleName];
            
            commentButton.tag = 10200+i;
            [commentButton addTarget:self action:@selector(selecteCommentAction:) forControlEvents:UIControlEventTouchUpInside];
            [buttonBgView addSubview:commentButton];
            
            /*默认选中第一个,要做代入处理，按钮选中，滚动到默认位置*/
            if(oldSelectName.length && oldSelectID)
            {
                if([mod_0.ZhBStyle isEqualToString:oldSelectID]&& [mod_0.ZhBStyleName isEqualToString:mod_0.ZhBStyleName])
                {
                      commentButton.selected = YES;
                    if(i>4)
                    {
                        buttonBgView.contentOffset = CGPointMake(0, (i-1)*(BntHeight+5));
                    }
                }
            
            }else if(i==0){
                
               commentButton.selected = YES;
            }
    }
    

    /*填充默认第一个的信息*/
    ZhuanBiaoTypeMod *mod;
    if(dataArr.count>0)
    {
        mod = dataArr[0];
        if(_finishChoose)
        {
            mod.ZhBTypeID = _dataDic[@"ZhBType"];
            _finishChoose(mod);
        }
    }
    
    //图片
    displayImageView = [[UIImageView alloc]initWithFrame:mRect(25,buttonBgView.bottom+10, BaseView.width-50, 120)];
     [displayImageView setImageWithURL:[NSURL URLWithString:mod.ZhBStylePic] placeholderImage: mImageByName(PlaceHeaderRectangularImage)];
    displayImageView.tag = 1111;
    [BaseView addSubview:displayImageView];
   
    //尺寸
    sizeLabel = [XHDHelper createLabelWithFrame:mRect(25, displayImageView.bottom+15, BaseView.width-50, 40) andText:[NSString stringWithFormat:@"框裱后尺寸:%@",mod.ZhBSize] andFont:UIFONT(15) AndBackGround:[UIColor clearColor] AndTextColor:TipsFontColor];
    [BaseView addSubview:sizeLabel];
    //分割线
    [XHDHelper addDivLineWithFrame:mRect(0, 0, sizeLabel.width, 0.5) SuperView:sizeLabel];
    [XHDHelper addDivLineWithFrame:mRect(0, sizeLabel.height-0.5, sizeLabel.width, 0.5) SuperView:sizeLabel];
        
    //所需装裱费
    zhuanBiaoFee = [XHDHelper createLabelWithFrame:mRect(25, sizeLabel.bottom, BaseView.width-50, 40) andText:@"所需装裱费:￥0.00" andFont:UIFONT(15) AndBackGround:[UIColor clearColor] AndTextColor:TipsFontColor];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"所需装裱费:￥%@",mod.ZhBPrice]];
     [str addAttributes:@{NSForegroundColorAttributeName:THEMECOLOR_1} range:NSMakeRange(6, str.length-6)];
     zhuanBiaoFee.attributedText = str;
     [BaseView addSubview:zhuanBiaoFee];
    
      BaseView.height = headerBgView.height+displayImageView.height + sizeLabel.height + zhuanBiaoFee.height +30;
      self.height = BaseView.height;
        
    }else
    {
       /*应该提示下*/
        _emptyView = [[CommonEmptyTableBgView alloc]initWithFrame:mRect(0, -20, self.width, self.height)];
        _emptyView.tipsString = @"哦噢，没有任何数据哦~";
        [self addSubview:_emptyView];
    }
    
}

//TODO:该表图片，替换数据
- (void)selecteCommentAction:(UIButton*)sender
{
        for(UIView*view in buttonBgView.subviews)
        {
            if([view isKindOfClass:[UIButton class]])
            {
              ((UIButton*)view).selected = NO;
            }
            
        }
        sender.selected = YES;
    ZhuanBiaoTypeMod *mod = dataArr[sender.tag-10200];
      /*根据按钮的tag从数组中获取mod，然后填充数据,然后传回到控制器，在协议又传一个控制器*/
      [displayImageView setImageWithURL:[NSURL URLWithString:mod.ZhBStylePic] placeholderImage: mImageByName(PlaceHeaderRectangularImage)];
      NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"所需装裱费:￥%@",mod.ZhBPrice]];
     [str addAttributes:@{NSForegroundColorAttributeName:THEMECOLOR_1} range:NSMakeRange(6, str.length-6)];
      zhuanBiaoFee.attributedText = str;
      sizeLabel.text = [NSString stringWithFormat:@"装裱后尺寸:%@",mod.ZhBSize];

    if(_finishChoose)
    {
        mod.ZhBTypeID = _dataDic[@"ZhBType"];
        _finishChoose(mod);
    }
    
    
}

@end
