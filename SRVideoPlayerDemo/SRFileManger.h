//
//  SRFileManger.h
//  SRVideoPlayerDemo
//
//  Created by longrise on 2019/1/15.
//  Copyright © 2019 longrise. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SRDefaultFileManager

NS_ASSUME_NONNULL_BEGIN

@interface SRFileManger : NSObject

/**
 获取Document路径

 @return Document路径
 */
+ (NSString *)getDocumentPath;

/**
 获取Library路径

 @return Library路径
 */
+ (NSString *)getLibraryPath;

/**
 获取Application路径
 
 @return Application路径
 */
+ (NSString *)getApplicationPath;

/**
 获取Cache路径
 
 @return Cache路径
 */
+ (NSString *)getCachePath;

/**
 获取Temp路径
 
 @return Temp路径
 */
+ (NSString *)getTempPath;

/**
 判断文件是否存在于某个路径中

 @param filePath 文件路径
 @return YES or No
 */
+ (BOOL)fileIsExistOfPath:(NSString *)filePath;

/**
 //从某个路径中移除文件

 @param filePath 文件路径
 @return YES or No
 */
+ (BOOL)removeFileOfPath:(NSString *)filePath;

/**
 从URL路径中移除文件

 @param fileURL 文件URL
 @return YES or No
 */
+ (BOOL)removeFileOfURL:(NSURL *)fileURL;

/**
 创建文件路径

 @param dirPath 文件路径
 @return YES or No
 */
+ (BOOL)creatDirectoryWithPath:(NSString *)dirPath;

/**
 保存文件

 @param filePath 文件路径
 @param data 数据
 @return YES or No
 */
+ (BOOL)saveFile:(NSString *)filePath withData:(NSData *)data;

/**
 追加写文件

 @param data data
 @param path path
 @return YES or No
 */
+ (BOOL)appendData:(NSData *)data withPath:(NSString *)path;

/**
 获取文件

 @param filePath filePath
 @return data
 */
+ (NSData *)getFileData:(NSString *)filePath;

/**
 读取文件

 @param filePath filePath
 @param startIndex startIndex
 @param length startIndex
 @return data
 */
+ (NSData *)getFileData:(NSString *)filePath startIndex:(long long)startIndex length:(NSInteger)length;

/**
 移动文件

 @param fromPath fromPath
 @param toPath toPath
 @return YES or No
 */
+ (BOOL)moveFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath;

/**
 拷贝文件

 @param fromPath fromPath
 @param toPath toPath
 @return YES or No
 */
+ (BOOL)copyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath;

/**
 获取文件夹下文件列表

 @param path path
 @return 文件列表
 */
+ (NSArray *)getFileListInFolderWithPath:(NSString *)path;

/**
 获取文件大小

 @param path path
 @return size
 */
+ (long long)getFileSizeWithPath:(NSString *)path;

/**
 获取文件创建时间

 @param path path
 @return 文件创建时间
 */
+ (NSString *)getFileCreatDateWithPath:(NSString *)path;

/**
 获取文件所有者

 @param path path
 @return 文件所有者
 */
+ (NSString *)getFileOwnerWithPath:(NSString *)path;


/**
 获取文件更改日期

 @param path path
 @return 文件更改日期
 */
+ (NSString *)getFileChangeDateWithPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
