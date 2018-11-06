//
//  KuangBiaoChooseView.h
//  MopinProject
//
//  Created by xhd945 on 15/12/16.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWTagList.h"

@class ZhuanBiaoTypeMod;
@class CommonEmptyTableBgView; //空载页


/**   数据源格式
 
 "ZhBType": "1",
 "ZhBStyleData": [
 {
 "ZhBStyle": "1",
 "ZhBStyleName": "样式一",
 "ZhBStylePic": "http://www.baidu.com/1.jpg",
 "ZhBSize": "1000m*3000m",
 "ZhBPrice": "1000"
 },
 {
 "ZhBStyle": "2",
 "ZhBStyleName": "样式二",
 "ZhBStylePic": "http://www.baidu.com/2.jpg",
 "ZhBSize": "1000m*3000m",
 "ZhBPrice": "2000"
 }

 **/

typedef void(^FinishChooseZhuanBiaoTypeBlock)(ZhuanBiaoTypeMod*mod);

@interface KuangBiaoChooseView : UIView<UIScrollViewDelegate,ChooseTagDelegate>

@property(nonatomic,copy)FinishChooseZhuanBiaoTypeBlock finishChoose;   //完成选择的Block

@property(nonatomic,strong)NSDictionary*dataDic;  //数据源字典
//@property(nonatomic,strong)NSMutableArray *dataArr; //数据源
@property(nonatomic,strong)CommonEmptyTableBgView *emptyView;


- (instancetype)initWithFrame:(CGRect)frame  StyleID:(NSString*)StyleID StyleName:(NSString*)name;
@end
