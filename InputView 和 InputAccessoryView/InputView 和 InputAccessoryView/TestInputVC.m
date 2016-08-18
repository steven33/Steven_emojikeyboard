//
//  TestInputVC.m
//  InputView 和 InputAccessoryView
//
//  Created by qugo on 16/8/17.
//  Copyright © 2016年 steven. All rights reserved.
//

#import "TestInputVC.h"
#import "FaceBoard.h"
#import "LabelVC.h"
#define Kwidth [UIScreen mainScreen].bounds.size.width
#define Kheight [UIScreen mainScreen].bounds.size.height

@interface TestInputVC ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) FaceBoard *faceBoard;
@property (nonatomic, strong) UIToolbar *customAccessoryView;

@end
@implementation TestInputVC
{
    BOOL isKeyboard;
    BOOL isEmotionShow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self regiestNotifi];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
    self.textView.inputAccessoryView = self.customAccessoryView;
    
    
    //转字符
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [back setTitle:@"跳转" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(presentVC) forControlEvents:UIControlEventTouchUpInside];
    back.frame = CGRectMake(26, 44, 80, 28);
    [self.view addSubview:back];

}

- (void)presentVC{
    NSString *inputString = [self.textView.attributedText mgo_getPlainString];
    LabelVC *VC = [[LabelVC alloc] init];
    VC.labelStr = inputString;
    [self presentViewController:VC animated:YES completion:^{
        
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    isEmotionShow=NO;
    isKeyboard=NO;
}
- (void)switchBt:(UIBarButtonItem *)sender{
    if (!isEmotionShow) {
        [sender setTitle:@"Emotion"];
        isEmotionShow = YES;
        isKeyboard = NO;
        self.textView.inputView = self.faceBoard;
        [self.textView resignFirstResponder];
        
    }else{
        [sender setTitle:@"Keyboard"];
        isEmotionShow = NO;
        isKeyboard = YES;
        self.textView.inputView = nil;
        [self.textView resignFirstResponder];
        
    }
}
-(void)keyboardwillShow:(NSNotification *)notification{
    
}
-(void)keyboardwillHide:(NSNotification *)notification{
    
}

-(void)keyboardDidHide:(NSNotification *)notification{
    if (isEmotionShow||isKeyboard) {
        [self.textView becomeFirstResponder];
    }else{
        
    }
}

#pragma mark-createUI
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(50, 64, Kwidth - 100, 200)];
        _textView.layer.borderWidth = 1.0;
        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textView.layer.cornerRadius = 4.0;
    }
    return _textView;
}
- (UIToolbar *)customAccessoryView{
    if (!_customAccessoryView) {
        _customAccessoryView = [[UIToolbar alloc]initWithFrame:(CGRect){0,0,Kwidth,40}];
        _customAccessoryView.barTintColor = [UIColor orangeColor];
        UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *finish = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(switchBt:)];
        [_customAccessoryView setItems:@[space,space,finish]];
    }
    return _customAccessoryView;
}
- (FaceBoard *)faceBoard{
    if (!_faceBoard) {
        _faceBoard = [[FaceBoard alloc] init];
        _faceBoard.inputTextView = self.textView;
    }
    return _faceBoard;
}

- (void)regiestNotifi{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardwillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardwillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}


@end
