//
//  WViewController.m
//  WProgressHUD
//
//  Created by winterWD on 05/03/2017.
//  Copyright (c) 2017 winterWD. All rights reserved.
//

#import "WViewController.h"
#import "WProgressHUD.h"

@interface WExample : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) SEL selector;
@end

@implementation WExample
+ (instancetype)exampleWithTitle:(NSString *)title selector:(SEL)selector {
    WExample *example = [[self class] new];
    example.title = title;
    example.selector = selector;
    return example;
}
@end

@interface WViewController ()
@property (nonatomic, strong) NSArray<NSArray<WExample *> *> *examples;
@end

@implementation WViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.examples = @[
                      @[[WExample exampleWithTitle:@"默认转圈显示正在加载" selector:@selector(exampleDefault)],
                        [WExample exampleWithTitle:@"默认转圈+自定义文字" selector:@selector(exampleCustomText)],
                        [WExample exampleWithTitle:@"默认转圈，不显示文字" selector:@selector(exampleDefaultNoText)]],
                      
                      @[[WExample exampleWithTitle:@"自定义gif+文字" selector:@selector(exampleCustomGifText)],
                        [WExample exampleWithTitle:@"自定义gif不带文字带背景" selector:@selector(exampleCustomGifNoTip)],
                        [WExample exampleWithTitle:@"自定义gif不带文字透明背景" selector:@selector(exampleCustomOnlyGif)]],
                      
                      @[[WExample exampleWithTitle:@"显示success状态" selector:@selector(exampleShowSuccess)],
                        [WExample exampleWithTitle:@"显示success状态+文字" selector:@selector(exampleShowSuccessText)],
                        [WExample exampleWithTitle:@"显示success状态+文字+延时回调" selector:@selector(exampleShowSuccessTextDelay)],
                        [WExample exampleWithTitle:@"显示failed状态" selector:@selector(exampleShowFailed)],
                        [WExample exampleWithTitle:@"显示failed状态+文字" selector:@selector(exampleShowFailedText)],
                        [WExample exampleWithTitle:@"显示failed状态+文字+延时回调" selector:@selector(exampleShowFailedTextDelay)],
                        [WExample exampleWithTitle:@"显示info状态+文字" selector:@selector(exampleShowInfoText)],
                        [WExample exampleWithTitle:@"显示info状态+文字+延时回调" selector:@selector(exampleShowInfoTextDelay)]],
                      
                      @[[WExample exampleWithTitle:@"只显示文字（屏幕顶部）" selector:@selector(exampleOnlyTextTop)],
                        [WExample exampleWithTitle:@"只显示文字（屏幕中心）" selector:@selector(exampleOnlyTextCenter)],
                        [WExample exampleWithTitle:@"只显示文字（屏幕底部）" selector:@selector(exampleOnlyTextBottom)]],
                      
                      @[[WExample exampleWithTitle:@"自定义image+文字" selector:@selector(exampleCustomImageText)],
                        [WExample exampleWithTitle:@"自定义image不带文字带背景" selector:@selector(exampleCustomImageNoTip)],
                        [WExample exampleWithTitle:@"自定义image不带文字透明背景" selector:@selector(exampleCustomOnlyImage)]]
                      ];
}

#pragma mark - example

- (void)exampleDefault {
    [self.view beginLoading];
    [self doSomeWork:^{
        [self.view endLoading];
    }];
}

- (void)exampleCustomText {
    [self.view beginLoadingWithTip:@"自定义文字..."];
    [self doSomeWork:^{
        [self.view endLoading];
    }];
}

- (void)exampleDefaultNoText {
    [self.view beginNoTipLoading];
    [self doSomeWork:^{
        [self.view endLoading];
    }];
}

- (void)exampleCustomImageText {
    [self.view beginImageLoadingWithTip:@"正在加载..."];
    [self doSomeWork:^{
        [self.view endLoading];
    }];
}

- (void)exampleCustomImageNoTip {
    [self.view beginImageNoTipLoading];
    [self doSomeWork:^{
        [self.view endLoading];
    }];
}

- (void)exampleCustomOnlyImage {
    [self.view beginOnlyImageLoading];
    [self doSomeWork:^{
        [self.view endLoading];
    }];
}

- (void)exampleCustomGifText {
    [self.view beginGifLoadingWithTip:@"正在加载..."];
    [self doSomeWork:^{
        [self.view endLoading];
    }];
}

- (void)exampleCustomGifNoTip {
    [self.view beginGifNoTipLoading];
    [self doSomeWork:^{
        [self.view endLoading];
    }];
}

- (void)exampleCustomOnlyGif {
    [self.view beginOnlyGifLoading];
    [self doSomeWork:^{
        [self.view endLoading];
    }];
}

- (void)exampleShowSuccess {
    [WToast showSuccess];
}

- (void)exampleShowSuccessText {
    [WToast showSuccessWithTip:@"显示success状态+文字"];
}

- (void)exampleShowSuccessTextDelay {
    [WToast showSuccessWithTip:@"显示success状态\n文字+延时回调" delayDismiss:2 completion:^{
        [WToast showToast:@"这是一个延时回调!"];
    }];
}

- (void)exampleShowFailed {
    [WToast showFailed];
}

- (void)exampleShowFailedText {
    [WToast showFailedWithTip:@"显示Failed状态+文字"];
}

- (void)exampleShowFailedTextDelay {
    [WToast showFailedWithTip:@"显示Failed状态\n文字+延时回调" delayDismiss:2 completion:^{
        [WToast showToast:@"这是一个延时回调!"];
    }];
}

- (void)exampleShowInfoText {
    [WToast showInfoWithTip:@"显示Info状态+文字"];
}

- (void)exampleShowInfoTextDelay {
    [WToast showInfoWithTip:@"显示Info状态\n文字+延时回调" delayDismiss:2 completion:^{
        [WToast showToast:@"这是一个延时回调!"];
    }];
}

- (void)exampleOnlyTextTop {
    [WToast showTopToast:@"这是一个顶部Toast!\n这是一个顶部Toast!"];
}

- (void)exampleOnlyTextCenter {
    [WToast showToast:@"这是一个默认Toast!\n这是一个默认Toast!"];
}

- (void)exampleOnlyTextBottom {
    [WToast showBottomToast:@"这是一个底部Toast!\n这是一个底部Toast!"];
}

- (void)doSomeWork:(void(^)(void))block {
    // 模拟等待
    double delaySeconds = 2;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        if (block) {
            block();
        }
    });
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.examples.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.examples[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WExample *example = self.examples[indexPath.section][indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExampleCell" forIndexPath:indexPath];
    cell.textLabel.text = example.title;
    cell.textLabel.textColor = self.view.tintColor;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WExample *example = self.examples[indexPath.section][indexPath.row];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:example.selector];
#pragma clang diagnostic pop
}

@end
