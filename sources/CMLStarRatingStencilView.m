#import "CMLStarRatingStencilView.h"

@interface CMLStarRatingStencilView ()

@property (nonatomic, strong) UIImageView *stencilImageView;

@property (nonatomic, strong) UIImage *noneRatingImage;
@property (nonatomic, strong) UIImage *halfRatingImage;
@property (nonatomic, strong) UIImage *wholeRatingImage;

@end

@implementation CMLStarRatingStencilView

-(instancetype)initWithNoneRatingImage:(UIImage *)noneRatingImage halfRatingImage:(UIImage *)halfRatingImage wholeRatingImage:(UIImage *)wholeRatingImage
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _noneRatingImage = noneRatingImage;
    _halfRatingImage = halfRatingImage;
    _wholeRatingImage = wholeRatingImage;
    
    self.stencilImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.stencilImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.stencilImageView];
    
    return self;
}

-(void)setRating:(CMLStarRatingStencilViewRating)rating
{
    if (_rating == rating) {
        return;
    }
    _rating = rating;
    
    UIImage *toUseImage = nil;
    switch (_rating) {
        case CMLStarRatingStencilViewRatingNone:
            toUseImage = self.noneRatingImage;
            break;
        case CMLStarRatingStencilViewRatingHalf:
            toUseImage = self.halfRatingImage;
            break;
        case CMLStarRatingStencilViewRatingWhole:
            toUseImage = self.wholeRatingImage;
            break;
            
        default:
            break;
    }
    
    self.stencilImageView.image = toUseImage;
}

@end
