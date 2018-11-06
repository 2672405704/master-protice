//
//  ExmapleWorkDetailVC.h
//  MopinProject
//
//  Created by xhd945 on 15/12/10.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"


@interface ExmapleWorkDetailVC : BaseSuperViewController


@property (nonatomic,strong) void(^refreshPenmanDetail)(); //刷新书家

- (instancetype)initWithArtID:(NSString*)artID
                  AndArtPrice:(NSString*)artPrice
                         PMID:(NSString*)PMID;

@end
