//
//  ChooseDateView.m
//  MopinProject
//
//  Created by rt008 on 15/12/3.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "ChooseDateView.h"


@interface ChooseDateView()
{
    NSDateFormatter *_dateFormater;
    UIDatePicker *_datePicker;
    NSInteger _type;
    UIButton *_sureBtn;
}
@end

@implementation ChooseDateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self=[super initWithFrame:frame];
//    if(self){
//        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//        [self createUI];
//    }
//    return self;
//}
- (instancetype)initViewWithType:(NSInteger)type
{
    self=[super init];
    if(self){
        self.frame=CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight);
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self createUIWithType:type];
    }
    return self;
}
- (void)createUIWithType:(NSInteger)type
{
    _type=type;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBgView)];
    [self addGestureRecognizer:tap];
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(30, (kkDeviceHeight-230)/2, kkDeviceWidth-60, 230)];
    bgView.backgroundColor=[UIColor whiteColor];
    bgView.layer.cornerRadius=3;
    bgView.layer.masksToBounds=YES;
    
    UIImageView *lineImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 44, CGRectGetWidth(bgView.frame), 0.5)];
    lineImage.image=[UIImage imageNamed:@"line_sample.png"];
    
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bgView.frame), 45)];
    titleLabel.textAlignment=NSTextAlignmentCenter;

    titleLabel.font=[UIFont systemFontOfSize:15];
    titleLabel.backgroundColor=[UIColor whiteColor];
    [bgView addSubview:titleLabel];
    
    _datePicker=[[UIDatePicker alloc]init];
    _datePicker.frame=CGRectMake(0,35, CGRectGetWidth(bgView.frame), 162);
    _datePicker.datePickerMode=UIDatePickerModeDate;
    _datePicker.timeZone=[NSTimeZone localTimeZone];
    if(type==1){
        _datePicker.minimumDate=[NSDate date];
        titleLabel.text=@"有效期截止至";
    }else{
        _datePicker.maximumDate=[NSDate date];
        titleLabel.text=@"出生日期";
    }
    
    [bgView addSubview:_datePicker];
    [bgView addSubview:lineImage];
    [self addSubview:bgView];
    
    NSArray *titleArr=@[@"取消",@"确定"];
    for(int i=0;i<2;i++){
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(((CGRectGetWidth(bgView.frame)-1)/2+1)*i, 185, (CGRectGetWidth(bgView.frame)-1)/2, 45);
        button.backgroundColor=[UIColor whiteColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:15];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [bgView addSubview:button];
        button.tag=100+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        if(i==1){
            _sureBtn=button;
        }
    }
    UIImageView *lineImage2=[[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(bgView.frame)-1)/2, 185, 0.5, 45)];
    lineImage2.image=[UIImage imageNamed:@"line_sample.png"];
    [bgView addSubview:lineImage2];
    
    UIImageView *lineImage3=[[UIImageView alloc]initWithFrame:CGRectMake(0, 185, CGRectGetWidth(bgView.frame), 0.5)];
    lineImage3.image=[UIImage imageNamed:@"line_sample.png"];
    [bgView addSubview:lineImage3];
}
- (void)tapBgView
{
    self.hidden=YES;
}
- (void)buttonClick:(UIButton *)button
{
    if(button.tag==100){
        [self tapBgView];
    }else{
        if(!_dateFormater){
            _dateFormater=[[NSDateFormatter alloc]init];
            _dateFormater.dateFormat=@"yyyy-MM-dd";
        }
        if(_delegate && [_delegate respondsToSelector:@selector(chooseDate:)]){
            if(_type==1){
                [_delegate chooseDate:[_dateFormater stringFromDate:_datePicker.date]];
                [self tapBgView];
            }else{
                
                [self saveUserBirthday];
            }
        }
    }
}
- (void)saveUserBirthday
{
    [SVProgressHUD show];
    PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"SaveUserBirthday" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:personalModel.UserID forKey:@"UserID"];
    [parameterDic setValue:[_dateFormater stringFromDate:_datePicker.date] forKey:@"Birthday"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        _sureBtn.userInteractionEnabled=YES;
        if (code.integerValue == 1000) {
            personalModel.Birthday=[_dateFormater stringFromDate:_datePicker.date];
            NSMutableDictionary *infoDic=[NSMutableDictionary dictionaryWithDictionary:[mUserDefaults objectForKey:@"PersonalInfo"]];
            [infoDic setValue:personalModel.Birthday forKey:@"Birthday"];
            [mUserDefaults setValue:infoDic forKey:@"PersonalInfo"];
            [mUserDefaults synchronize];
            
            [_delegate chooseDate:[_dateFormater stringFromDate:_datePicker.date]];
            [self tapBgView];
        }
    } failure:^(NSError *error){
        _sureBtn.userInteractionEnabled=YES;
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}
- (void)dealloc
{
    [self removeFromSuperview];
}
@end
