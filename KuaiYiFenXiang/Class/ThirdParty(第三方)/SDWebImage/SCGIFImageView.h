//
//  SCGIFImageView.h
//  TestGIF
//
//  Created by shichangone on 11-7-12.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

@interface SCGIFImageView : UIImageView {
  @private
    BOOL _isGifAnimating;
    NSInteger _currentImageIndex;
    NSUInteger _maxImageSize;
//    float _next_duration;
    CGImageSourceRef _gif_source;
}

@property (nonatomic,retain) NSTimer *timer;

//Setting this value to pause or continue animation;
- (void)setGifData:(NSData *)imageData;
@end
