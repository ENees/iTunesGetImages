//
//  main.m
//  iTunesGetImages
//
//  Created by Eckhard Nees on 18.02.16.
//  Copyright © 2016 Eckhard Nees. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iTunesLibrary/ITLibrary.h>
#import <iTunesLibrary/ITLibMediaItem.h>
#import <iTunesLibrary/ITLibArtwork.h>
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSError *error = nil;
        ITLibrary *library = [ITLibrary libraryWithAPIVersion:@"1.0" error:&error];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (library)
        {
            //NSArray *playlists = library.allPlaylists; //  <- NSArray of ITLibPlaylist
            NSArray *tracks = library.allMediaItems; //  <- NSArray of ITLibMediaItem
            [tracks enumerateObjectsUsingBlock:^(ITLibMediaItem*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.artworkAvailable) {
                    ITLibArtwork* artWork=obj.artwork;
                    //NSData* d=artWork.imageData;
                    switch (artWork.imageDataFormat) {
                        case ITLibArtworkFormatPNG:{
                            NSURL* fileURL=obj.location;
                            NSString* fs=fileURL.lastPathComponent;
                            NSString* path=[fileURL.path stringByReplacingOccurrencesOfString:fs withString:@"Folder.png"];
                            if (![fileManager fileExistsAtPath:path]){
                                [artWork.imageData writeToFile:path atomically:YES];
                            }
                        }
                            break;
                        case ITLibArtworkFormatJPEG:{
                            NSURL* fileURL=obj.location;
                            NSString* fs=fileURL.lastPathComponent;
                            NSString* path=[fileURL.path stringByReplacingOccurrencesOfString:fs withString:@"Folder.jpg"];
                            if (![fileManager fileExistsAtPath:path]){
                                [artWork.imageData writeToFile:path atomically:YES];
                            }
                        }
                            break;
                        default:
                            break;
                    }
                }
            }];
            NSLog(@"End reached");
        }
    }
    return 0;
}
