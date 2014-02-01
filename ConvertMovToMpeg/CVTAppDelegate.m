//
//  CVTAppDelegate.m
//  ConvertMovToMpeg
//
//  Created by Tanaka Katsuma on 2014/02/01.
//  Copyright (c) 2014年 Katsuma Tanaka. All rights reserved.
//

#import "CVTAppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@implementation CVTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setCanChooseFiles:YES];
    [openPanel setAllowedFileTypes:@[@"mov"]];
    
    NSString *desktopPath = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) lastObject];
    [openPanel setDirectoryURL:[NSURL fileURLWithPath:desktopPath]];
    
    [openPanel beginSheetModalForWindow:[NSApp keyWindow]
                      completionHandler:^(NSInteger result) {
                          if (result == NSOKButton) {
                              NSString *selectedFilePath = [[[openPanel URLs] firstObject] path];
                              
                              // Convert mov to mp4
                              NSString *outputFilePath = [[selectedFilePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"mp4"];
                              NSURL *outputURL = [NSURL fileURLWithPath:outputFilePath];
                              
                              AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:selectedFilePath]];
                              AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:asset presetName:AVAssetExportPresetPassthrough];
                              
                              exportSession.outputURL = outputURL;
                              exportSession.outputFileType = AVFileTypeMPEG4;
                              exportSession.shouldOptimizeForNetworkUse = YES;
                              
                              [exportSession exportAsynchronouslyWithCompletionHandler:^{
                                  switch ([exportSession status]) {
                                      case AVAssetExportSessionStatusCompleted:
                                          NSLog(@"Completed.");
                                          break;
                                          
                                      case AVAssetExportSessionStatusFailed:
                                          NSLog(@"Failed.");
                                          break;
                                          
                                      case AVAssetExportSessionStatusCancelled:
                                          NSLog(@"Cancelled.");
                                          break;
                                          
                                      default:
                                          break;
                                  }
                                  
                                  [NSApp terminate:nil];
                              }];
                          } else {
                              [NSApp terminate:nil];
                          }
                      }];
}

@end
