//
//  PublishSample3ViewController.m
//
//
//  Created by rt008 on 15/11/30.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "PublishSample3ViewController.h"
#import "CustomSlider.h"
#import "PublishSampleModel.h"
#import "RecommendContentModel.h"
#import "ShowSampleViewController.h"

@interface PublishSample3ViewController ()<UITextFieldDelegate>
{
    UISlider *_slider1;
    UISlider *_slider2;
}
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UIView *chooseBgView1;
@property (weak, nonatomic) IBOutlet UIView *chooseBgView2;
@property (weak, nonatomic) IBOutlet UITextField *fundPriceTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet UILabel *percent1Label;  //第一个百分比Label
@property (weak, nonatomic) IBOutlet UILabel *percent2Label;    //第二个百分比Label
@end

@implementation PublishSample3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"发布样品";
    [self setNavBackBtnWithType:1];
    
    _bgScrollView.contentSize=CGSizeMake(kkDeviceWidth, 530);

    [self createSlider];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordHide) name:UIKeyboardWillHideNotification object:nil];
    
    _priceTextField.inputAccessoryView=self.keyBordtoolBar;
    _fundPriceTextField.inputAccessoryView=self.keyBordtoolBar;
}
//TODO:键盘隐藏
- (void)keybordHide
{
    [UIView animateWithDuration:0.3 animations:^{
        _bgScrollView.frame=CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-mTabBarHeight);
    }];
}
//TODO:键盘显示
- (void)keybordShow:(NSNotification *)notification
{
    //获取键盘高度
    NSDictionary *info=[notification userInfo];
    CGFloat kbHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //获取输入框相对位置
    //    CGFloat y=rect.origin.y-(kkDeviceHeight-105-kbHeight-mNavBarHeight);
    //    if(y<=0){
    //        return;
    //    }
    if([_fundPriceTextField isFirstResponder]){
        [_bgScrollView scrollRectToVisible:CGRectMake(0,667-kkDeviceHeight-24, GETVIEWWIDTH(_bgScrollView), GETVIEWHEIGHT(_bgScrollView)) animated:NO];
        [UIView animateWithDuration:0.3 animations:^{
            _bgScrollView.frame=CGRectMake(0,mNavBarHeight-kbHeight-10, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-mTabBarHeight);
        }];
    }
}
- (IBAction)submitBtnClick:(id)sender {
    if(_priceTextField.text.intValue==0){
        [SVProgressHUD showErrorWithStatus:@"请填样品定制价格"];
        return;
    }
    if(_fundPriceTextField.text.length!=0){
        if(_fundPriceTextField.text.intValue==0){
            [SVProgressHUD showErrorWithStatus:@"返券金额不能为0"];
            return;
        }
    }
    NSString *percent1=[_percent1Label.text substringWithRange:NSMakeRange(0, _percent1Label.text.length-1)];
    NSString *percent2=[_percent2Label.text substringWithRange:NSMakeRange(0, _percent2Label.text.length-1)];
    if(percent1.intValue+percent2.intValue>100){
        [SVProgressHUD showErrorWithStatus:@"墨品券比例和书家全比例不能超过100%"];
        return;
    }
    _publishModel.Price=_priceTextField.text;
    _publishModel.MPCouponPer=percent1;
    _publishModel.WCouponPer=percent2;
    _publishModel.RWCoupon=_fundPriceTextField.text;
    
    ShowSampleViewController *ssvc=[[ShowSampleViewController alloc]initWithNibName:@"ShowSampleViewController" bundle:nil];
    ssvc.publishModel=_publishModel;
    [self.navigationController pushViewController:ssvc animated:YES];
}
- (void)createSlider
{
    for(int i=0;i<2;i++){
        CustomSlider *slider=[[CustomSlider alloc]initWithFrame:CGRectMake(30, 60+18, kkDeviceWidth-60, 36)];
        slider.minimumValue=0;
        slider.maximumValue=0.8;
        [slider setThumbImage:[UIImage imageNamed:@"move_bulk_sample.png"] forState:UIControlStateNormal];
        [slider setThumbImage:[UIImage imageNamed:@"move_bulk_sample.png"] forState:UIControlStateHighlighted];
        [slider setMinimumTrackImage:[UIImage imageNamed:@"red_move_sample.png"] forState:UIControlStateNormal];
        [slider setMaximumTrackImage:[UIImage imageNamed:@"gary_move_sample.png"] forState:UIControlStateNormal];
        if(i==0){
            _slider1=slider;
            [_chooseBgView1 addSubview:slider];
        }else{
            _slider2=slider;
            [_chooseBgView2 addSubview:slider];
        }
        [slider addTarget:self action:@selector(sliderClick:) forControlEvents:UIControlEventValueChanged];
    }
    
    if(_publishModel.ArtID.length!=0){
        _priceTextField.text=_publishModel.Price;
        _fundPriceTextField.text=_publishModel.RWCoupon;
        
        _percent1Label.text=[NSString stringWithFormat:@"%@%%",_publishModel.MPCouponPer];
        _percent2Label.text=[NSString stringWithFormat:@"%@%%",_publishModel.WCouponPer];
        
        [_slider1 setValue:(_publishModel.MPCouponPer.intValue-20)/100.0 animated:YES];
        [_slider2 setValue:(_publishModel.WCouponPer.intValue)/100.0 animated:YES];
    }
}
//TODO:滑动
- (void)sliderClick:(UISlider *)slider
{
    if(slider==_slider1){
        _percent1Label.text=[NSString stringWithFormat:@"%d%%",(int)(((slider.value+0.2)/1)*100)];
    }else{
        _percent2Label.text=[NSString stringWithFormat:@"%d%%",(int)((slider.value/1)*100)];
    }
}
#pragma mark textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
