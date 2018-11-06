//
//  CheckCustomRemarkVC.h
//  
//
//  Created by xhd945 on 16/1/8.
//
//

#import "BaseSuperViewController.h"

@interface CheckCustomRemarkVC : BaseSuperViewController

@property(nonatomic,strong,readonly)NSString *contentStr; //内容
@property(nonatomic,strong,readonly)NSString*titleName;//标题
- (instancetype)initWithContent:(NSString*)ContentStr
                      TitleName:(NSString*)titleName;
@end
