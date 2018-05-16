
//
//  CommonMacroDefinitions .h
//  NewProject
//
//  Created by apple on 2017/6/25.
//  Copyright © 2017年 JuNiao. All rights reserved.
//

#ifndef CommonMacroDefinitions__h
#define CommonMacroDefinitions__h

//接口域名
#define DefaultDomainName DebugDomain
//测试环境
#define DebugDomain @"http://testweb.kuaiyishare.com/"
//正式环境
#define FormalDomain @"https://www.kuaiyishare.com/"

//图片域名
#define defaultUrl DebugImgDomain
//测试环境
#define DebugImgDomain @"http://testweb.kuaiyishare.com"
//正式环境
#define FormalImgDomain @"https://static.kuaiyishare.com"

//商品分享域名
#define GoodShareUrl DebugGoodShareDomain
//测试环境
#define DebugGoodShareDomain @"http://testweb.kuaiyishare.com/Mobile/Toshare/toshare"
//正式环境
#define FormalGoodShareDomain @""

//店铺分享域名
#define ShopShareUrl DebugShopShareDomain
//测试环境
#define DebugShopShareDomain @"http://testweb.kuaiyishare.com/Mobile/Toshare/shopgoodslist"
//正式环境
#define FormalShopShareDomain @""

//拼接分享商品或商家的链接地址
#define JoinShareWebUrlStr(webUrl,goods_id,business_id,mobile) [webUrl stringByAppendingString:[NSString stringWithFormat:@"?goods_id=%@&business_id=%@&mobile=%@",goods_id,business_id,mobile]]


//获取用户的token的令牌
#define tokenappid  @"qqgx69728090"

#define tokenappsecret  @"gx6670238160ravntyhaoapp61267926"

//rgb颜色
#define hwcolor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//16进制颜色
#define HexColor(hexstring) [UIColor colorWithHexString:@#hexstring]

//随机色
#define hwrandomcolor hwcolor(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

//从网络plish文件中查找相对应的字段请求地址
#define NetRequestUrl(key) [[[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NetRequestUrl" ofType:@"plist"]] objectForKey:@#key]

//拼接图片的宏
#define JointImgUrl(imgUrlStr) [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DefaultDomainName,imgUrlStr]]

//导航栏颜色
#define NAVIGATIONBAR_COLOR  [UIColor colorWithRed:225.0f/255.0f green:39.0f/255.0f blue:39.0f/255.0f alpha:1.0f]


//视图背景颜色
#define BACKVIEWCOLOR  hwcolor(245, 245, 245)

#define DCBGColor  hwcolor(245, 245, 245)

//cell边框色
#define   CELLBORDERCOLOR  hwcolor(212, 212, 212)

//cell头视图灰色
#define HEADVIEWGRAYCOLOR  hwcolor(235, 235, 235)

//设置字体
#define PFR [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? @"PingFangSC-Regular" : @"PingFang SC"
//设置不同大小字体
#define PFR26Font [UIFont fontWithName:PFR size:26]
#define PFR20Font [UIFont fontWithName:PFR size:20]
#define PFR18Font [UIFont fontWithName:PFR size:18]
#define PFR16Font [UIFont fontWithName:PFR size:16]
#define PFR15Font [UIFont fontWithName:PFR size:15]
#define PFR14Font [UIFont fontWithName:PFR size:14]
#define PFR13Font [UIFont fontWithName:PFR size:13]
#define PFR12Font [UIFont fontWithName:PFR size:12]
#define PFR11Font [UIFont fontWithName:PFR size:11]
#define PFR10Font [UIFont fontWithName:PFR size:10]
#define PFR9Font [UIFont fontWithName:PFR size:9]


