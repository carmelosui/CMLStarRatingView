#import "CMLStarRatingValue.h"

@implementation CMLStarRatingValue

-(instancetype)initWithWholeStarCount:(NSInteger)wholeStarCount hasHalfStar:(BOOL)hasHalfStar
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _wholeStarCount = wholeStarCount;
    _hasHalfStar = hasHalfStar;
    
    return self;
}

-(BOOL)isEqualToRating:(CMLStarRatingValue*)value
{
    if (self.wholeStarCount == value.wholeStarCount && self.hasHalfStar == value.hasHalfStar) {
        return YES;
    }
    return NO;
}

@end
