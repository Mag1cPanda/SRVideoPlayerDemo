//
//  SRGCDTimerManager.m
//  baobaotong
//
//  Created by longrise on 2018/10/24.
//  Copyright © 2018 zzy. All rights reserved.
//

#import "SRGCDTimerManager.h"

#define BIWeakObj(o)   @autoreleasepool {} __weak typeof(o) o ## Weak = o;
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

@interface SRGCDTimerManager ()

@property (nonatomic, strong) NSMutableDictionary *timerDic;
@property (nonatomic, strong) NSMutableDictionary *timerActionBlockCacheDic;

@end

@implementation SRGCDTimerManager

+(SRGCDTimerManager *)sharedInstance
{
    static SRGCDTimerManager *mgr = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = SRGCDTimerManager.new;
    });
    return mgr;
}

#pragma mark - Public
-(void)scheduleGCDTimerWithName:(NSString *)timerName
                       interval:(double)interval
                          queue:(dispatch_queue_t)queue
                        repeats:(BOOL)repeats
                         option:(TimerActionOption)option
                         action:(dispatch_block_t)action
{
    if (kStringIsEmpty(timerName)) {
        return;
    }
    
    // timer将被放入的队列queue，也就是最终action执行的队列。传入nil将自动放到一个全局子线程队列中
    if (!queue) {
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    
    // 创建dispatch_source_t的timer
    dispatch_source_t timer = self.timerDic[timerName];
    if (!timer) {
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_resume(timer);
        [self.timerDic setObject:timer forKey:timerName];
    }
    
    // 设置首次执行事件、执行间隔和精确度(默认为0.1s)
    //DISPATCH_TIME_NOW
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    
    BIWeakObj(self)
    // 取消上一次timer任务
    if (option == CancelPreviousTimerAction) {
        [self removeActionCacheForTimer:timerName];
        
        dispatch_source_set_event_handler(timer, ^{
            action();
            
            if (!repeats) {
                [selfWeak cancelTimerWithName:timerName];
            }
        });
    }
    // 合并上一次timer任务
    else if (option == MergePreviousTimerAction) {
        [self cacheAction:action forTimer:timerName];
        
        dispatch_source_set_event_handler(timer, ^{
           
            NSMutableArray *actionArr = self.timerActionBlockCacheDic[@"timerName"];
            
            [actionArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                dispatch_block_t actionBlock = obj;
                actionBlock();
            }];
            
            [selfWeak removeActionCacheForTimer:timerName];
            
            if (!repeats) {
                [selfWeak cancelTimerWithName:timerName];
            }
        });
    }
    
   
}

-(void)cancelTimerWithName:(NSString *)timerName
{
    dispatch_source_t timer = self.timerDic[timerName];
    
    if (!timer) {
        return;
    }
    
    [self.timerDic removeObjectForKey:timerName];
    [self.timerActionBlockCacheDic removeObjectForKey:timerName];
    dispatch_source_cancel(timer);
}

#pragma mark - Private
- (void)cacheAction:(dispatch_block_t)action forTimer:(NSString *)timerName
{
    id actionArray = self.timerActionBlockCacheDic[timerName];
    if (actionArray && [actionArray isKindOfClass:NSMutableArray.class]) {
        [(NSMutableArray *)actionArray addObject:action];
    } else {
        NSMutableArray *mArr = [NSMutableArray arrayWithObject:action];
        [self.timerActionBlockCacheDic setObject:mArr forKey:timerName];
    }
}

- (void)removeActionCacheForTimer:(NSString *)timerName
{
    if (!self.timerActionBlockCacheDic[timerName]) {
        return;
    }
    
    [self.timerActionBlockCacheDic removeObjectForKey:timerName];
}

#pragma mark - Lazy
-(NSMutableDictionary *)timerDic
{
    if (!_timerDic) {
        _timerDic = NSMutableDictionary.dictionary;
    }
    return _timerDic;
}

-(NSMutableDictionary *)timerActionBlockCacheDic
{
    if (!_timerActionBlockCacheDic) {
        _timerActionBlockCacheDic = NSMutableDictionary.dictionary;
    }
    return _timerActionBlockCacheDic;
}



@end
