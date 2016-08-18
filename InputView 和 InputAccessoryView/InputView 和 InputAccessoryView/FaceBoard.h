//
//  FaceBoard.h
//  InputView 和 InputAccessoryView
//
//  Created by qugo on 16/8/17.
//  Copyright © 2016年 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaceBoard : UIView<UIScrollViewDelegate>

@property (nonatomic, retain) UITextField *inputTextField;
@property (nonatomic, retain) UITextView *inputTextView;

@end
