/***  屏幕大小  */
#define kWindow [UIApplication sharedApplication].keyWindow
#define kScreenBounds [[UIScreen mainScreen] bounds]
#define kScreenWidth kScreenBounds.size.width
#define kScreenHeight kScreenBounds.size.height



// iPhone机型
#define IS_iPhone5s_Before ((kScreenWidth == 320) ? YES : NO)
#define IS_iPhone6s_Later ((kScreenWidth == 375) ? YES : NO)
#define IS_iPhone6sPlus_Later ((kScreenWidth == 414) ? YES : NO)
#define IS_iPhoneX ((kScreenWidth == 375 && kScreenWidth == 812) ? YES : NO)

// 屏幕判定
#define IS_IPHONE35INCH  ([SDiPhoneVersion deviceSize] == iPhone35inch ? YES : NO)//4, 4S
#define IS_IPHONE4INCH  ([SDiPhoneVersion deviceSize] == iPhone4inch ? YES : NO)//5, 5C, 5S, SE
#define IS_IPHONE47INCH  ([SDiPhoneVersion deviceSize] == iPhone47inch ? YES : NO)//6, 6S, 7
#define IS_IPHONE55INCH ([SDiPhoneVersion deviceSize] == iPhone55inch ? YES : NO)//6P, 6SP, 7P
#define iPhoneX (kScreenHeight >= 812.0 ? YES : NO)

/**
 适配 给定4.7寸屏尺寸，适配4和5.5寸屏尺寸
 */
#define Suit55Inch           1.104
#define Suit4Inch            1.171875


// iPhone版本
#define IS_iOS11_Later (([[UIDevice currentDevice].systemVersion floatValue] >= 11.0) ? YES : NO)

// 系统性参数
#define SYS_StatusBar_HEIGHT ((!IS_iPhoneX) ? 20 : SYS_SafeArea_TOP)
#define SYS_NavigationBar_HEIGHT (SYS_StatusBar_HEIGHT+44)
#define SYS_Toolbar_HEIGHT 44
#define SYS_TabBar_HEIGHT ((!IS_iPhoneX) ? 49 : (49+SYS_SafeArea_BOTTOM))
#define SYS_Spacing_HEIGHT 8

#define SYS_SafeArea_TOP ((IS_iPhoneX) ? 44 : 0)
#define SYS_SafeArea_BOTTOM ((IS_iPhoneX) ? 34 : 0)


// 字体
#define AppFont(x)     [UIFont systemFontOfSize:x]
#define AppBoldFont(x) [UIFont boldSystemFontOfSize:x]


//图标大小
#define kClassificationIconWidth kScreenWidth/4