#define AlipayPublicKey  @"MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC7En+5+va/cezvzY3nJiYi5rCmg9wkt4tS0tFX76z2sJXUK0u9hNVIvYgRajdvvfvdsCvF4SeaRa/h93ZPSvqKwZXdCr9Rsu/I0n/h2uT+ZZt29D8XP0vLewA+H9rJi5i543a6aWzEEc6qQ5gs3z8+mUFfl7BW5DgD+FLRrFCV7rANXzA/B0lbYVM77TtsrFBtMtWYpt9DQ0zrnXQp4IWaidyJFZVZ/fxbr99fTVfNVBp+IXKYjFrCzBAbkB5cc9jKPc6GFeLl3/ABJUyG/WC2doJRdYiJW7UrGHvv+XeonBUMKhxtXHPeAp/DivmPCu3BmuSlsD0y+8uz/CJl1zHBAgMBAAECggEAXdiI5NbGZAIV97LpxhS4Ovf5lH8/t9ev+Au0Y2XkIhkyAK77nwZ9LLGQChR73P201WCkhO9Pu6/L7RMEcgDOMT+uG6Zhle2rJtaausXh7NEyLXmYEOR69Igu9ftq+YKjSlWW4Ss0GiRIxdeFBrWz94ZQalEhcGWqyCsR+Qd1odCwzl1Wf2ywkE6iPGe5wCJqGHOfl5FwgZwliSLOP3zj4UqNXvVngWG3vp8q0nXeyFXvNiLuShCjzJATw1M8GJHD4EXZcubOh3qL623/imafP/rzIZTMEUat09yTK/TZj+m9+PoUuLanvLxPEvNGSTZTIEW5nbbmxLm/6eyggQ7edQKBgQDplDQ2TFmVcIfNjKZeN++eX/L4BOA5curxdsst8mY8RzKEiG5H9TVHKmb0vBaLWN5JkA7t7eiA66rrnvqnBaKCLh/VzjTXgpeAKSJ5HsUyLvKnbCqtPiyk/lZOq5TJ4AJTxjxDO83KDP+1UCVKQJ289FntZfqJOXGDmL/nvzoGtwKBgQDNB3mBWdl4q088W6QpchgdvdASsCpotkc/u90YPAweZ4dJ2a7v9sXxS2zVKj5teO6TAKpmelscDlZggKv9UR54CZNPWpn3Dgbi3hvMM46zjQjBf9tg7T2RnXNoRxRZJySjPBIi5TTtVLymqpn6TZauysVgtwURbLUsTZBKNf5TRwKBgQCFiB5ZNEi6b/yS++dYUa4A4mVqeI8fCJ1bsUfyWnMr3p/4uG4jYQE2T/1Px/8zZnidoWeHicyzdwbdcKNmvIfs2CWG+z2mPpgRwnJcv8SILeK259V1+OdY47W/f8OtrQxnjBqDbTr2WXwN0WWgD1Sd4ytN1lDmBhro2nhLKj0n/QKBgQCLXPBPZ0Z2SmOSkGwWq/IOjU4Y1dwNzxDBFq5jYbWPGSoRncDWZbQInw88GfnTKadpDsPE4ph5iplWAUBm8LO4PjH+d4Q+NS+jF/xnIgh2rX/tHz58NOZry0197Qq8yumRdyyQwaHnTHjrBP2i8QhiiXv+kIkGXhEMKzDP8MGN0wKBgDLdKnl9f+SFhU3VcsgsBo8oSOyMQeW2hzPvbW/RMIAoQfXZ58P2uTu+++E2i7MpcFs1waqNTD5raWaNq0mfgf1ou4ofetqSCxz4B66hT1ezy8Li9B1tZIz3SQtjudVJ+L1qmcAxt54g+1IG0GQhhtNF5IBi1JVJ42T/SbL76nIt"


//进行rsa公钥加密
#define ENCRYPTSTR(str) [NSString_Validation encryptString:str publicKey:@"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDaPXzkgIgZ2pi9yZmrde80IyBK/OFLvQgAQtVAuxwiVEKw7McTU+drygX+p/yHmZehg31xMzUs5kRJ2qBD9KesTzF0BEEEUn/E8/+FwtIBZ6KdDnIBFTBrdY0Re8AT+zH1mHQ0+MpSp/a2mVgdlPkzQrIQDDO7lf3WAsMVDnEP/wIDAQAB"]


//MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDGaTnyO0j1DuiqQGa6WcHdk4/zpO2IU3XbZOKfqxb8rVzRsI2xYsYwaGGw4LgeyiEhkaZSKV/wzsrl8W+iLlnhyHaW/s8bWwOJRxEw9XQyQW/sv7QuDxdhdY118LI8+OlbqEm046JP1emyZ00wlstvr/C+2rZwtgiVFzq3ZgnMawIDAQAB


