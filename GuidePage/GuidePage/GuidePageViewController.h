//
//  GuidePageViewController.h
//  GuidePage
//
//  Created by 陈阳阳 on 2017/6/16.
//  Copyright © 2017年 cyy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FinishHandler) ();

@interface GuidePageViewController : UIViewController

- (instancetype)initWithImageArray:(NSArray *)imageArray FinishHandler:(FinishHandler)handler;

@end
