//
//  SelectedSexView.m
//  MopinProject
//
//  Created by rt008 on 15/12/7.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "SelectedSexView.h"

@interface SelectedSexView()
{
    UIView *_bgView;
    PersonalInfoSingleModel *_personalModel;
}
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;
@end

@implementation SelectedSexView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    _bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight)];
    _bgView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [_bgView addSubview:self];
    self.frame=CGRectMake(30, (kkDeviceHeight-140)/2, kkDeviceWidth-60, 140);
    [WINDOW addSubview:_bgView];
    _personalModel=[PersonalInfoSingleModel shareInstance];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBgView)];
    [_bgView addGestureRecognizer:tap];
    
    if(_personalModel.Sex.intValue!=0){
        if(_personalModel.Sex.intValue==1){
            _maleBtn.selected=YES;
        }else{
            _femaleBtn.selected=YES;
        }
    }
}
- (void)setHidden:(BOOL)hidden
{
    _bgView.hidden=NO;
    if(_personalModel.Sex!=0){
        if(_personalModel.Sex.intValue==1){
            _maleBtn.selected=YES;
            _femaleBtn.selected=NO;
        }else{
            _femaleBtn.selected=YES;
            _maleBtn.selected=NO;
        }
    }else{
        _maleBtn.selected=NO;
        _femaleBtn.selected=NO;
    }
}
//TODO:点击背景
- (void)tapBgView
{
    _bgView.hidden=YES;
}
- (IBAction)sureBtnClick:(id)sender {
    if(!_maleBtn.selected && !_femaleBtn.selected){
        [SVProgressHUD showErrorWithStatus:@"请选择性别"];
        return;
    }
    
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"SaveUserSex" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_personalModel.UserID forKey:@"UserID"];
    [parameterDic setValue:[NSString stringWithFormat:@"%d",_maleBtn.selected==1?1:2] forKey:@"Sex"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000) {
            
            if(_delegate && [_delegate respondsToSelector:@selector(selectedSex)]){
                _personalModel.Sex=[NSString stringWithFormat:@"%d",_maleBtn.selected==1?1:2];
                NSMutableDictionary *infoDic=[NSMutableDictionary dictionaryWithDictionary:[mUserDefaults objectForKey:@"PersonalInfo"]];
                [infoDic setValue:_personalModel.Sex forKey:@"Sex"];
                [mUserDefaults setValue:infoDic forKey:@"PersonalInfo"];
                [mUserDefaults synchronize];
                
                [_delegate selectedSex];
            }
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
    
    [self tapBgView];
}
- (IBAction)cancelBtnClick:(id)sender {
    [self tapBgView];
}
- (IBAction)femaleBtnClick:(id)sender {
    _femaleBtn.selected=YES;
    _maleBtn.selected=NO;
}
- (IBAction)maleBtnClick:(id)sender {
    _femaleBtn.selected=NO;
    _maleBtn.selected=YES;
}
- (void)dealloc{
    [_bgView removeFromSuperview];
    _bgView=nil;
    
}
@end
