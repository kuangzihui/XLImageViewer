//
//  ShowNetImagesDemoVC.m
//  XLImageViewerDemo
//
//  Created by Apple on 2017/2/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ShowNetImagesDemoVC.h"
#import "XLImageViewer.h"
#import "ImageCell.h"
#import "SDImageCache.h"
#import "MBProgressHUD.h"

@interface ShowNetImagesDemoVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
    
    NSMutableArray *_imageItems;
}
@end

@implementation ShowNetImagesDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildUI];
}

-(NSArray*)imageUrls
{
    return @[
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/1.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/2.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/3.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/4.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/5.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/6.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/7.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/8.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/9.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/10.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/11.png",
             @"https://raw.githubusercontent.com/mengxianliang/XLImageViewer/master/Images/12.png"];
}

-(void)buildUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(clearImageCache)];
    
    NSInteger ColumnNumber = 3;
    CGFloat imageMargin = 10.0f;
    CGFloat itemWidth = (self.view.bounds.size.width - (ColumnNumber + 1)*imageMargin)/ColumnNumber;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 0, 0, 0);
    flowLayout.itemSize = CGSizeMake(itemWidth,itemWidth);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.showsHorizontalScrollIndicator = false;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:@"ImageCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
}

#pragma mark -
#pragma mark CollectionViewDelegate&DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self imageUrls].count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"ImageCell";
    ImageCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.layer.borderWidth = 1.0f;
    cell.imageUrl = [self imageUrls][indexPath.row];
    return  cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[XLImageViewer shareInstanse] showNetImages:[self imageUrls] index:indexPath.row from:[collectionView cellForItemAtIndexPath:indexPath]];
}

-(void)clearImageCache
{
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [MBProgressHUD hideHUDForView:self.view animated:true];
        [_collectionView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
