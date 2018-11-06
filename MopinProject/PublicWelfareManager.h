//
//  PublicWelfareManager.h
//  MopinProject
//
//  Created by xhd945 on 16/2/2.
//  Copyright © 2016年 rt008. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicWelfareManager : NSObject


+(instancetype)shareInstance;

-(void)requestPublicWelfareState; //从网络获取公益状态

-(NSString*)getPublicWelfareState;  //获取状态

@end
