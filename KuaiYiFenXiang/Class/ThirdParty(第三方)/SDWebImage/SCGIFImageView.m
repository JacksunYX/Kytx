//
//  SCGIFImageView.m
//  TestGIF
//
//  Created by shichangone on 11-7-12.
//

#import "SCGIFImageView.h"

@interface SCGIFImageView()
@end

@implementation SCGIFImageView
@synthesize timer = _timer;

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
    if (_gif_source) {CFRelease(_gif_source);}
   // [super dealloc];
}

// return next time
- (float)setGifImageAtIndex:(int)index
{
    if (index < _maxImageSize) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(_gif_source, index, NULL);
        CFDictionaryRef frameProperties = CGImageSourceCopyPropertiesAtIndex(_gif_source, index, NULL);
        CFDictionaryRef gifProperties = CFDictionaryGetValue(frameProperties, kCGImagePropertyGIFDictionary);
        float next_duration = [(id)CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFDelayTime) doubleValue];
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        CFRelease(frameProperties);
        CFRelease(imageRef);
        self.image = image;
        return next_duration;
    }
    return 0;
}

- (void)autoNextGifImage
{
    if (_isGifAnimating) {
        float duration = 0;
        duration = [self setGifImageAtIndex:_currentImageIndex];
        if (1 < _maxImageSize) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(autoNextGifImage) userInfo:nil repeats:NO];
        }
        ++ _currentImageIndex;
        if (_currentImageIndex >= _maxImageSize) {
            _currentImageIndex = 0;
        }
    }
}

- (void)startAnimating
{
    if (_gif_source && 0 < _maxImageSize) {
        if (!_isGifAnimating) {
            _isGifAnimating = YES;
            [self autoNextGifImage];
        }
    }
    else {
        [super startAnimating];
    }
}

- (void)stopAnimating
{
    [super stopAnimating];
    [self.timer invalidate];
    self.timer = nil;
    _isGifAnimating = NO;
}

- (void)setGifData:(NSData *)imageData
{
    if (!imageData) {
        return;
    }
    
    _maxImageSize = 0;
    _currentImageIndex = 0;
    if (_gif_source) { CFRelease(_gif_source); _gif_source = NULL; }
    
    _gif_source = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
    if (_gif_source) {
        _maxImageSize = CGImageSourceGetCount(_gif_source);
    }
    
    [self startAnimating];
    
}

@end
