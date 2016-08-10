//
//  CZCommonMacro.h
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/9.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#ifndef CZCommonMacro_h
#define CZCommonMacro_h



/** Device Frame*/
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenBounds ([UIScreen mainScreen].bounds)

/** color*/
#define kRGB(r, g, b) ([UIColor colorWithRed:(r)/255.0  green:(g)/255.0  blue:(b)/255.0  alpha:1])

#define kRGBA(r, g, b, a) ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0  blue:(b)/255.0  alpha:(a)])

#define k16RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue&0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]


#define kBlackColor       [UIColor blackColor]
#define kDarkGrayColor    [UIColor darkGrayColor]
#define kLightGrayColor   [UIColor lightGrayColor]
#define kWhiteColor       [UIColor whiteColor]
#define kRedColor         [UIColor redColor]
#define kBlueColor        [UIColor blueColor]
#define kGreenColor       [UIColor greenColor]
#define kCyanColor        [UIColor cyanColor]
#define kYellowColor      [UIColor yellowColor]
#define kMagentaColor     [UIColor magentaColor]
#define kOrangeColor      [UIColor orangeColor]
#define kPurpleColor      [UIColor purpleColor]
#define kBrownColor       [UIColor brownColor]
#define kClearColor       [UIColor clearColor]








#endif /* CZCommonMacro_h */
