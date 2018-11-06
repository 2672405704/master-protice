//
//  AddressDataCenter.h
//  MopinProject
//
//  Created by rt008 on 15/12/7.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressDataCenter : NSObject
//获取单例对象
+(id)sharedInstance;
-(NSArray *)getProvince;
-(NSArray *)getCity:(NSString *)provinceid;
-(NSArray *)getDistrictid:(NSString *)cityId;
- (NSString *)getCityNameById:(NSString *)provinceId andCityId:(NSString *)cityId;
- (NSArray *)getDistrictName:(NSString *)districtId andCityName:(NSString *)cityId andPrvincedId:(NSString *)provincedId;
- (NSString *)getProvinceNameWith:(NSString *)provinceId andCityName:(NSString *)cityId;
- (NSString *)getProvinceNameWith:(NSString *)provinceId andCityName:(NSString *)cityId andDistrictName:(NSString *)districtId;
@end
