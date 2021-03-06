//
//  QRCScannerViewController.h
//  QRScannerDemo
//  blog:www.zhangfei.tk
//  Created by zhangfei on 15/10/15.
//  Copyright © 2015年 zhangfei. All rights reserved.
//

#import "BaseSuperViewController.h"

@protocol QRCodeScannerViewControllerDelegate <NSObject>
/**
 *  扫描成功后返回扫描结果
 *
 *  @param result 扫描结果
 */
- (void)didFinshedScanning:(NSString *)result;

@end

@interface QRCScannerViewController : BaseSuperViewController

@property (nonatomic,assign) id<QRCodeScannerViewControllerDelegate> delegate;

@end
