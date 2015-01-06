#import <UIKit/UIKit.h>

#import "CMLStarRatingValue.h"

typedef NS_ENUM(NSUInteger, CMLStarRatingViewLayoutStrategy) {
    CMLStarRatingViewLayoutStrategyTryMaxSpacing = 1,     //use min left right margin, and maximize the spacing between stencils
    CMLStarRatingViewLayoutStrategyTryMinSpacing,     //use the min spacing between stencils, and maximize the left right margin
};

@interface CMLStarRatingView : UIView

typedef void(^CMLStarRatingViewRatingChangeCallback)(CMLStarRatingView*);

@property (nonatomic, assign, readonly) CGSize stencilViewSize;
@property (nonatomic, strong, readonly) NSArray *stencilViews;
@property (nonatomic, assign, readonly) CGFloat minStencilSpacing;
@property (nonatomic, assign, readonly) CGFloat minLeftRightMargin;
@property (nonatomic, assign, readonly) CGFloat layoutStrategy;

/**
 *  initialize a rating view
 *
 *  @param stencilViews       a array of CMLStarRatingStencilViews, they are the "stars" in rating. You can pass different looking stencils for every rating level. The array shouldn't contain two value with identical pointer address
 *  @param stencilSize        the size of the stencils
 *  @param minStencilSpacing  the min spacing between stencils
 *  @param minLeftRightMargin the margin to left and right
 *  @param strategy           layout strategy, see CMLStarRatingViewLayoutStrategy
 *  @param hitJudgerClass     hit test class, pass nil to use the default class, which is CMLStarRatingAreaJudger
 *
 *  @return
 */
-(instancetype)initWithStencilViews:(NSArray*)stencilViews stencilSize:(CGSize)stencilSize minStencilSpacing:(CGFloat)minStencilSpacing minLeftRightMargin:(CGFloat)minLeftRightMargin layoutStrategy:(CMLStarRatingViewLayoutStrategy)strategy hitJudgerClass:(Class)hitJudgerClass;

@property (nonatomic, assign, getter=isHalfRatingAllowed) BOOL halfRatingAllowed;
-(CMLStarRatingValue*)ratingValue;
-(void)setRatingValue:(CMLStarRatingValue*)ratingValue;

-(void)setValueChangeCallback:(CMLStarRatingViewRatingChangeCallback)block reportOnTouchEndOnly:(BOOL)reportOnTouchEndOnly;

@end
