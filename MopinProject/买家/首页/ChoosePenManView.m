//
//  ChoosePenManView.m
//  MopinProject
//
//  Created by rt008 on 15/12/7.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "ChoosePenManView.h"
#import "CityModel.h"
#import "AddressDataCenter.h"

@interface ChoosePenManView()<UIPickerViewDataSource,UIPickerViewDelegate,UIGestureRecognizerDelegate>
{
    NSInteger _selectedIndex;
    AddressDataCenter *_addressDC;
    NSMutableArray *_provinceArr;
    NSArray *_cityArr;
    NSArray *_districtArr;
    
    NSInteger _selectedCity;
    NSInteger _selectedProvince;
//    NSInteger _selectedDistrict;
    
    CityModel *_allCityModel;
}
@property (weak, nonatomic) IBOutlet UIView *buttonBgView;
@property (weak, nonatomic) IBOutlet UIView *picekerbgView;
@end
@implementation ChoosePenManView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    _selectedIndex=-1;
    _addressDC=[AddressDataCenter sharedInstance];
    self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.frame=CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight);
    _addressDC=[AddressDataCenter sharedInstance];
    _provinceArr =[NSMutableArray arrayWithArray:[_addressDC getProvince]];
    CityModel *model=[[CityModel alloc]init];
    model.Id=@"0";
    model.Name=@"全部";
    [_provinceArr insertObject:model atIndex:0];
    
    _allCityModel=[[CityModel alloc]init];
    _allCityModel.Id=@"0";
    _allCityModel.Name=@"全部";
    _cityArr=@[_allCityModel];
//    _cityArr=[_addressDC getCity:@"110000"];
//    _districtArr=[_addressDC getDistrictid:@"110100"];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBgView)];
    tap.delegate=self;
    [self addGestureRecognizer:tap];
    
    UIPickerView *pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth,162)];
    pickerView.backgroundColor=[UIColor whiteColor];
    pickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    pickerView.delegate=self;
    pickerView.dataSource=self;
    [_picekerbgView addSubview:pickerView];
    
    
    NSArray *titleArr=nil;
    CGFloat width;
    
    /*公益开关*/
    BOOL isPublicOn = [[[PublicWelfareManager shareInstance]getPublicWelfareState]isEqualToString:@"1"];
    if(isPublicOn)
    {
        titleArr=@[@"大家",@"名家",@"书家",@"签约",@"公益书家"];
        width=(kkDeviceWidth-60-10*2)/3;
    }else
    {
       titleArr=@[@"大家",@"名家",@"书家",@"签约"];
       width=(kkDeviceWidth-60-10*3)/4;
    }

    
    for(int i=0;i<titleArr.count;i++){
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame=isPublicOn? CGRectMake(30+(width+10)*(i<3?i:(i-3)),i<3?15:55, width, 30) : CGRectMake(30+(width+10)*i, 31, width, 30);
        
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:15];
        
        if(i==3||i==4){ //签约||公益
            
            [button setTitleColor:toPCcolor(@"ca3b2b") forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"red_line_home.png"] forState:UIControlStateNormal];
            
        }else{ //其他
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"gray_border_home.png"] forState:UIControlStateNormal];
        }
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"red_border_home.png"] forState:UIControlStateSelected];
        button.tag=100+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonBgView addSubview:button];
    }
}
- (void)tapBgView
{
    self.hidden=YES;
}
//- (void)setHidden:(BOOL)hidden
//{
//    _selectedCity=0;
//    _selectedDistrict=0;
//    _selectedProvince=0;
//}

//TODO:点击书家分类
- (void)buttonClick:(UIButton *)button
{
    if(_selectedIndex==button.tag-100){
        return;
    }
    if(_selectedIndex!=-1){
        UIButton *_selectedButton=(UIButton *)[_buttonBgView viewWithTag:_selectedIndex+100];
        _selectedButton.selected=NO;
    }
    _selectedIndex=button.tag-100;
    button.selected=YES;
}
//TODO:取消
- (IBAction)cancelBtnClick:(id)sender {
    [self tapBgView];
}
//TODO:确定
- (IBAction)sureBtnClick:(id)sender {
    
    if(_selectedIndex==-1){
        [SVProgressHUD showErrorWithStatus:@"请选择书家"];
        return;
    }
    CityModel *cityModel=_cityArr[_selectedCity];
    CityModel *proviceModel=_provinceArr[_selectedProvince];
    
//    CityModel *districtModel=_districtArr[_selectedDistrict];
    
    if(_delegate && [_delegate respondsToSelector:@selector(choosePenView:andCityId:andPenmanType:)]){
        [_delegate choosePenView:proviceModel.Id andCityId:cityModel.Id andPenmanType:[NSString stringWithFormat:@"%@",@(_selectedIndex+1)]];
    }
    [self tapBgView];
}
#pragma mark - pickerView delegate
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component==0){
        return _provinceArr.count;
    }
        return _cityArr.count;
//    }
//    return _districtArr.count;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0f;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return kkDeviceWidth/2;
}
//设置返回的标题的属性
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0,0,kkDeviceWidth/2,40)];
    label.textColor = [UIColor blackColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.font = [UIFont systemFontOfSize:15];
    CityModel *model;
    if(component==0){
        model=_provinceArr[row];
        if(row==_selectedProvince){
            label.textColor=toPCcolor(@"ca3b2b");
        }
    }else if(component==1){
        model=_cityArr[row];
        if(row==_selectedCity){
            label.textColor=toPCcolor(@"ca3b2b");
        }
    }
//    }else{
//        model=_districtArr[row];
//    }
    label.text=model.Name;
    return label;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component==0){
        if(row==0){
            _cityArr=@[_allCityModel];
        }else{
            CityModel *model=_provinceArr[row];
            _cityArr=[_addressDC getCity:model.Id];
        }
        
//        CityModel *subModel=_cityArr[0];
//        _districtArr=[_addressDC getDistrictid:subModel.Id];
        
        [pickerView selectRow:0 inComponent:1 animated:NO];
    
        [pickerView reloadComponent:1];

        _selectedCity=0;
        _selectedProvince=row;
    }else if(component==1){
//        CityModel *model=_cityArr[row];
//        _selectedDistrict=0;
        _selectedCity=row;
//        _districtArr=[_addressDC getDistrictid:model.Id];
//        [pickerView selectRow:0 inComponent:2 animated:NO];
//        [pickerView reloadComponent:2];
    }
    [pickerView reloadAllComponents];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(![touch.view isKindOfClass:[ChoosePenManView class]]){
        return NO;
    }
    return YES;
}
@end