#define CellAnimationType 0


//不同cell宽高
#define DCGoodsYouLikeCellSize CGSizeMake((SCREEN_WIDTH - 10)/2,(SCREEN_WIDTH - 10)/2*1.35)
#define OtherCollectionViewCellSize CGSizeMake((SCREEN_WIDTH - 4)/2,(SCREEN_WIDTH - 4)/2*1.42)



//-------------------弱引用/强引用-------------------------

#define LRWeakSelf(type)  __weak typeof(type) weak##type = type;
#define LRStrongSelf(type)  __strong typeof(type) type = weak##type;


//-------------------弱引用/强引用-------------------------

//GCD封装宏
#define GCDAsynMain(Block) dispatch_async(dispatch_get_main_queue(), Block)

#define GCDAfter1s(Block) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), Block);


//-------------------获取设备大小-------------------------
//NavBar高度
#define NAVIGATION_BAR_HEIGHT 64
/** 底部tab高度 */
#define NAVIGATION_TAB_HEIGHT 49

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define ScreenW ([UIScreen mainScreen].bounds.size.width)
#define ScreenH ([UIScreen mainScreen].bounds.size.height)

//根据屏幕宽度比例计算当前宽度，或根据宽高比计算实际高度
#define kScaelW(x) (ScreenW * x/375)

//-------------------获取设备大小-------------------------




//----------------------系统----------------------------


//获取系统版本
#define IOS_VERSION ［[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion ［UIDevice currentDevice] systemVersion]


//获取当前语言
#define CurrentLanguage (［NSLocale preferredLanguages] objectAtIndex:0])

//判断是否 Retina屏、设备是否%fhone 5、是否是iPad
#define is_Retina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), ［UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), ［UIScreen mainScreen] currentMode].size) : NO)
#define is_Pad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//判断设备的操做系统是不是ios7
#define IOS7 (［[UIDevice currentDevice].systemVersion doubleValue] >= 7.0]

//判断当前设备是不是iphone5
#define kScreenIphone5 ((［UIScreen mainScreen] bounds].size.height)>=568)

//获取当前屏幕的高度
#define kMainScreenHeight ([UIScreen mainScreen].applicationFrame.size.height)

//获取当前屏幕的宽度
#define kMainScreenWidth ([UIScreen mainScreen].applicationFrame.size.width)



//定义一个define函数
#define TT_RELEASE_CF_SAFELY(__REF) { if (nil != (__REF)) { CFRelease(__REF); __REF = nil; } }

//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v) (［[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) (［[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) (［[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) (［[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) (［[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


//----------------------系统----------------------------


//----------------------内存----------------------------

//使用ARC和不使用ARC
#if __has_feature(objc_arc)
//compiling with ARC
#else
// compiling without ARC
#endif

#pragma mark - common functions
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

//释放一个对象
#define SAFE_DELETE(P) if(P) { [P release], P = nil; }

#define SAFE_RELEASE(x) [x release];x=nil



//----------------------内存----------------------------


//----------------------图片----------------------------

//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:［NSBundle mainBundle]pathForResource:file ofType:ext］

//定义UIImage对象
#define IMAGE(A) [UIImage imageWithContentsOfFile:［NSBundle mainBundle] pathForResource:A ofType:nil］

//定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer］

#define UIImageNamed(imageName) [UIImage imageNamed:imageName]
//建议使用前两种宏定义,性能高于后者
//----------------------图片----------------------------



//----------------------颜色类---------------------------
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

//背景色
#define BACKGROUND_COLOR [UIColor colorWithRed:242.0/255.0 green:236.0/255.0 blue:231.0/255.0 alpha:1.0]

//清除背景色
#define CLEARCOLOR [UIColor clearColor]

#pragma mark - color functions
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]


//----------------------颜色类--------------------------



//----------------------其他----------------------------

//方正黑体简体字体定义
#define FONT(F) [UIFont fontWithName:@"FZHTJW--GB1-0" size:F]


#define Font(F) [UIFont systemFontOfSize:F]


//定义一个API
#define APIURL @"http://xxxxx/"
//登录API
#define APILogin [APIURL stringByAppendingString:@"Login"]

