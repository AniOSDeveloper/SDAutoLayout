//
//  UIView+SDAutoLayout.m
//
//  Created by gsd on 15/10/6.
//  Copyright (c) 2015年 gsd. All rights reserved.
//

/*
 
 *********************************************************************************
 *                                                                                *
 * 在您使用此自动布局库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并  *
 * 帮您解决问题。                                                                    *
 * QQ    : 2689718696(gsdios)                                                      *
 * Email : gsdios@126.com                                                          *
 * GitHub: https://github.com/gsdios                                               *
 * 新浪微博:GSD_iOS                                                                 *
 *                                                                                *
 *********************************************************************************
 
 */

#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

#import <objc/runtime.h>

@interface SDAutoLayoutModel ()

@property (nonatomic, strong) SDAutoLayoutModelItem *width;
@property (nonatomic, strong) SDAutoLayoutModelItem *height;
@property (nonatomic, strong) SDAutoLayoutModelItem *left;
@property (nonatomic, strong) SDAutoLayoutModelItem *top;
@property (nonatomic, strong) SDAutoLayoutModelItem *right;
@property (nonatomic, strong) SDAutoLayoutModelItem *bottom;
@property (nonatomic, strong) NSNumber *centerX;
@property (nonatomic, strong) NSNumber *centerY;

@property (nonatomic, strong) NSNumber *maxWidth;
@property (nonatomic, strong) NSNumber *maxHeight;
@property (nonatomic, strong) NSNumber *minWidth;
@property (nonatomic, strong) NSNumber *minHeight;

@property (nonatomic, strong) SDAutoLayoutModelItem *ratio_width;
@property (nonatomic, strong) SDAutoLayoutModelItem *ratio_height;
@property (nonatomic, strong) SDAutoLayoutModelItem *ratio_left;
@property (nonatomic, strong) SDAutoLayoutModelItem *ratio_top;
@property (nonatomic, strong) SDAutoLayoutModelItem *ratio_right;
@property (nonatomic, strong) SDAutoLayoutModelItem *ratio_bottom;

@property (nonatomic, strong) SDAutoLayoutModelItem *equalLeft;
@property (nonatomic, strong) SDAutoLayoutModelItem *equalRight;
@property (nonatomic, strong) SDAutoLayoutModelItem *equalTop;
@property (nonatomic, strong) SDAutoLayoutModelItem *equalBottom;
@property (nonatomic, strong) SDAutoLayoutModelItem *equalCenterX;
@property (nonatomic, strong) SDAutoLayoutModelItem *equalCenterY;

@end

@implementation SDAutoLayoutModel

@synthesize leftSpaceToView = _leftSpaceToView;
@synthesize rightSpaceToView = _rightSpaceToView;
@synthesize topSpaceToView = _topSpaceToView;
@synthesize bottomSpaceToView = _bottomSpaceToView;
@synthesize widthIs = _widthIs;
@synthesize heightIs = _heightIs;
@synthesize widthRatioToView = _widthRatioToView;
@synthesize heightRatioToView = _heightRatioToView;
@synthesize leftEqualToView = _leftEqualToView;
@synthesize rightEqualToView = _rightEqualToView;
@synthesize topEqualToView = _topEqualToView;
@synthesize bottomEqualToView = _bottomEqualToView;
@synthesize centerXEqualToView = _centerXEqualToView;
@synthesize centerYEqualToView = _centerYEqualToView;
@synthesize xIs = _xIs;
@synthesize yIs = _yIs;
@synthesize centerXIs = _centerXIs;
@synthesize centerYIs = _centerYIs;
@synthesize autoHeightRatio = _autoHeightRatio;
@synthesize spaceToSuperView = _spaceToSuperView;
@synthesize maxWidthIs = _maxWidthIs;
@synthesize maxHeightIs = _maxHeightIs;
@synthesize minWidthIs = _minWidthIs;
@synthesize minHeightIs = _minHeightIs;

