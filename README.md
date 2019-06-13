# CellNestCollectionViewDemo
Cell嵌套UIColeectionView自动布局获取高度示例

开发过程中我们经常会遇到稍微复杂的视图需要tableView和collectionView的相互嵌套，那么当cell嵌套tableView或者collectionView的时候怎么让cell自动布局撑起来呢，这里以cell嵌套collectionView为例：

![](https://qn.nobady.cn/github/IMG_2610.PNG)

### 方案1:
使用collectionViewLayout.collectionViewContentSize来获取collectionView的高度

```objc
// tableViewCell赋值
- (void)setModel:(NSArray *)dataArr {
    self.dataArr=dataArr;
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.collectionView.collectionViewLayout.collectionViewContentSize.height);
    }];
}
```

这样是可以实现，但有以下几个问题

如果在collectionView外层再加一层View就会出现部分机型计算的高度不准确
如果是cell嵌套的tableView呢，怎么获取tableView的高度，网上也有再reloadData后回到主线程获取tableView的高度，这个时候是可以获取真实高度，但tableView不会更新，也会有问题。
### 方案2:
通过重写 - (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority 方法

cell是通过systemLayoutSizeFittingSize方法获取contentView高度，然后+分割线高度得到cell的高度，因此重写此方法返回真实高度应该是最有效的

举例：cell布局如下

```objc
- (void)setView{
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.collectionView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(MAGIN16);
        make.right.bottom.mas_equalTo(-MAGIN16);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.right.mas_equalTo(0);
    }];
}
```

tableViewCell赋值

```objc
- (void)setModel:(NSArray *)dataArr {
    self.dataArr=dataArr;
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    [self.bgView layoutIfNeeded];
}
```

计算高度

```objc
- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority
{
    // 先对bgview进行布局,这里需对bgView布局后collectionView宽度才会准确
    self.bgView.frame = CGRectMake(0, 0, targetSize.width, 44);
    [self.bgView layoutIfNeeded];
    
    // 在对collectionView进行布局
    self.collectionView.frame = CGRectMake(0, 0, targetSize.width-MAGIN16*2, 44);
    [self.collectionView layoutIfNeeded];
    
    // 由于这里collection的高度是动态的，这里cell的高度我们根据collection来计算
    CGSize collectionSize = self.collectionView.collectionViewLayout.collectionViewContentSize;
    CGFloat cotentViewH = collectionSize.height + MAGIN16*2;
    
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, cotentViewH);
}
```
