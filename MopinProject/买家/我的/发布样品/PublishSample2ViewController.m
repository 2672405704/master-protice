//
//  PublishSample2ViewController.m
//  MopinProject
//
//  Created by rt008 on 15/11/30.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "PublishSample2ViewController.h"
#import "MineListCell.h"
#import "SampleAttributeModel.h"
#import "PublishSampleModel.h"
#import "PublishSample3ViewController.h"

@interface PublishSample2ViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIScrollView *_bgScrollView;
    UIView *_bgView;
    UILabel *_tipLbael;
    MineListCell *_timeView;
    
    NSInteger _selectedMaterialIndex; //选择字体的下标
    UIView *_chooseTimeBgView;
    
    NSArray *_timeArr;
    NSInteger _selectedTimeIndex;
}
@end

@implementation PublishSample2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"发布样品";
    [self setNavBackBtnWithType:1];
    _selectedMaterialIndex=-1;
    
    [self createScrollView];
}
//TODO:创建scrollView
- (void)createScrollView
{
    _bgScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-mTabBarHeight)];
    [self.view addSubview:_bgScrollView];
    
    NSArray *titleArr=@[@"请选择材料",@"创作周期"];
    for(int i=0;i<2;i++){
        UILabel *tipLabel=[[UILabel alloc]initWithFrame:CGRectMake(30,50*i, kkDeviceWidth-60, 50)];
        tipLabel.text=titleArr[i];
        tipLabel.font=[UIFont fontWithName:XiaoBiaoSong size:15];
        [_bgScrollView addSubview:tipLabel];
        if(i==1){
            _tipLbael=tipLabel;
        }
    }

    _bgView=[[UIView alloc]initWithFrame:CGRectMake(0,50, kkDeviceWidth, 1)];
    _bgView.backgroundColor=[UIColor whiteColor];
    [_bgScrollView addSubview:_bgView];
    
    UIButton *boomBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    boomBtn.frame=CGRectMake(0, kkDeviceHeight-mTabBarHeight-mNavBarHeight, kkDeviceWidth,mTabBarHeight);
    boomBtn.titleLabel.font=[UIFont fontWithName:XiaoBiaoSong size:18];
    [boomBtn setBackgroundImage:[UIImage imageNamed:@"red_button_apply.png"] forState:UIControlStateNormal];
    [boomBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.view addSubview:boomBtn];
    
    [boomBtn addTarget:self action:@selector(nextStepClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self createButton];
}
//TODO:创建点击的按钮
- (void)createButton
{
    NSArray *fontArr=_publishModel.attributeDic[@"5"];
    _timeArr=_publishModel.attributeDic[@"6"];
//    CGFloat space=(kkDeviceWidth-60-130*2);
    CGFloat width=(kkDeviceWidth-60-10)/2;
    for(int i=0;i<fontArr.count;i++){
        SampleAttributeModel *model=fontArr[i];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(30+(width+10)*(i%2), 23+(i/2)*(35+15),width, 35);
        [button setTitle:model.AttributeName forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"select_gary_sample.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"select_red_sample.png"] forState:UIControlStateSelected];
        button.titleLabel.font=[UIFont systemFontOfSize:15];
        button.tag=100+i;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_bgView addSubview:button];
        
        [button addTarget:self action:@selector(chooseMaterial:) forControlEvents:UIControlEventTouchUpInside];
    }
    CGRect frame=_bgView.frame;
    frame.size.height=23*2+((fontArr.count-1)/2)*(35+15)+35;
    _bgView.frame=frame;
    
    
    frame=_tipLbael.frame;
    frame.origin.y=CGRectGetMaxY(_bgView.frame);
    _tipLbael.frame=frame;
    
    _timeView=[[[NSBundle mainBundle] loadNibNamed:@"MineListCell" owner:self options:nil]firstObject];
    _timeView.frame=CGRectMake(0, CGRectGetMaxY(_tipLbael.frame), kkDeviceWidth, 45);
    _timeView.backgroundColor=[UIColor whiteColor];
    _timeView.titleLabel.text=@"请选择创作周期";
    _timeView.titleLabel.frame=CGRectMake(30, 0, kkDeviceWidth-80, 45);
    [_bgScrollView addSubview:_timeView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTime)];
    [_timeView addGestureRecognizer:tap];
    
    _bgScrollView.contentSize=CGSizeMake(kkDeviceWidth, CGRectGetMaxY(_timeView.frame));
    
    if(_publishModel.ArtID.length!=0){
        [self createModel];
    }
}
//TODO:初始化
- (void)createModel
{
    NSArray *tempArr=_publishModel.attributeDic[@"5"];
    for(SampleAttributeModel *model in tempArr){
        if([_publishModel.MaterialCodeModel.AttributeCode isEqualToString:model.AttributeCode]){
            _publishModel.MaterialCodeModel.AttributeName=model.AttributeName;
            
            [self chooseMaterial:(UIButton *)[_bgView viewWithTag:100+[tempArr indexOfObject:model]]];
            break;
        }
    }
    
    tempArr=_publishModel.attributeDic[@"6"];
    for(SampleAttributeModel *model in tempArr){
        if([_publishModel.DeliveryTimeCodeModel.AttributeCode isEqualToString:model.AttributeCode]){
            _publishModel.DeliveryTimeCodeModel.AttributeName=model.AttributeName;
            
            _selectedTimeIndex=[tempArr indexOfObject:model];
            _timeView.titleLabel.text=[_timeArr[_selectedTimeIndex] AttributeName];
            break;
        }
    }
}
//TODO:选择时间
- (void)chooseTime
{
    if(!_chooseTimeBgView){
        _chooseTimeBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight)];
        _chooseTimeBgView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [WINDOW addSubview:_chooseTimeBgView];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBgView)];
        [_chooseTimeBgView addGestureRecognizer:tap];
        
        UIPickerView *pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, kkDeviceHeight-162, kkDeviceWidth,162)];
        pickerView.backgroundColor=[UIColor whiteColor];
        pickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        pickerView.delegate=self;
        pickerView.dataSource=self;
        [_chooseTimeBgView addSubview:pickerView];
        
        UIView *buttonBgView=[[UIView alloc]initWithFrame:CGRectMake(0, kkDeviceHeight-162-44, kkDeviceWidth, 44)];
        buttonBgView.backgroundColor=toPCcolor(@"eeeeee");
        [_chooseTimeBgView addSubview:buttonBgView];
        
        NSArray *titleArr=@[@"取消",@"确定"];
        for(int i=0;i<2;i++){
            UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            leftBtn.titleLabel.font=[UIFont systemFontOfSize:15];
            [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            leftBtn.frame=CGRectMake(0+(kkDeviceWidth-100)*i, 0, 100, 44);
            [leftBtn setTitle:titleArr[i] forState:UIControlStateNormal];
            [buttonBgView addSubview:leftBtn];
            leftBtn.tag=100+i;
            [leftBtn addTarget:self action:@selector(chooseTimeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }else{
        _chooseTimeBgView.hidden=NO;
    }
}
//TODO:点击背景
- (void)tapBgView
{
    _chooseTimeBgView.hidden=YES;
}
//TODO:点击取消和确定
- (void)chooseTimeBtnClick:(UIButton *)btn
{
    if(_timeArr.count==0){
        return;
    }
    if(btn.tag==100){
        [self tapBgView];
    }else{
        _publishModel.DeliveryTimeCodeModel=_timeArr[_selectedTimeIndex];
        _timeView.titleLabel.text=[_timeArr[_selectedTimeIndex] AttributeName];
        [self tapBgView];
    }
}
//TODO:选择材料
- (void)chooseMaterial:(UIButton *)button
{
    if(_selectedMaterialIndex==button.tag-100){
        return;
    }
    if(_selectedMaterialIndex!=-1){
        UIButton *selectedButton=(UIButton *)[self.view viewWithTag:100+_selectedMaterialIndex];
        selectedButton.selected=NO;
    }
    button.selected=YES;
    _selectedMaterialIndex=button.tag-100;
}
//TODO:点击下一步
- (void)nextStepClick
{
    if(_selectedMaterialIndex==-1){
        [SVProgressHUD showErrorWithStatus:@"请选择材料"];
        return;
    }
    if(_publishModel.DeliveryTimeCodeModel.AttributeCode.length==0){
        [SVProgressHUD showErrorWithStatus:@"请选择提交软片时间"];
        return;
    }
    NSArray *materialArr=_publishModel.attributeDic[@"5"];
    _publishModel.MaterialCodeModel=materialArr[_selectedMaterialIndex];
    
    PublishSample3ViewController *psvc3=[[PublishSample3ViewController alloc]initWithNibName:@"PublishSample3ViewController" bundle:nil];
    psvc3.publishModel=_publishModel;
    [self.navigationController pushViewController:psvc3 animated:YES];
}
#pragma mark - pickerView delegate
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _timeArr.count;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0f;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return kkDeviceWidth;
}
//设置返回的标题的属性
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0,0,kkDeviceWidth,40)];
    label.textColor = [UIColor blackColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.font = [UIFont systemFontOfSize:15];
    SampleAttributeModel *model=_timeArr[row];
    label.text=model.AttributeName;
    return label;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectedTimeIndex=row;
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
