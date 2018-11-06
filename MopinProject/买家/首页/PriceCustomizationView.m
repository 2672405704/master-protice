//
//  PriceCustomizationView.m
//  MopinProject
//
//  Created by rt008 on 15/12/8.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "PriceCustomizationView.h"
#import "NMRangeSlider.h"
#import "GetSampleListModel.h"

@interface PriceCustomizationView()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet NMRangeSlider *rungeSlider;
@property (weak, nonatomic) IBOutlet NMRangeSlider *priceSlider;
@property (weak, nonatomic) IBOutlet NMRangeSlider *couponSlider;
@property (weak, nonatomic) IBOutlet UILabel *rungeLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rungeRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponRightLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;

@end

@implementation PriceCustomizationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    if(kkDeviceHeight<549){
        _bgScrollView.frame=CGRectMake(0, 20, kkDeviceWidth, kkDeviceHeight-20);
        _bgScrollView.contentSize=CGSizeMake(kkDeviceWidth, 549);
    }else{
        _bgScrollView.frame=CGRectMake(0,kkDeviceHeight-549, kkDeviceWidth, 549);
    }
    _rungeSlider.frame=CGRectMake(30, 60, kkDeviceWidth-60, 36);
    _priceSlider.frame=CGRectMake(30, 60, kkDeviceWidth-60, 36);
    _couponSlider.frame=CGRectMake(30, 60, kkDeviceWidth-60, 36);
    
    UIImage *image=[UIImage imageNamed:@"gary_move_sample.png"];
    _rungeSlider.trackBackgroundImage=image;
    _priceSlider.trackBackgroundImage=image;
    _couponSlider.trackBackgroundImage=image;
    
    image=[UIImage imageNamed:@"red_move_sample.png"];
    _rungeSlider.trackImage=image;
    _priceSlider.trackImage=image;
    _couponSlider.trackImage=image;
    
    image=[UIImage imageNamed:@"move_bulk_sample.png"];
    _rungeSlider.lowerHandleImageNormal=image;
    _rungeSlider.upperHandleImageNormal=image;
    _rungeSlider.lowerHandleImageHighlighted=image;
    _rungeSlider.upperHandleImageHighlighted=image;
    
    _priceSlider.lowerHandleImageNormal=image;
    _priceSlider.upperHandleImageNormal=image;
    _priceSlider.lowerHandleImageHighlighted=image;
    _priceSlider.upperHandleImageHighlighted=image;
    
    _couponSlider.lowerHandleImageNormal=image;
    _couponSlider.upperHandleImageNormal=image;
    _couponSlider.lowerHandleImageHighlighted=image;
    _couponSlider.upperHandleImageHighlighted=image;
    
    _rungeSlider.minimumValue=0;
    _rungeSlider.maximumValue=1;
    
    _priceSlider.minimumValue=0;
    _priceSlider.maximumValue=1;
    
    _couponSlider.minimumValue=0;
    _couponSlider.maximumValue=1;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBgView)];
    tap.delegate=self;
    [self addGestureRecognizer:tap];
}
- (void)tapBgView
{
    self.hidden=YES;
}
- (IBAction)rungeSlider:(id)sender {
    _rungeLeftLabel.text=[NSString stringWithFormat:@"￥%d",(int)(_rungeSlider.lowerValue*10000)];
    _rungeRightLabel.text=[NSString stringWithFormat:@"￥%d",(int)(_rungeSlider.upperValue*10000)];
    if(_rungeSlider.upperValue==1){
        _rungeRightLabel.text=@"￥10000+";
    }
}
- (IBAction)priceSlider:(id)sender {
    _priceLeftLabel.text=[NSString stringWithFormat:@"￥%d",(int)(_priceSlider.lowerValue*20000)];
    _priceRightLabel.text=[NSString stringWithFormat:@"￥%d",(int)(_priceSlider.upperValue*20000)];
    if(_priceSlider.upperValue==1){
        _priceRightLabel.text=@"￥20000+";
    }
}
- (IBAction)couponSlider:(id)sender {
    _couponLeftLabel.text=[NSString stringWithFormat:@"%d%%",(int)((1-_couponSlider.lowerValue)*100)];
    _couponRightLabel.text=[NSString stringWithFormat:@"%d%%",(int)((1-_couponSlider.upperValue)*100)];
}
//TODO:点击筛选
- (IBAction)screenBtnClick:(id)sender {
    
    if(_delegate && [_delegate respondsToSelector:@selector(priceCustomizationWithModel:)]){
        GetSampleListModel *model=[[GetSampleListModel alloc]init];
        model.NPriceL=[_rungeLeftLabel.text substringFromIndex:1];
        if(_rungeSlider.upperValue==1){
            model.NPriceH=@"990000";
        }else{
            model.NPriceH=[_rungeRightLabel.text substringFromIndex:1];
        }
        model.AveragePriceL=[_priceLeftLabel.text substringFromIndex:1];
        if(_priceSlider.upperValue==1){
            model.AveragePriceH=@"990000";
        }else{
            model.AveragePriceH=[_priceRightLabel.text substringFromIndex:1];
        }
        model.PerCouponH=[_couponLeftLabel.text substringToIndex:_couponLeftLabel.text.length-1];
        model.PerCouponL=[_couponRightLabel.text substringToIndex:_couponRightLabel.text.length-1];
        
        [_delegate priceCustomizationWithModel:model];
        
        [self tapBgView];
    }
}
//TODO:点击取消
- (IBAction)cancelBtnClick:(id)sender {
    [self tapBgView];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(![touch.view isKindOfClass:[PriceCustomizationView class]]){
        return NO;
    }
    return YES;
}
@end
