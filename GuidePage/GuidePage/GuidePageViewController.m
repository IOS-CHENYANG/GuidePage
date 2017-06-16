//
//  GuidePageViewController.m
//  GuidePage
//
//  Created by 陈阳阳 on 2017/6/16.
//  Copyright © 2017年 cyy. All rights reserved.
//

#import "GuidePageViewController.h"

@interface GuidePageCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton    *button;

@end

@implementation GuidePageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.button];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
    [self.button sizeToFit];
    self.button.center = self.contentView.center;
    CGFloat width  = self.button.bounds.size.width + 20;
    CGFloat height = self.button.bounds.size.height;
    CGFloat x  = (self.contentView.bounds.size.width - width) / 2;
    CGFloat y  = self.contentView.bounds.size.height - 100 - height;
    self.button.frame = CGRectMake(x, y, width, height);
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _imageView;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.backgroundColor = [UIColor redColor];
        [_button setTitle:@"进入APP" forState:UIControlStateNormal];
        _button.layer.cornerRadius = 10;
        _button.layer.masksToBounds = YES;
    }
    return _button;
}

@end

@interface GuidePageViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIPageControl    *pageControl;
@property (nonatomic,strong) UIButton         *button;

@end

@implementation GuidePageViewController
{
    NSArray *_imageArray;
    FinishHandler _handler;
}

- (void)dealloc {
    NSLog(@"GuidePageViewController dealloc");
}

- (instancetype)initWithImageArray:(NSArray *)imageArray FinishHandler:(FinishHandler)handler {
    self = [super init];
    if (self) {
        _imageArray = imageArray;
        _handler    = [handler copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSLog(@"currentVersion = %@",currentVersion);
    NSString *oldVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"oldVersion"];
    if ([currentVersion isEqualToString:oldVersion]) {
        _handler();
    }else {
        [self.collectionView registerClass:[GuidePageCell class] forCellWithReuseIdentifier:@"guide"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"oldVersion"];
    [self.view addSubview:self.pageControl];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GuidePageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"guide" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    NSLog(@"indexPath = %@",indexPath);
    if (indexPath.row == _imageArray.count - 1) {
        cell.button.hidden = NO;
        [cell.button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }else {
        cell.button.hidden = YES;
    }
    return cell;
}

- (void)buttonClick {
    _handler();
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    _pageControl.currentPage = offsetX / scrollView.bounds.size.width;
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = self.view.bounds.size;
        NSLog(@"self.view.bounds.size = %@",NSStringFromCGSize(self.view.bounds.size));
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = _imageArray.count;
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = [UIColor purpleColor];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        CGSize pageControlSize = [_pageControl sizeForNumberOfPages:_imageArray.count];
        CGFloat x = (self.view.bounds.size.width - pageControlSize.width) / 2;
        CGFloat y = (self.view.bounds.size.height - pageControlSize.height - 50.f);
        _pageControl.frame = CGRectMake(x, y, pageControlSize.width, pageControlSize.height);
    }
    return _pageControl;
}

@end

