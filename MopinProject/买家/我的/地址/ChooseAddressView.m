//
//  ChooseAddressView.m
//  MopinProject
//
//  Created by rt008 on 15/11/26.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "ChooseAddressView.h"
#import "AddressDataCenter.h"
#import "CityModel.h"

@interface ChooseAddressView()<UIPickerViewDataSource,UIPickerViewDelegate,UIGestureRecognizerDelegate>
{
    NSArray *_provinceArr;
    NSArray *_cityArr;
    NSArray *_districtArr;
    
    NSInteger _selectedCity;
    NSInteger _selectedProvince;
    NSInteger _selectedDistrict;
    AddressDataCenter *_addressDC;
    UIPickerView *_pickerView;
}
@end

@implementation ChooseAddressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame andProvince:(NSString *)province andCity:(NSString *)city andDistrict:(NSString *)district
{
    self=[super initWithFrame:frame];
    if(self){
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _addressDC=[AddressDataCenter sharedInstance];
        
        _provinceArr =[_addressDC getProvince];
        if(province.length==0){
            _cityArr=[_addressDC getCity:@"110000"];
            _districtArr=[_addressDC getDistrictid:@"110100"];
        }else{
            _cityArr=[_addressDC getCity:province];
            _districtArr=[_addressDC getDistrictid:city];
            
            for(CityModel *model in _provinceArr){
                if([model.Id isEqualToString:province]){
                    _selectedProvince=[_provinceArr indexOfObject:model];
                    break;
                }
            }
            for(CityModel *model in _cityArr){
                if([model.Id isEqualToString:city]){
                    _selectedCity=[_cityArr indexOfObject:model];
                    break;
                }
            }
            for(CityModel *model in _districtArr){
                if([model.Id isEqualToString:district]){
                    _selectedDistrict=[_districtArr indexOfObject:model];
                    break;
                }
            }
        }
        
        
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBgView)];
        tap.delegate=self;
        [self addGestureRecognizer:tap];
        
        _pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, kkDeviceHeight-162, kkDeviceWidth,162)];
        _pickerView.backgroundColor=[UIColor whiteColor];
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _pickerView.delegate=self;
        _pickerView.dataSource=self;
        [self addSubview:_pickerView];
        
        [_pickerView selectRow:_selectedProvince inComponent:0 animated:NO];
        [_pickerView selectRow:_selectedCity inComponent:1 animated:NO];
        [_pickerView selectRow:_selectedDistrict inComponent:2 animated:NO];
        [_pickerView reloadAllComponents];
        
        
        UIView *buttonBgView=[[UIView alloc]initWithFrame:CGRectMake(0, kkDeviceHeight-162-44, kkDeviceWidth, 44)];
        buttonBgView.backgroundColor=toPCcolor(@"eeeeee");
        [self addSubview:buttonBgView];
        
        NSArray *titleArr=@[@"取消",@"确定"];
        for(int i=0;i<2;i++){
            UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            leftBtn.titleLabel.font=[UIFont systemFontOfSize:15];
            [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            leftBtn.frame=CGRectMake(0+(kkDeviceWidth-100)*i, 0, 100, 44);
            [leftBtn setTitle:titleArr[i] forState:UIControlStateNormal];
            [buttonBgView addSubview:leftBtn];
            leftBtn.tag=100+i;
            [leftBtn addTarget:self action:@selector(chooseCityClick:) forControlEvents:UIControlEventTouchUpInside];
        }

    }
    return self;
}
- (void)releaseCount
{
    _selectedCity=0;
    _selectedDistrict=0;
    _selectedProvince=0;
}
- (void)tapBgView
{
    self.hidden=YES;
}
//TODO:选择城市
- (void)chooseCityClick:(UIButton *)button
{
    if(button.tag==100){
        [self tapBgView];
    }else{
        CityModel *cityModel=_cityArr[_selectedCity];
        CityModel *proviceModel=_provinceArr[_selectedProvince];
        CityModel *districtModel;
        if(_districtArr.count==0){
            districtModel=[[CityModel alloc]init];
            districtModel.Name=@"";
            districtModel.Id=@"0";
        }else{
            districtModel=_districtArr[_selectedDistrict];
        }
        
        if(_delegate && [_delegate respondsToSelector:@selector(chooseAddressIdWithArray:)]){
            [_delegate chooseAddressIdWithArray:@[proviceModel,cityModel,districtModel]];
        }
        [self tapBgView];
    }
}
////获取省份
//-(NSArray *)getProvince
//{
//    NSString *sql=[NSString stringWithFormat:@"select * from base_province"];
//    FMResultSet *resultSet=[_database executeQuery:sql];
//    NSMutableArray *array=[NSMutableArray array];
//    while ([resultSet next]) {
//        CityModel *model=[[CityModel alloc]init];
//        model.Id=[resultSet stringForColumn:@"provinceid"];
//        model.Name=[resultSet stringForColumn:@"provincename"];
//        [array addObject:model];
//    }
//    return array;
//    
//}
//
//-(NSString *)getProvinceidByCityName:(NSString *)cityName
//{
//    NSString *sql=[NSString stringWithFormat:@"select * from base_city where cityname=?"];
//    FMResultSet *resultSet=[_database executeQuery:sql,cityName];
//    NSString *provinceid;
//    while ([resultSet next]) {
//        provinceid=[resultSet stringForColumn:@"provinceid"];
//        break;
//    }
//    return provinceid;
//}
//用省份的id获取城市
//-(NSArray *)getCity:(NSString *)provinceid
//{
//    NSString *sql=[NSString stringWithFormat:@"select * from base_city where provinceid=%@",provinceid];
//    FMResultSet *resultSet=[_database executeQuery:sql];
//    NSMutableArray *array=[NSMutableArray array];
//    while ([resultSet next]) {
//        CityModel *model=[[CityModel alloc]init];
//        model.Id=[resultSet stringForColumn:@"cityid"];
//        model.Name=[resultSet stringForColumn:@"cityname"];
//        
//        [array addObject:model];
//    }
//    return array;
//}
//TODO:用城市ID获取区
//-(NSArray *)getDistrictid:(NSString *)cityId
//{
//    NSString *sql=[NSString stringWithFormat:@"select * from base_district where cityid=%@",cityId];
//    FMResultSet *resultSet=[_database executeQuery:sql];
//    NSMutableArray *array=[NSMutableArray array];
//    while ([resultSet next]) {
//        CityModel *model=[[CityModel alloc]init];
//        model.Id=[resultSet stringForColumn:@"districtid"];
//        model.Name=[resultSet stringForColumn:@"districtname"];
//        
//        [array addObject:model];
//    }
//    return array;
//}
#pragma mark - pickerView delegate
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component==0){
        return _provinceArr.count;
    }else if(component==1){
        return _cityArr.count;
    }
    return _districtArr.count;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0f;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return kkDeviceWidth/3;
}
//设置返回的标题的属性
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0,0,kkDeviceWidth/3,40)];
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
    }else{
        model=_districtArr[row];
        if(row==_selectedDistrict){
            label.textColor=toPCcolor(@"ca3b2b");
        }
    }
    label.text=model.Name;
    return label;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component==0){
        CityModel *model=_provinceArr[row];
        _cityArr=[_addressDC getCity:model.Id];
        
        CityModel *subModel=_cityArr[0];
        _districtArr=[_addressDC getDistrictid:subModel.Id];
        
        [pickerView selectRow:0 inComponent:1 animated:NO];
        [pickerView selectRow:0 inComponent:2 animated:NO];
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        _selectedCity=0;
        _selectedProvince=row;
    }else if(component==1){
        CityModel *model=_cityArr[row];
        _selectedDistrict=0;
        _selectedCity=row;
        _districtArr=[_addressDC getDistrictid:model.Id];
        [pickerView selectRow:0 inComponent:2 animated:NO];
        [pickerView reloadComponent:2];
    }else{
        _selectedDistrict=row;
    }
    [pickerView reloadAllComponents];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(![touch.view isKindOfClass:[ChooseAddressView class]]){
        return NO;
    }
    return YES;
}
//- (NSString *)getCityNameById:(NSString *)provinceId andCityId:(NSString *)cityId
//{
//    NSString *sql=[NSString stringWithFormat:@"select * from base_city where provinceid=%@ and cityid=%@",provinceId,cityId];
//    FMResultSet *resultSet=[_database executeQuery:sql];
//    NSString *cityName;
//    while ([resultSet next]) {
////        CityModel *model=[[CityModel alloc]init];
////        model.Id=[resultSet stringForColumn:@"cityid"];
//        cityName=[resultSet stringForColumn:@"cityname"];
//        break;
//    }
//    return cityName;
//}
@end
