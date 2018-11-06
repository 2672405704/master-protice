//
//  EvaluteListModel.h
//  MopinProject
//
//  Created by rt008 on 15/12/3.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "SuperModel.h"

@interface EvaluteListModel : SuperModel
@property (nonatomic,copy) NSString *EID;
@property (nonatomic,copy) NSString *ArtName;
@property (nonatomic,copy) NSString *PhotoPath;
@property (nonatomic,copy) NSString *Nickname;
@property (nonatomic,copy) NSString *EDate;
@property (nonatomic,copy) NSString *Content;
@property (nonatomic,copy) NSMutableArray *ImageData;
@property (nonatomic,copy) NSString *ReContent;
@property (nonatomic,copy) NSString *ReTime;
@end
