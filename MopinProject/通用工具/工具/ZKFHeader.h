//
//  ZKFHeader.h
//  SJHairDressingProject
//
//  Created by rt008 on 15/9/7.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#ifndef SJHairDressingProject_ZKFHeader_h
#define SJHairDressingProject_ZKFHeader_h

/*--------------开发中常用到的宏定义--------------*/

//系统目录
#define kDocuments  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

#define iOS7  ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

#define WINDOW [[UIApplication sharedApplication].delegate window]

//判断IOS7及以后系统
#define IOS7_AND_LATER ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)

//判断是否为iPhone4
#define  iPhone4   (\
CGSizeEqualToSize( [UIScreen mainScreen].bounds.size , CGSizeMake(320, 480)) || CGSizeEqualToSize( [UIScreen mainScreen].bounds.size , CGSizeMake(640, 960)) \
)
//----------方法简写-------
#define mAppDelegate        (AppDelegate *)[[UIApplication sharedApplication] delegate]

#define mWindow             [[[UIApplication sharedApplication] windows] lastObject]
#define mKeyWindow          [[UIApplication sharedApplication] keyWindow]
#define mUserDefaults       [NSUserDefaults standardUserDefaults]
#define mNotificationCenter [NSNotificationCenter defaultCenter]

//加载图片
#define mImageByName(name)        [UIImage imageNamed:name]
#define mImageByPath(name, ext)   [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:ext]]
#define mImageByCap(imgname,a,b,c,d)   [[UIImage imageNamed:imgname] resizableImageWithCapInsets:UIEdgeInsetsMake(a, b, c, d)]

//以tag读取View
#define mViewByTag(parentView, tag, Class)  (Class *)[(UIView *)parentView viewWithTag:tag]
//读取Xib文件的类
#define mViewByNib(Class, owner) [[[NSBundle mainBundle] loadNibNamed:Class owner:owner options:nil] lastObject]

//id对象与NSData之间转换
#define mObjectToData(object)   [NSKeyedArchiver archivedDataWithRootObject:object]
#define mDataToObject(data)     [NSKeyedUnarchiver unarchiveObjectWithData:data]

//度弧度转换
#define mDegreesToRadian(x)      (M_PI * (x) / 180.0)
#define mRadianToDegrees(radian) (radian*180.0) / (M_PI)

//颜色转换
#define mRGBColor(r, g, b)         [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define mRGBAColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//rgb颜色转换（16进制->10进制）
#define mRGBToColor(rgb) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0]
//----------页面设计相关-------
//获取设备的物理宽度
#define kkDeviceWidth ([UIScreen mainScreen].bounds.size.width)
#define kkDeviceHeight ([UIScreen mainScreen].bounds.size.height)
#define GETVIEWHEIGHT(x)  (x.frame.size.height)
#define GETVIEWWIDTH(x)   (x.frame.size.width)
#define GETVIEWORANGEX(view)   (view.frame.origin.x)
#define GETVIEWORANGEY(view)   (view.frame.origin.y)

#define UIFONT(x) [UIFont systemFontOfSize:x]

#define mRect(x,y,w,h) CGRectMake(x, y, w, h)

#define mNavBarHeight         64
#define mTabBarHeight         49

/*--------------------网络请求有关--------------*/

#define Infversion @"1.0" //接口版本号

//根地址 0-测试 1-正式

#if  0

#define RootURL @"http://app.mopin.net/" //正式根地址

#else

#define RootURL @"http://101.200.74.205:8081/" //测试式根地址


#endif



#define HOSTURL [NSString stringWithFormat:@"%@moping-http/api", RootURL]



//网络请求
#define WEBURL  [NSString stringWithFormat:@"%@/DataService/service.ashx", HOSTURL]

//图片上传
#define UPLOADURL [NSString stringWithFormat:@"%@moping-http/SavePic", RootURL] //上传图片
#define UPLOADHEARDERURL [NSString stringWithFormat:@"%@moping-http/SaveUserPhoto", RootURL]//上传头像


#define BACKGOODSRULE  [NSString stringWithFormat:@"%@/moping-http/mpgz", HOSTURL]  //退货规则


#define WEBSITE_URL @""  //官方网站
#define SHARE_URL @"m.shufa.cn" //分享的域名
#define HTTP_TIME_OUT            20//网络超时
#define EVERY_PAGE_SIZE             @"10"//请求页数
#define setDickeyobj(dic,obj,key)     [dic setObject:obj forKey:key];
#define dicforkey(dic,key)      [dic objectForKey:key];

/*--------------------字数限制-----------------*/
#define FEEDBACK_LENGTH 500    //反馈长度

/*----------------------字数限制-------------------------*/
#define Notification_COUNT @"RefreshCount"         //刷新余额 优惠券 收藏的数量
/*----------------------字体名字-------------------------*/

#define XiaoBiaoSong @"FZXiaoBiaoSong-B05S"

/*----------------------默认图片-------------------------*/
//#define PlaceHolderHeaderImage [UIImage imageNamed:@""]
//#define PlaceHolderImage [UIImage imageNamed:@"plus_book_mine.png"]

UIKIT_STATIC_INLINE UIColor *toPCcolor(NSString *pcColorstr)
{
    unsigned int c;
    
    if ([pcColorstr characterAtIndex:0] == '#') {
        
        [[NSScanner scannerWithString:[pcColorstr substringFromIndex:1]] scanHexInt:&c];
        
    } else {
        
        [[NSScanner scannerWithString:pcColorstr] scanHexInt:&c];
        
    }
    
    return [UIColor colorWithRed:((c & 0xff0000) >> 16)/255.0 green:((c & 0xff00) >> 8)/255.0 blue:(c & 0xff)/255.0 alpha:1.0];
}
@protocol DataModelInfo <NSObject>

/**
 *	@brief	Get all type data id
 *
 *	@return	id
 */
///#end
- (NSString *)dataId;

/**
 *	@brief	type
 *
 *	@return	type
 */
///#end
- (NSString *)type;


/**
 *	@brief	Get all type data title
 *
 *	@return	dataTitle
 */
///#end
- (NSString *)dataTitle;


/**
 *	@brief	Get all type data dataName
 *
 *	@return	dataName
 */

- (NSString *)dataName;


/**
 *	@brief	Get all type data description
 *
 *	@return	dataDescription
 */

///#end
- (NSString *)dataDescription;


/**
 *	@brief	Get data url path
 *
 *	@return	urlPath
 */
///#end
- (NSString *)urlPath;

/**
 *	@brief	Get image url
 *
 *	@return	imagePath
 */
///#end
- (NSString *)imagePath;

/**
 *	@brief	Get  daya   price
 *
 *	@return	dataPrice
 */
///#end
- (NSString *)dataPrice;



/**
 *	@brief	Get dataSizeInfo
 *
 *	@return	dataSizeInfo
 */
///#end
- (NSString *)dataSizeInfo;


/**
 *	@brief	Get dataContent
 *
 *	@return	dataContent
 */
///#end
- (NSString *)dataContent;

/**
 *	@brief	Get  dataRGB
 *
 *	@return	dataRGB
 */
///#end
- (NSString *)dataRGB;

/**
 *	@brief	Get  dataColor
 *
 *	@return	dataColor
 */
///#end
- (NSString *)dataColor;

/**
 *	@brief	Get  dataInStock
 *
 *	@return	dataInStock
 */
///#end
- (NSString *)dataInStock;
/**
 *	@brief	Get  dataIsFavorite
 *
 *	@return	dataIsFavorite
 */
///#end
- (NSString *)dataIsFavorite;

@end
#endif