- (MarginToView)leftSpaceToView
{
    if (!_leftSpaceToView) {
        _leftSpaceToView = [self marginToViewblockWithKey:@"left"];
    }
    return _leftSpaceToView;
}

- (MarginToView)rightSpaceToView
{
    if (!_rightSpaceToView) {
        _rightSpaceToView = [self marginToViewblockWithKey:@"right"];
    }
    return _rightSpaceToView;
}

- (MarginToView)topSpaceToView
{
    if (!_topSpaceToView) {
        _topSpaceToView = [self marginToViewblockWithKey:@"top"];
    }
    return _topSpaceToView;
}

- (MarginToView)bottomSpaceToView
{
    if (!_bottomSpaceToView) {
        _bottomSpaceToView = [self marginToViewblockWithKey:@"bottom"];
    }
    return _bottomSpaceToView;
}

- (MarginToView)marginToViewblockWithKey:(NSString *)key
{
    __weak typeof(self) weakSelf = self;
    return ^(UIView *view, CGFloat value) {
        SDAutoLayoutModelItem *item = [SDAutoLayoutModelItem new];
        item.value = @(value);
        item.refView = view;
        [weakSelf setValue:item forKey:key];
        return weakSelf;
    };
}

- (WidthHeight)widthIs
{
    if (!_widthIs) {
        __weak typeof(self) weakSelf = self;
        _widthIs = ^(CGFloat value) {
            weakSelf.needsAutoResizeView.width = value;
            weakSelf.needsAutoResizeView.fixedWith = @(value);
            return weakSelf;
        };
    }
    return _widthIs;
}

- (WidthHeight)heightIs
{
    if (!_heightIs) {
        __weak typeof(self) weakSelf = self;
        _heightIs = ^(CGFloat value) {
            weakSelf.needsAutoResizeView.height = value;
            weakSelf.needsAutoResizeView.fixedHeight = @(value);
            return weakSelf;
        };
    }
    return _heightIs;
}

- (WidthHeightEqualToView)widthRatioToView
{
    if (!_widthRatioToView) {
        __weak typeof(self) weakSelf = self;
        _widthRatioToView = ^(UIView *view, CGFloat value) {
            weakSelf.ratio_width = [SDAutoLayoutModelItem new];
            weakSelf.ratio_width.value = @(value);
            weakSelf.ratio_width.refView = view;
            return weakSelf;
        };
    }
    return _widthRatioToView;
}

- (WidthHeightEqualToView)heightRatioToView
{
    if (!_heightRatioToView) {
        __weak typeof(self) weakSelf = self;
        _heightRatioToView = ^(UIView *view, CGFloat value) {
            weakSelf.ratio_height = [SDAutoLayoutModelItem new];
            weakSelf.ratio_height.refView = view;
            weakSelf.ratio_height.value = @(value);
            return weakSelf;
        };
    }
    return _heightRatioToView;
}

- (WidthHeight)maxWidthIs
{
    if (!_maxWidthIs) {
        _maxWidthIs = [self limitingWidthHeightWithKey:@"maxWidth"];
    }
    return _maxWidthIs;
}

- (WidthHeight)maxHeightIs
{
    if (!_maxHeightIs) {
        _maxHeightIs = [self limitingWidthHeightWithKey:@"maxHeight"];
    }
    return _maxHeightIs;
}

- (WidthHeight)minWidthIs
{
    if (!_minWidthIs) {
        _minWidthIs = [self limitingWidthHeightWithKey:@"minWidth"];
    }
    return _minWidthIs;
}

- (WidthHeight)minHeightIs
{
    if (!_minHeightIs) {
        _minHeightIs = [self limitingWidthHeightWithKey:@"minHeight"];
    }
    return _minHeightIs;
}


- (WidthHeight)limitingWidthHeightWithKey:(NSString *)key
{
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat value) {
        [weakSelf setValue:@(value) forKey:key];
        
        return weakSelf;
    };
}


