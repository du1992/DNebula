// 颜色
#define AppColor(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define AppAlphaColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

/** *  十六进制颜色 */
#define UIColorFromRGBValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBValue_alpha(rgbValue,A) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:A]


//背景色
#define kColorControllerBackGround UIColorFromRGBValue(0xf5f7fb)
/** * 推荐颜色 AppAlphaColor(87, 164, 254, 1) AppColor(41,208, 197) */
#define RecommendedColor AppAlphaColor(87, 164, 254, 1)
/** * 警告颜色  UIColorFromRGBValue(0xfed259) */
#define WarningColor AppColor(251,140, 52) 
/** * 危险颜色 */
#define DangerousColor  AppColor(238,90, 139)
/** * 天空颜色 */
#define DSkyColor  AppColor(65, 188, 241) 
