//
//  ViewController.m
//  InputView 和 InputAccessoryView
//
//  Created by qugo on 16/8/17.
//  Copyright © 2016年 steven. All rights reserved.
//

#import "ViewController.h"
#import "TestInputVC.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds

@interface ViewController ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *customInputView;
@property (nonatomic, strong) UIToolbar *customAccessoryView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self.view addSubview:self.textField];
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(50, 100, SCREEN_BOUNDS.size.width - 100, 30)];
        _textField.layer.borderWidth = 1.0;
        _textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textField.layer.cornerRadius = 4.0;
        _textField.placeholder = @"测试";
        _textField.inputView = self.customInputView;
        _textField.inputAccessoryView = self.customAccessoryView;
    }
    return _textField;
}

- (UIView *)customInputView{
    if (!_customInputView) {
        _customInputView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.size.width, 220)];
        _customInputView.backgroundColor = [UIColor lightGrayColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, SCREEN_BOUNDS.size.width, 40)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"自定义inputView";
        [_customInputView addSubview:label];
    }
    return _customInputView;
}

- (UIToolbar *)customAccessoryView{
    if (!_customAccessoryView) {
        _customAccessoryView = [[UIToolbar alloc]initWithFrame:(CGRect){0,0,SCREEN_BOUNDS.size.width,40}];
        _customAccessoryView.barTintColor = [UIColor orangeColor];
        UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *finish = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
        [_customAccessoryView setItems:@[space,space,finish]];
    }
    return _customAccessoryView;
}

- (void)done{
    [self presentViewController:[[TestInputVC alloc] init] animated:YES completion:nil];

//    [self.textField resignFirstResponder];
    
}



@end
