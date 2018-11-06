//
//  SceneView.h
//  View
//
//  Created by happyzt on 15/12/10.
//  Copyright © 2015年 happyzt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FouthSectionView : UIView

@property(nonatomic,strong)NSString*Place; //适用场所 返回的时候多个用,线隔开

- (instancetype)initWithFrame:(CGRect)frame  PlaceStr:(NSString*)placeStr;

- (void)initDisplayView;

@end
