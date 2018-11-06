//
//  PenmanDetailCommentModel.h
//  MopinProject
//
//  Created by rt008 on 15/12/10.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "SuperModel.h"

@interface PenmanDetailCommentModel : SuperModel
@property (nonatomic,copy,readonly) NSString *EID;//评价ID
@property (nonatomic,copy,readonly) NSString *EPhoto;//评价头像
@property (nonatomic,copy,readonly) NSString *EContent;//评价内容
@property (nonatomic,copy,readonly) NSString *ENickName;//评价名字
@property (nonatomic,copy,readonly) NSString *ReContent;//回复内容
@property (nonatomic,copy) NSArray *ImageDataArr;//评价图片
@end
