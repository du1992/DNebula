/*------------------------------图片------------------------------*/

#define WEAKSELF typeof(self) __weak weakSelf = self;
#define ImageNamed(name)  [UIImage imageNamed:name]
#define StringValue(name) [NSString stringWithFormat:@"%ld",name];


/** 代码切换语言 **/
#define Localized(key)  NSLocalizedString(key, nil)

//app商店
#define APPiTunesURL   @"https://itunes.apple.com/app/id1185429183"
#define appStoreAppID  @"1185429183"
