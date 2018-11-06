//
//  PicSelectView.h
//  MixiMixiBakers
//
//  Created by xhd945 on 15/10/7.
//  Copyright © 2015年 HuangCaixia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^finishSelectPic)(UIImage*);
typedef void (^cancelSelectPic)();

@interface PicSelectView : UIImageView<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property(nonatomic,strong)UIButton*cancelButton;//取消按钮

@property(nonatomic,assign)BOOL isChange; //照片是否改变

@property(nonatomic,strong)UIViewController*delegate;

@property(nonatomic,copy)finishSelectPic compelteSelected;//完成图片选择

@property(nonatomic,copy)cancelSelectPic cancelSelected;//取消图片选择

@property(nonatomic,strong)NSString*picUrlStr; //图片地址

@end
