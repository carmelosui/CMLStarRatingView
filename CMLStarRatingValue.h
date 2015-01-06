#import <Foundation/Foundation.h>

@interface CMLStarRatingValue : NSObject

@property (nonatomic, assign, readonly) NSInteger wholeStarCount;
@property (nonatomic, assign, readonly) BOOL hasHalfStar;

-(instancetype)initWithWholeStarCount:(NSInteger)wholeStarCount hasHalfStar:(BOOL)hasHalfStar;
-(BOOL)isEqualToRating:(CMLStarRatingValue*)value;

@end