- (MarginEqualToView)marginEqualToViewBlockWithKey:(NSString *)key
{
    __weak typeof(self) weakSelf = self;
    
    return ^(UIView *view) {
        SDAutoLayoutModelItem *item = [SDAutoLayoutModelItem new];
        item.refView = view;
        [weakSelf setValue:item forKey:key];
        return weakSelf;
    };
}

- (MarginEqualToView)leftEqualToView
{
    if (!_leftEqualToView) {
        _leftEqualToView = [self marginEqualToViewBlockWithKey:@"equalLeft"];
    }
    return _leftEqualToView;
}

- (MarginEqualToView)rightEqualToView
{
    if (!_rightEqualToView) {
        _rightEqualToView = [self marginEqualToViewBlockWithKey:@"equalRight"];
    }
    return _rightEqualToView;
}

- (MarginEqualToView)topEqualToView
{
    if (!_topEqualToView) {
        _topEqualToView = [self marginEqualToViewBlockWithKey:@"equalTop"];
    }
    return _topEqualToView;
}

- (MarginEqualToView)bottomEqualToView
{
    if (!_bottomEqualToView) {
        _bottomEqualToView = [self marginEqualToViewBlockWithKey:@"equalBottom"];
    }
    return _bottomEqualToView;
}

- (MarginEqualToView)centerXEqualToView
{
    if (!_centerXEqualToView) {
        _centerXEqualToView = [self marginEqualToViewBlockWithKey:@"equalCenterX"];
    }
    return _centerXEqualToView;
}

- (MarginEqualToView)centerYEqualToView
{
    if (!_centerYEqualToView) {
        _centerYEqualToView = [self marginEqualToViewBlockWithKey:@"equalCenterY"];
    }
    return _centerYEqualToView;
}


- (Margin)marginBlockWithKey:(NSString *)key
{
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat value) {
        
        if ([key isEqualToString:@"x"]) {
            weakSelf.needsAutoResizeView.left = value;
        } else if ([key isEqualToString:@"y"]) {
            weakSelf.needsAutoResizeView.top = value;
        } else if ([key isEqualToString:@"centerX"]) {
            weakSelf.centerX = @(value);
        } else if ([key isEqualToString:@"centerY"]) {
            weakSelf.centerY = @(value);
        }
        
        return weakSelf;
    };
}

- (Margin)xIs
{
    if (!_xIs) {
        _xIs = [self marginBlockWithKey:@"x"];
    }
    return _xIs;
}

- (Margin)yIs
{
    if (!_yIs) {
        _yIs = [self marginBlockWithKey:@"y"];
    }
    return _yIs;
}

- (Margin)centerXIs
{
    if (!_centerXIs) {
        _centerXIs = [self marginBlockWithKey:@"centerX"];
    }
    return _centerXIs;
}

- (Margin)centerYIs
{
    if (!_centerYIs) {
        _centerYIs = [self marginBlockWithKey:@"centerY"];
    }
    return _centerYIs;
}

- (AutoHeight)autoHeightRatio
{
    __weak typeof(self) weakSelf = self;
    
    if (!_autoHeightRatio) {
        _autoHeightRatio = ^(CGFloat ratioaValue) {
            weakSelf.needsAutoResizeView.autoHeightRatioValue = @(ratioaValue);
            return weakSelf;
        };
    }
    return _autoHeightRatio;
}

- (SpaceToSuperView)spaceToSuperView
{
    __weak typeof(self) weakSelf = self;
    
    if (!_spaceToSuperView) {
        _spaceToSuperView = ^(UIEdgeInsets insets) {
            UIView *superView = weakSelf.needsAutoResizeView.superview;
            if (superView) {
                weakSelf.needsAutoResizeView.sd_layout
                .leftSpaceToView(superView, insets.left)
                .topSpaceToView(superView, insets.top)
                .rightSpaceToView(superView, insets.right)
                .bottomSpaceToView(superView, insets.bottom);
            }
        };
    }
    return _spaceToSuperView;
}

