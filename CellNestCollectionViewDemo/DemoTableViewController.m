//
//  DemoTableViewController.m
//  CellNestCollectionViewDemo
//
//  Created by 王家强 on 2019/6/13.
//  Copyright © 2019 王家强. All rights reserved.
//

#import "DemoTableViewController.h"
#import "DemoDataKey.h"
#import "DemoTableViewCell.h"

@interface DemoTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *dataArr;

@end

@implementation DemoTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Demo";
    // 自动布局
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.tableView registerClass:[DemoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([DemoTableViewCell class])];
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DemoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DemoTableViewCell class]) forIndexPath:indexPath];
    [cell setModel:self.dataArr[indexPath.row]];
    return cell;
}

- (NSArray *)dataArr
{
    return @[
             @[@{
                   DemoCollctionItemName : @"哈哈哈1",
                   DemoCollctionItemImage: @"avatar.jpg"
                   },
               @{
                   DemoCollctionItemName : @"哈哈哈2",
                   DemoCollctionItemImage: @"avatar.jpg"
                   },
               @{
                   DemoCollctionItemName : @"哈哈哈3",
                   DemoCollctionItemImage: @"avatar.jpg"
                   },
               @{
                   DemoCollctionItemName : @"哈哈哈4",
                   DemoCollctionItemImage: @"avatar.jpg"
                   },
               @{
                   DemoCollctionItemName : @"哈哈哈5",
                   DemoCollctionItemImage: @"avatar.jpg"
                   }],
             @[@{
                   DemoCollctionItemName : @"哈哈哈0",
                   DemoCollctionItemImage: @"avatar.jpg"
                   },
               @{
                   DemoCollctionItemName : @"哈哈哈1",
                   DemoCollctionItemImage: @"avatar.jpg"
                   }],
             @[@{
                   DemoCollctionItemName : @"哈哈哈0",
                   DemoCollctionItemImage: @"avatar.jpg"
                   },
               @{
                   DemoCollctionItemName : @"哈哈哈1",
                   DemoCollctionItemImage: @"avatar.jpg"
                   },
               @{
                   DemoCollctionItemName : @"哈哈哈2",
                   DemoCollctionItemImage: @"avatar.jpg"
                   },
               @{
                   DemoCollctionItemName : @"哈哈哈3",
                   DemoCollctionItemImage: @"avatar.jpg"
                   }]
             ];
}

@end
