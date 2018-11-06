//
//  AddressDataCenter.m
//  MopinProject
//
//  Created by rt008 on 15/12/7.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "AddressDataCenter.h"
#import "FMDatabase.h"
#import "CityModel.h"

@implementation AddressDataCenter
{
    FMDatabase *_database;
}
+ (id)sharedInstance
{
    static AddressDataCenter *adc=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        adc=[[[self class] alloc]init];
    });
    return adc;
}
- (id)init
{
    if(self=[super init]){
        [self initDatabase];
    }
    return self;
}
- (void)initDatabase
{
    _database=[[FMDatabase alloc]initWithPath:[[NSBundle mainBundle] pathForResource:@"mopin" ofType:@"db"]];
    if(_database.open==NO){
        NSLog(@"地址数据库打开失败");
    }
}
//TODO:获取所有省份
-(NSArray *)getProvince
{
    NSString *sql=[NSString stringWithFormat:@"select * from base_province"];
    FMResultSet *resultSet=[_database executeQuery:sql];
    NSMutableArray *array=[NSMutableArray array];
    while ([resultSet next]) {
        CityModel *model=[[CityModel alloc]init];
        model.Id=[resultSet stringForColumn:@"provinceid"];
        model.Name=[resultSet stringForColumn:@"provincename"];
        [array addObject:model];
    }
    return array;
    
}
//TODO:根据城市名字获取
-(NSString *)getProvinceidByCityName:(NSString *)cityName
{
    NSString *sql=[NSString stringWithFormat:@"select * from base_city where cityname=?"];
    FMResultSet *resultSet=[_database executeQuery:sql,cityName];
    NSString *provinceid;
    while ([resultSet next]) {
        provinceid=[resultSet stringForColumn:@"provinceid"];
        break;
    }
    return provinceid;
}
//TODO:用省份的id获取城市
-(NSArray *)getCity:(NSString *)provinceid
{
    NSString *sql=[NSString stringWithFormat:@"select * from base_city where provinceid=%@",provinceid];
    FMResultSet *resultSet=[_database executeQuery:sql];
    NSMutableArray *array=[NSMutableArray array];
    while ([resultSet next]) {
        CityModel *model=[[CityModel alloc]init];
        model.Id=[resultSet stringForColumn:@"cityid"];
        model.Name=[resultSet stringForColumn:@"cityname"];
        
        [array addObject:model];
    }
    return array;
}
//TODO:用城市ID获取区
-(NSArray *)getDistrictid:(NSString *)cityId
{
    NSString *sql=[NSString stringWithFormat:@"select * from base_district where cityid=%@",cityId];
    FMResultSet *resultSet=[_database executeQuery:sql];
    NSMutableArray *array=[NSMutableArray array];
    while ([resultSet next]) {
        CityModel *model=[[CityModel alloc]init];
        model.Id=[resultSet stringForColumn:@"districtid"];
        model.Name=[resultSet stringForColumn:@"districtname"];
        
        [array addObject:model];
    }
    return array;
}
//TODO:获取省和市的名字
- (NSString *)getProvinceNameWith:(NSString *)provinceId andCityName:(NSString *)cityId
{
    if(provinceId.length==0){
        return @"";
    }
    NSString *sql=[NSString stringWithFormat:@"select * from base_province where provinceid=%@",provinceId];
    FMResultSet *resultSet=[_database executeQuery:sql];
   
    NSString *provinceName;
    NSString *cityName;
    while ([resultSet next]) {
        provinceName=[resultSet stringForColumn:@"provincename"];
    }
    
    sql=[NSString stringWithFormat:@"select * from base_city where provinceid=%@ and cityid=%@",provinceId,cityId];
    FMResultSet *resultSet2=[_database executeQuery:sql];
    while ([resultSet2 next]) {
        cityName=[resultSet2 stringForColumn:@"cityname"];
    }
    if([provinceName isEqualToString:cityName]){
        return provinceName;
    }
    if(provinceName.length==0){
        return @"";
    }
    return [NSString stringWithFormat:@"%@%@",provinceName,cityName];
}
//TODO:获取省市区的名称
- (NSString *)getProvinceNameWith:(NSString *)provinceId andCityName:(NSString *)cityId andDistrictName:(NSString *)districtId
{
    if(provinceId.length==0){
        return @"";
    }
    NSString *sql=[NSString stringWithFormat:@"select * from base_province where provinceid=%@",provinceId];
    FMResultSet *resultSet=[_database executeQuery:sql];
    
    NSString *provinceName;
    NSString *cityName;
    NSString *districtName;
    while ([resultSet next]) {
        provinceName=[resultSet stringForColumn:@"provincename"];
    }
    
    sql=[NSString stringWithFormat:@"select * from base_city where provinceid=%@ and cityid=%@",provinceId,cityId];
    FMResultSet *resultSet2=[_database executeQuery:sql];
    while ([resultSet2 next]) {
        cityName=[resultSet2 stringForColumn:@"cityname"];
    }
    
    sql=[NSString stringWithFormat:@"select * from base_district where districtid=%@ and cityid=%@",districtId,cityId];
    FMResultSet *resultSet3=[_database executeQuery:sql];
    while ([resultSet3 next]) {
        districtName=[resultSet3 stringForColumn:@"districtname"];
    }
    if(districtName.length==0){
        districtName=@"";
    }
    if([provinceName isEqualToString:cityName]){
        return [NSString stringWithFormat:@"%@%@",provinceName,districtName];
    }
    
    return [NSString stringWithFormat:@"%@%@%@",provinceName,cityName,districtName];
}
//TODO:用省份ID和城市ID获取城市名字
- (NSString *)getCityNameById:(NSString *)provinceId andCityId:(NSString *)cityId
{
    NSString *sql=[NSString stringWithFormat:@"select * from base_city where provinceid=%@ and cityid=%@",provinceId,cityId];
    FMResultSet *resultSet=[_database executeQuery:sql];
    NSString *cityName;
    while ([resultSet next]) {
        //        CityModel *model=[[CityModel alloc]init];
        //        model.Id=[resultSet stringForColumn:@"cityid"];
        cityName=[resultSet stringForColumn:@"cityname"];
        break;
    }
    return cityName;
}
//TODO:获取城市名字和区的名字
- (NSArray *)getDistrictName:(NSString *)districtId andCityName:(NSString *)cityId andPrvincedId:(NSString *)provincedId
{
    NSString *sql=[NSString stringWithFormat:@"select * from base_city where provinceid=%@ and cityid=%@",provincedId,cityId];
    FMResultSet *resultSet=[_database executeQuery:sql];
    NSMutableArray *array=[NSMutableArray array];
    while ([resultSet next]) {
        CityModel *model=[[CityModel alloc]init];
        model.Id=[resultSet stringForColumn:@"cityid"];
        model.Name=[resultSet stringForColumn:@"cityname"];
        
        [array addObject:model];
    }
    
    sql=[NSString stringWithFormat:@"select * from base_district where districtid=%@ and cityid=%@",districtId,cityId];
    FMResultSet *resultSet2=[_database executeQuery:sql];
    while ([resultSet2 next]) {
        CityModel *model=[[CityModel alloc]init];
        model.Id=[resultSet2 stringForColumn:@"districtid"];
        model.Name=[resultSet2 stringForColumn:@"districtname"];
        
        [array addObject:model];
    }
    return array;
}
@end
