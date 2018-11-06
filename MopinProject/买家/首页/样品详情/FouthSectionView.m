//
//  SceneView.m
//  View
//
//  Created by happyzt on 15/12/10.
//  Copyright © 2015年 happyzt. All rights reserved.
//

#import "FouthSectionView.h"
#import "CustomTitleView.h"

#define LabelW ((kkDeviceWidth-65)/4)
#define LabelH 30

@implementation FouthSectionView

- (instancetype)initWithFrame:(CGRect)frame  PlaceStr:(NSString*)placeStr
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        _Place = placeStr;
        [self initDisplayView];
    } 
    
    return self;
}

- (void)initDisplayView
{
    for(UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    
    CustomTitleView *  logoTitView = [[CustomTitleView alloc]initWithFrame:mRect(self.width/2.0-50, 20, 100,20) AndImageName:@"tag_easyicon" AndTitleName:@"适用场所"];
    [self addSubview:logoTitView];
    
    //3>创建场景
    NSString *testStr = _Place.length?_Place:@"不限";
    NSArray *sceneName = [testStr componentsSeparatedByString:@"|"];
    for (int i = 0; i < sceneName.count; i++)
    {
        NSString *titleStr = sceneName[i];
        if(titleStr.length>0)
        {
            UILabel *sceneLabel = [[UILabel alloc] initWithFrame:CGRectMake(25+(LabelW+5)*(i%4),60+i/4*(30+8), LabelW, LabelH)];
            
            sceneLabel.text = titleStr;
            
            sceneLabel.font = [UIFont systemFontOfSize:13];
            sceneLabel.textAlignment = NSTextAlignmentCenter;
            
            sceneLabel.layer.cornerRadius = 3;
            sceneLabel.layer.borderColor = [UIColor grayColor].CGColor;
            sceneLabel.layer.borderWidth = 0.6;
            sceneLabel.textColor = TitleFontColor;
            [self addSubview:sceneLabel];

        }
    }
    if(sceneName.count>1)
    {
        if((sceneName.count-1)%4!=0)
        {
            self.height = (((sceneName.count-1)/4)+1)*(30+8)-10+30+60;
            
        }else if((sceneName.count-1)%4 ==0) {
            
            self.height = ((sceneName.count-1)/4+1)*(30+8)+50;
        }
    
    }
   
    
}

@end
