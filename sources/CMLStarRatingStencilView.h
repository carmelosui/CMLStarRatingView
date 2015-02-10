#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CMLStarRatingStencilViewRating) {
    CMLStarRatingStencilViewRatingNoInitialized,
    CMLStarRatingStencilViewRatingNone,
    CMLStarRatingStencilViewRatingHalf,
    CMLStarRatingStencilViewRatingWhole,
};

@interface CMLStarRatingStencilView : UIView

@property (nonatomic, assign) CMLStarRatingStencilViewRating rating;

-(instancetype)initWithNoneRatingImage:(UIImage*)noneRatingImage halfRatingImage:(UIImage*)halfRatingImage wholeRatingImage:(UIImage*)wholeRatingImage;
-(void)setSelectedStarTintColor:(UIColor*)color;
-(void)setUnSelectedStarTintColor:(UIColor*)color;

@end
