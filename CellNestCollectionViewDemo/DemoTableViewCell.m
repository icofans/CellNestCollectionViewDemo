//
//  DemoTableViewCell.m
//  CellNestCollectionViewDemo
//
//  Created by 王家强 on 2019/6/13.
//  Copyright © 2019 王家强. All rights reserved.
//

#import "DemoTableViewCell.h"
#import <Masonry.h>
#import "DemoCollectionViewCell.h"

@interface DemoTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) NSArray *dataArr;

@end

@implementation DemoTableViewCell

static CGFloat const Margin = 16;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - cell
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat cellWidth=0;
        CGFloat intervalWidth=15;//间隙宽度
        cellWidth=([UIScreen mainScreen].bounds.size.width-Margin*2-Margin*2)/2;
        layout.itemSize = CGSizeMake(cellWidth, 80);
        layout.minimumLineSpacing = intervalWidth;
        layout.minimumInteritemSpacing = intervalWidth;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[DemoCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([DemoCollectionViewCell class])];
        _collectionView.showsHorizontalScrollIndicator=NO;
        _collectionView.showsVerticalScrollIndicator=NO;
        _collectionView.backgroundColor=[UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 8;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatView];
    }
    return self;
}

- (void)creatView
{
    self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.collectionView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(Margin);
        make.right.bottom.mas_equalTo(-Margin);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.right.mas_equalTo(0);
    }];
}

#pragma mark - cell data
- (void)setModel:(NSArray *)model
{
    self.dataArr = model;
    [self.collectionView reloadData];
    
    /**
    // 通过collectionViewLayout.collectionViewContentSize
    [self.collectionView layoutIfNeeded];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.collectionView.collectionViewLayout.collectionViewContentSize.height);
    }];
    // 这种方法在6p等机型会出现高度错误的现象，通过调试可以发现collection的宽度为288（应该为388[414-16x2]）
     */
    
    // 这里我们使用重写systemLayoutSizeFittingSize的方式
    [self.collectionView layoutIfNeeded];
    [self.bgView layoutIfNeeded];
}

#pragma mark - 计算高度
- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority
{
    // 先对bgview进行布局
    self.bgView.frame = CGRectMake(0, 0, targetSize.width, 44);
    [self.bgView layoutIfNeeded];
    
    // 在对collectionView进行布局
    self.collectionView.frame = CGRectMake(0, 0, targetSize.width-Margin*2, 44);
    [self.collectionView layoutIfNeeded];
    
    // 由于这里collection的高度是动态的，这里cell的高度我们根据collection来计算
    CGSize collectionSize = self.collectionView.collectionViewLayout.collectionViewContentSize;
    CGFloat cotentViewH = collectionSize.height + Margin*2;
    
    // 返回当前cell的高度
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, cotentViewH);
}

#pragma mark - collection
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DemoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DemoCollectionViewCell class]) forIndexPath:indexPath];
    [cell setModel:self.dataArr[indexPath.row]];
    return cell;
}

@end