//设置View的tag属性
#define VIEWWITHTAG(_OBJECT, _TAG) [_OBJECT viewWithTag : _TAG]
//程序的本地化,引用国际化的文件
#define MyLocal(x, ...) NSLocalizedString(x, nil)

//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

//NSUserDefaults 实例化
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]


#define UserInfoData [DCUserInfo findAll].lastObject


//由角度获取弧度 有弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)



//单例化一个类
#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = ［self alloc] init]; \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
}

//----------------------其他----------------------------





//----------------------提示框----------------------------

//设置加载提示框（第三方框架：MBProgressHUD）
// 加载
#define kShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
// 收起加载
#define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
// 设置加载
#define NetworkActivityIndicatorVisible(x)  [UIApplication sharedApplication].networkActivityIndicatorVisible = x

//#define kWindow [UIApplication sharedApplication].keyWindow
#define kWindow \
    ({\
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;\
    while (1)\
    {\
    if ([vc isKindOfClass:[UITabBarController class]]) {\
        vc = ((UITabBarController*)vc).selectedViewController;\
    }\
    if ([vc isKindOfClass:[UINavigationController class]]) {\
        vc = ((UINavigationController*)vc).visibleViewController;\
    }\
    if (vc.presentedViewController) {\
        vc = vc.presentedViewController;\
    }else{\
        break;\
    }\
    }\
    (vc.view);\
    })


#define kBackView         for (UIView *item in kWindow.subviews) { \
if(item.tag == 10000) \
{ \
[item removeFromSuperview]; \
UIView * aView = [[UIView alloc] init]; \
aView.frame = [UIScreen mainScreen].bounds; \
aView.tag = 10000; \
aView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3]; \
[kWindow addSubview:aView]; \
} \
} \

#define kShowHUDAndActivity kBackView;[MBProgressHUD showHUDAddedTo:kWindow animated:YES];kShowNetworkActivityIndicator()

#define kHiddenHUD [MBProgressHUD hideAllHUDsForView:kWindow animated:YES]

#define kRemoveBackView         for (UIView *item in kWindow.subviews) { \
if(item.tag == 10000) \
{ \
[UIView animateWithDuration:0.4 animations:^{ \
item.alpha = 0.0; \
} completion:^(BOOL finished) { \
[item removeFromSuperview]; \
}]; \
} \
} \

#define kHiddenHUDAndAvtivity kRemoveBackView;kHiddenHUD;HideNetworkActivityIndicator()

//只显示hud
#define ShowHudOnly [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
#define HiddenHudOnly [MBProgressHUD hideHUDForView:kWindow animated:YES];




//设置加载提示框（第三方框架：Toast）
#define LRToast(str)              CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle]; \
[kWindow  makeToast:str duration:0.8 position:CSToastPositionCenter style:style];\
kWindow.userInteractionEnabled = NO; \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{\
kWindow.userInteractionEnabled = YES;\
});\



// View 圆角和加边框
#define LRViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]







//----------------------提示框----------------------------





//----------------------字符串是否为空----------------------------

#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO || [str isEqualToString:@"(null)"] ? YES : NO || [str isEqualToString:@"null"] ? YES : NO || [str isEqualToString:@"<null>"] ? YES : NO)

//----------------------字符串是否为空----------------------------

//----------------------返回安全的字符串----------------------------
#define GetSaveString(str) kStringIsEmpty(str)?@"":str

//----------------------返回安全的字符串空----------------------------



//----------------------数组是否为空----------------------------

#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

//----------------------数组是否为空----------------------------



//----------------------字典是否为空----------------------------

#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys.count == 0)

//----------------------字典是否为空----------------------------




//----------------------是否是空对象----------------------------

#define kObjectIsEmpty(_object) (_object == nil \|| [_object isKindOfClass:[NSNull class]] \|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

//----------------------是否是空对象----------------------------


//----------------------是否有银联支付----------------------------

#define ShowUPPay (0)

//----------------------是否有银联支付----------------------------

//----------------------是否跳转到查看物流列表界面----------------------------

#define PushToLogicListVC (1)

//----------------------是否有银联支付----------------------------

//通知名称
#define RefreshShoppingCartNewCommendGoodNotify @"RefreshShoppingCartNewCommendGoodNotify"









#endif /* CommonMacroDefinitions__h */




