//
//  AddressModel.h
//  MopinProject
//
//  Created by rt008 on 15/11/26.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "SuperModel.h"

@interface AddressModel : SuperModel
@property (nonatomic,copy) NSString *Addressid; //地址ID
@property (nonatomic,copy) NSString *Name;//收件人地址
@property (nonatomic,copy) NSString *Mobile;//收件人手机号
@property (nonatomic,copy) NSString *Address;//详细地址
@property (nonatomic,copy) NSString *IsDefault;//是否是默认
@property (nonatomic,copy) NSString *CityID;//城市ID
@property (nonatomic,copy) NSString *ProvinceID;//省份ID
@property (nonatomic,copy) NSString *DistrictID;//居住地ID
@end
