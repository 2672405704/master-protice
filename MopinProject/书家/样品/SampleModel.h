//
//  SampleModel.h
//  MopinProject
//
//  Created by rt008 on 15/11/27.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "SuperModel.h"

@interface SampleModel : SuperModel
@property (nonatomic,readonly,copy) NSString *ArtID;
@property (nonatomic,readonly,copy) NSString *Name;
@property (nonatomic,readonly,copy) NSString *ShowType;
@property (nonatomic,readonly,copy) NSString *WordType;
@property (nonatomic,readonly,copy) NSString *SizeWidth;
@property (nonatomic,readonly,copy) NSString *SizeHigh;
@property (nonatomic,readonly,copy) NSString *ArtPic;
@property (nonatomic,readonly,copy) NSString *Photo;
@property (nonatomic,readonly,copy) NSString *Price;
@property (nonatomic,readonly,copy) NSString *CouponsRatio;
@property (nonatomic,readonly,copy) NSString *IsPublicGoodSample;
@end