@end


@implementation UIView (SDAutoHeight)

- (void)setupAutoHeightWithBottomView:(UIView *)bottomView bottomMargin:(CGFloat)bottomMargin
{
    self.sd_bottomView = bottomView;
    self.sd_bottomViewBottomMargin = bottomMargin;
}

- (CGFloat)autoHeight
{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setAutoHeight:(CGFloat)autoHeight
{
    objc_setAssociatedObject(self, @selector(autoHeight), @(autoHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)sd_bottomView
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSd_bottomView:(UIView *)sd_bottomView
{
    objc_setAssociatedObject(self, @selector(sd_bottomView), sd_bottomView, OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)sd_bottomViewBottomMargin
{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setSd_bottomViewBottomMargin:(CGFloat)sd_bottomViewBottomMargin
{
    objc_setAssociatedObject(self, @selector(sd_bottomViewBottomMargin), @(sd_bottomViewBottomMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIView (SDLayoutExtention)

- (NSNumber *)sd_cornerRadius
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSd_cornerRadius:(NSNumber *)sd_cornerRadius
{
    objc_setAssociatedObject(self, @selector(sd_cornerRadius), sd_cornerRadius, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSNumber *)sd_cornerRadiusFromWidthRatio
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSd_cornerRadiusFromWidthRatio:(NSNumber *)sd_cornerRadiusFromWidthRatio
{
    objc_setAssociatedObject(self, @selector(sd_cornerRadiusFromWidthRatio), sd_cornerRadiusFromWidthRatio, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSNumber *)sd_cornerRadiusFromHeightRatio
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSd_cornerRadiusFromHeightRatio:(NSNumber *)sd_cornerRadiusFromHeightRatio
{
    objc_setAssociatedObject(self, @selector(sd_cornerRadiusFromHeightRatio), sd_cornerRadiusFromHeightRatio, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)sd_equalWidthSubviews
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSd_equalWidthSubviews:(NSArray *)sd_equalWidthSubviews
{
    objc_setAssociatedObject(self, @selector(sd_equalWidthSubviews), sd_equalWidthSubviews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIScrollView (SDAutoContentSize)

- (void)setupAutoContentSizeWithBottomView:(UIView *)bottomView bottomMargin:(CGFloat)bottomMargin
{
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:bottomMargin];
}

@end

@implementation UILabel (SDLabelAutoResize)

- (void)setSigleLineAutoResizeWithMaxWidth:(CGFloat)maxWidth
{
    self.sd_maxWidth = @(maxWidth);
}

@end


@implementation SDAutoLayoutModelItem

@end


@implementation UIView (SDAutoLayout)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method layoutSubviews = class_getInstanceMethod(self, @selector(layoutSubviews));
        Method sd_autolayout = class_getInstanceMethod(self, @selector(sd_autolayout));
        method_exchangeImplementations(layoutSubviews, sd_autolayout);
    });
}

#pragma mark - properties

- (NSMutableArray *)autoLayoutModelsArray
{
    if (!objc_getAssociatedObject(self, _cmd)) {
        objc_setAssociatedObject(self, _cmd, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, _cmd);
}

- (NSNumber *)fixedWith
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFixedWith:(NSNumber *)fixedWith
{
    objc_setAssociatedObject(self, @selector(fixedWith), fixedWith, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)fixedHeight
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFixedHeight:(NSNumber *)fixedHeight
{
    objc_setAssociatedObject(self, @selector(fixedHeight), fixedHeight, OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)autoHeightRatioValue
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAutoHeightRatioValue:(NSNumber *)autoHeightRatioValue
{
    objc_setAssociatedObject(self, @selector(autoHeightRatioValue), autoHeightRatioValue, OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)sd_maxWidth
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSd_maxWidth:(NSNumber *)sd_maxWidth
{
    objc_setAssociatedObject(self, @selector(sd_maxWidth), sd_maxWidth, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SDAutoLayoutModel *)ownLayoutModel
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setOwnLayoutModel:(SDAutoLayoutModel *)ownLayoutModel
{
    objc_setAssociatedObject(self, @selector(ownLayoutModel), ownLayoutModel, OBJC_ASSOCIATION_RETAIN);
}

- (SDAutoLayoutModel *)sd_layout
{
    SDAutoLayoutModel *model = [self ownLayoutModel];
    if (!model) {
        model = [SDAutoLayoutModel new];
        model.needsAutoResizeView = self;
        [self setOwnLayoutModel:model];
        [self.superview.autoLayoutModelsArray addObject:model];
    }
    
    return model;
}

- (void)sd_autolayout
{
    [self sd_autolayout];
    
    if (self.sd_equalWidthSubviews.count) {
        __block CGFloat totalMargin = 0;
        [self.sd_equalWidthSubviews enumerateObjectsUsingBlock:^(UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
            SDAutoLayoutModel *model = view.sd_layout;
            totalMargin += ([model.left.value floatValue] + [model.right.value floatValue]);
        }];
        CGFloat averageWidth = (self.width - totalMargin) / self.sd_equalWidthSubviews.count;
        [self.sd_equalWidthSubviews enumerateObjectsUsingBlock:^(UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
            view.width = averageWidth;
            view.fixedWith = @(averageWidth);
        }];
    }
    
    if (self.autoLayoutModelsArray.count) {
        [self.autoLayoutModelsArray enumerateObjectsUsingBlock:^(SDAutoLayoutModel *model, NSUInteger idx, BOOL *stop) {
            [self sd_resizeWithModel:model];
        }];
    }
    
    if (self.tag == kSDModelCellTag && [self isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
        UITableViewCell *cell = (UITableViewCell *)(self.superview);
        if ([cell isKindOfClass:NSClassFromString(@"UITableViewCellScrollView")]) {
            cell = (UITableViewCell *)cell.superview;
        }
        if ([cell isKindOfClass:[UITableViewCell class]]) {
            cell.autoHeight = cell.sd_bottomView.bottom + cell.sd_bottomViewBottomMargin;
        }
    } else if (![self isKindOfClass:[UITableViewCell class]] && self.sd_bottomView) {
        if ([self isKindOfClass:[UIScrollView class]]) {
            CGFloat contentHeight = self.sd_bottomView.bottom + self.sd_bottomViewBottomMargin;
            UIScrollView *scrollView = (UIScrollView *)self;
            CGSize contentSize = scrollView.contentSize;
            contentSize.height = contentHeight;
            if (contentSize.width <= 0) {
                contentSize.width = scrollView.width;
            }
            scrollView.contentSize = contentSize;
        }
    }
}

- (void)sd_resizeWithModel:(SDAutoLayoutModel *)model
{
    UIView *view = model.needsAutoResizeView;
    
    if (view.sd_maxWidth && (model.rightSpaceToView || model.rightEqualToView)) { // 靠右布局前提设置
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            CGFloat width = [view.sd_maxWidth floatValue] > 0 ? [view.sd_maxWidth floatValue] : MAXFLOAT;
            label.numberOfLines = 1;
            if (label.text.length) {
                CGRect rect = [label.text boundingRectWithSize:CGSizeMake(width, label.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : label.font} context:nil];
                label.width = rect.size.width;
            } else {
                label.width = 0;
            }
        }
    }
    
    if (view.autoHeightRatioValue && view.width > 0 && (model.bottomEqualToView || model.bottomSpaceToView)) { // 底部布局前提设置
        if ([view.autoHeightRatioValue floatValue] > 0) {
            view.height = view.width * [view.autoHeightRatioValue floatValue];
        } else {
            if ([view isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel *)view;
                label.numberOfLines = 0;
                if (label.text.length) {
                    CGRect rect = [label.text boundingRectWithSize:CGSizeMake(label.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : label.font} context:nil];
                    label.height = rect.size.height;
                } else {
                    label.height = 0;
                }
            } else {
                view.height = 0;
            }
        }
    }
    
    if (model.width) {
        view.width = [model.width.value floatValue];
        view.fixedWith = @(view.width);
    } else if (model.ratio_width) {
        view.width = model.ratio_width.refView.width * [model.ratio_width.value floatValue];
        view.fixedWith = @(view.width);
    }
    
    if (model.height) {
        view.height = [model.height.value floatValue];
        view.fixedHeight = @(view.height);
    } else if (model.ratio_height) {
        view.height = [model.ratio_height.value floatValue] * model.ratio_height.refView.height;
        view.fixedHeight = @(view.height);
    }
    
    if (model.left) {
        if (view.superview == model.left.refView) {
            if (!view.fixedWith) { // view.autoLeft && view.autoRight
                view.width = view.right - [model.left.value floatValue];
            }
            view.left = [model.left.value floatValue];
        } else {
            if (!view.fixedWith) { // view.autoLeft && view.autoRight
                view.width = view.right - model.left.refView.right - [model.left.value floatValue];
            }
            view.left = model.left.refView.right + [model.left.value floatValue];
        }
        
    } else if (model.equalLeft) {
        if (!view.fixedWith) {
            view.width = view.right - model.equalLeft.refView.left;
        }
        if (view.superview == model.equalLeft.refView) {
            view.left = 0;
        } else {
            view.left = model.equalLeft.refView.left;
        }
    } else if (model.equalCenterX) {
        if (view.superview == model.equalCenterX.refView) {
            view.centerX = model.equalCenterX.refView.width * 0.5;
        } else {
            view.centerX = model.equalCenterX.refView.centerX;
        }
    } else if (model.centerX) {
        view.centerX = [model.centerX floatValue];
    }
    
    if (model.right) {
        if (view.superview == model.right.refView) {
            if (!view.fixedWith) { // view.autoLeft && view.autoRight
                view.width = model.right.refView.width - view.left - [model.right.value floatValue];
            }
            view.right = model.right.refView.width - [model.right.value floatValue];
        } else {
            if (!view.fixedWith) { // view.autoLeft && view.autoRight
                view.width =  model.right.refView.left - view.left - [model.right.value floatValue];
            }
            view.right = model.right.refView.left - [model.right.value floatValue];
        }
    } else if (model.equalRight) {
        if (!view.fixedWith) {
            view.width = model.equalRight.refView.right - view.left;
        }
        
        view.right = model.equalRight.refView.right;
        if (view.superview == model.equalRight.refView) {
            view.right = model.equalRight.refView.width;
        }
        
    }
    
    if (model.top) {
        if (view.superview == model.top.refView) {
            if (!view.fixedHeight) { // view.autoTop && view.autoBottom && view.bottom
                view.height = view.bottom - [model.top.value floatValue];
            }
            view.top = [model.top.value floatValue];
        } else {
            if (!view.fixedHeight) { // view.autoTop && view.autoBottom && view.bottom
                view.height = view.bottom - model.top.refView.bottom - [model.top.value floatValue];
            }
            view.top = model.top.refView.bottom + [model.top.value floatValue];
        }
    } else if (model.equalTop) {
        if (view.superview == model.equalTop.refView) {
            if (!view.fixedHeight) {
                view.height = view.bottom;
            }
            view.top = 0;
        } else {
            if (!view.fixedHeight) {
                view.height = view.bottom - model.equalTop.refView.top;
            }
            view.top = model.equalTop.refView.top;
        }
    } else if (model.equalCenterY) {
        if (view.superview == model.equalCenterY.refView) {
            view.centerY = model.equalCenterY.refView.height * 0.5;
        } else {
            view.centerY = model.equalCenterY.refView.centerY;
        }
    } else if (model.centerY) {
        view.centerY = [model.centerY floatValue];
    }
    
    if (model.bottom) {
        if (view.superview == model.bottom.refView) {
            if (!view.fixedHeight) {
                view.height = view.superview.height - view.top - [model.bottom.value floatValue];
            }
            view.bottom = model.bottom.refView.height - [model.bottom.value floatValue];
        } else {
            if (!view.fixedHeight) {
                view.height = model.bottom.refView.top - view.top - [model.bottom.value floatValue];
            }
            view.bottom = model.bottom.refView.top - [model.bottom.value floatValue];
        }
        
    } else if (model.equalBottom) {
        if (view.superview == model.equalBottom.refView) {
            if (!view.fixedHeight) {
                view.height = view.superview.height - view.top;
            }
            view.bottom = model.equalBottom.refView.height;
        } else {
            if (!view.fixedHeight) {
                view.height = model.equalBottom.refView.bottom - view.top;
            }
            view.bottom = model.equalBottom.refView.bottom;
        }
    }
    
    if (view.autoHeightRatioValue && view.width > 0) {
        if ([view.autoHeightRatioValue floatValue] > 0) {
            view.height = view.width * [view.autoHeightRatioValue floatValue];
        } else {
            if ([view isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel *)view;
                label.numberOfLines = 0;
                if (label.text.length) {
                    CGRect rect = [label.text boundingRectWithSize:CGSizeMake(label.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : label.font} context:nil];
                    label.height = rect.size.height;
                } else {
                    label.height = 0;
                }
            } else {
                view.height = 0;
            }
        }
    }
    
    if (view.sd_maxWidth) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            CGFloat width = [view.sd_maxWidth floatValue] > 0 ? [view.sd_maxWidth floatValue] : MAXFLOAT;
            label.numberOfLines = 1;
            if (label.text.length) {
                CGRect rect = [label.text boundingRectWithSize:CGSizeMake(width, label.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : label.font} context:nil];
                label.width = rect.size.width;
            } else {
                label.width = 0;
            }
        }
    }
    
    if (model.maxWidth && [model.maxWidth floatValue] < view.width) {
        view.width = [model.maxWidth floatValue];
    }
    
    if (model.minWidth && [model.minWidth floatValue] > view.width) {
        view.width = [model.minWidth floatValue];
    }
    
    if (model.maxHeight && [model.maxHeight floatValue] < view.height) {
        view.height = [model.maxHeight floatValue];
    }
    
    if (model.minHeight && [model.minHeight floatValue] > view.height) {
        view.height = [model.minHeight floatValue];
    }
    
    CGFloat cornerRadius = view.layer.cornerRadius;
    CGFloat newCornerRadius = 0;
    
    if (view.sd_cornerRadius && (cornerRadius != [view.sd_cornerRadius floatValue])) {
        newCornerRadius = [view.sd_cornerRadius floatValue];
    } else if (view.sd_cornerRadiusFromWidthRatio && (cornerRadius != [view.sd_cornerRadiusFromWidthRatio floatValue] * view.width)) {
        newCornerRadius = view.width * [view.sd_cornerRadiusFromWidthRatio floatValue];
    } else if (view.sd_cornerRadiusFromHeightRatio && (cornerRadius != view.height * [view.sd_cornerRadiusFromHeightRatio floatValue])) {
        newCornerRadius = view.height * [view.sd_cornerRadiusFromHeightRatio floatValue];
    }
    
    if (newCornerRadius > 0) {
        view.layer.cornerRadius = newCornerRadius;
        view.clipsToBounds = YES;
    }
    
}

- (void)addAutoLayoutModel:(SDAutoLayoutModel *)model
{
    [self.autoLayoutModelsArray addObject:model];
}

@end


@implementation UIView (SDChangeFrame)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.left + self.width * 0.5;
}

- (void)setCenterX:(CGFloat)centerX
{
    self.left = centerX - self.width * 0.5;
}

- (CGFloat)centerY
{
    return self.top + self.height * 0.5;
}

- (void)setCenterY:(CGFloat)centerY
{
    self.top = centerY - self.height * 0.5;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end

