//
//  ViewController.m
//  OpenLibDemo
//
//  Created by KingyoWang on 17/2/20.
//  Copyright © 2017年 hp. All rights reserved.
//

#import "ViewController.h"
#import "FXBlurView.h"
#import "FSCalendar.h"
#import "YLImageView.h"
#import "YLGIFImage.h"
#import "AwesomeMenu.h"
#import "HexColors.h"
#import "DCPathButton.h"
#import "SphereMenu.h"
#import "QRCodeReaderViewController.h"
#import "RKNotificationHub.h"
#import "QBImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController ()<FSCalendarDelegate, FSCalendarDataSource, AwesomeMenuDelegate, DCPathButtonDelegate, SphereMenuDelegate, QRCodeReaderDelegate, QBImagePickerControllerDelegate>

@property (nonatomic, weak) FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UIButton *qrButton;
@property (nonatomic, strong) RKNotificationHub *hub;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *blur = [[UIImageView alloc] initWithFrame:self.view.bounds];
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    blur.image = [image blurredImageWithRadius:100 iterations:2 tintColor:[UIColor blackColor]];
    [self.view addSubview:blur];
    
    // calendar
    [self addCalendar];
    
    // gif
    [self addGif];
    
    // menu
    [self menu];
    
    [self hexColor];
    
    [self dcPathMenu];

    [self sphereMenu];
    
    // QRCode
    [self.view bringSubviewToFront:self.qrButton];
    
    // badge
    [self addBadge];

    // imagePicker
    [self addImagePickerBtn];
}


- (void)addImagePickerBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(800, 600, 80, 30);
    [btn setTitle:@"图片选择器" forState:0];
    [btn addTarget:self action:@selector(showImagePicler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(880, 640, 100, 100)];
    [self.view addSubview:self.imageView];
}

- (void)showImagePicler {
    
    // 方式一
//    // 弹出系统的相册
//         // 选择控制器（系统相册）
//         UIImagePickerController *picekerVc = [[UIImagePickerController alloc] init];
//    
//         // 设置选择控制器的来源
////          UIImagePickerControllerSourceTypePhotoLibrary 相册集
////          UIImagePickerControllerSourceTypeSavedPhotosAlbum:照片库
//         picekerVc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//    
//     // 设置代理
//        picekerVc.delegate = self;
//   
//        // modal
//        [self presentViewController:picekerVc animated:YES completion:nil];
//    
//    return;
    
    // 1 检查授权
    NSString *tipTextWhenNoPhotosAuthorization; // 提示语
    // 获取当前应用对照片的访问授权状态
    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
    // 如果没有获取访问授权，或者访问授权状态已经被明确禁止，则显示提示语，引导用户开启授权
    if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
        NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
        tipTextWhenNoPhotosAuthorization = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
        // 展示提示语
        return;
    }
    
    
    // 不能获取照片库的图片，意义小很多
    QBImagePickerController *vc = [[QBImagePickerController alloc] init];
    vc.allowsMultipleSelection = NO;
    vc.allowsMultipleSelection = YES;
//    vc.numberOfColumnsInPortrait = 5;
    vc.numberOfColumnsInLandscape = 4;
    vc.mediaType = QBImagePickerMediaTypeAny;
    vc.showsNumberOfSelectedAssets = YES;
//    vc.prompt = @"请选择图片";
    vc.assetCollectionSubtypes = @[@(PHAssetCollectionSubtypeSmartAlbumUserLibrary), // Camera Roll
                                   @(PHAssetCollectionSubtypeAlbumMyPhotoStream), // My Photo Stream
                                   @(PHAssetCollectionSubtypeSmartAlbumPanoramas), // Panoramas
                                   @(PHAssetCollectionSubtypeSmartAlbumVideos), // Videos
                                   @(PHAssetCollectionSubtypeSmartAlbumBursts), // Bursts
                                   @(PHAssetCollectionSubtypeAlbumRegular)];
    /*
     PHAssetCollectionSubtype
     
     PHAssetCollectionSubtypeAlbumRegular         = 2,
     PHAssetCollectionSubtypeAlbumSyncedEvent     = 3,
     PHAssetCollectionSubtypeAlbumSyncedFaces     = 4,
     PHAssetCollectionSubtypeAlbumSyncedAlbum     = 5,
     PHAssetCollectionSubtypeAlbumImported        = 6,
     
     PHAssetCollectionSubtypeAlbumMyPhotoStream   = 100,
     PHAssetCollectionSubtypeAlbumCloudShared     = 101,
     
     PHAssetCollectionSubtypeSmartAlbumGeneric    = 200,
     PHAssetCollectionSubtypeSmartAlbumPanoramas  = 201,
     PHAssetCollectionSubtypeSmartAlbumVideos     = 202,
     PHAssetCollectionSubtypeSmartAlbumFavorites  = 203,
     PHAssetCollectionSubtypeSmartAlbumTimelapses = 204,
     PHAssetCollectionSubtypeSmartAlbumAllHidden  = 205,
     PHAssetCollectionSubtypeSmartAlbumRecentlyAdded = 206,
     PHAssetCollectionSubtypeSmartAlbumBursts     = 207,
     PHAssetCollectionSubtypeSmartAlbumSlomoVideos = 208,
     PHAssetCollectionSubtypeSmartAlbumUserLibrary = 209,
     PHAssetCollectionSubtypeSmartAlbumSelfPortraits PHOTOS_AVAILABLE_IOS_TVOS(9_0, 10_0) = 210,
     PHAssetCollectionSubtypeSmartAlbumScreenshots PHOTOS_AVAILABLE_IOS_TVOS(9_0, 10_0) = 211,
     PHAssetCollectionSubtypeSmartAlbumDepthEffect PHOTOS_AVAILABLE_IOS_TVOS(10_2, 10_1) = 212,

     
     
     imagePickerController.assetCollectionSubtypes = @[
     @(PHAssetCollectionSubtypeSmartAlbumUserLibrary), // Camera Roll
     @(PHAssetCollectionSubtypeAlbumMyPhotoStream), // My Photo Stream
     @(PHAssetCollectionSubtypeSmartAlbumPanoramas), // Panoramas
     @(PHAssetCollectionSubtypeSmartAlbumVideos), // Videos
     @(PHAssetCollectionSubtypeSmartAlbumBursts) // Bursts
     ];
    */
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    BOOL original = YES;
    
    for (PHAsset *asset in assets) {
        // 是否要原图
        
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            self.imageView.image = result;
        }];
        
        break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addBadge {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(700, 600, 60, 40)];
    imageView.image = [UIImage imageNamed:@"cart.jpg"];
    [self.view addSubview:imageView];
    
    RKNotificationHub *hub = [[RKNotificationHub alloc] initWithView:imageView];
    hub.count = 10;
    [hub setCircleAtFrame:CGRectMake(45, -5, 20, 20)];
    [hub pop];
    self.hub = hub;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.hub bump];
}

- (IBAction)scanQRCode:(UIButton *)sender {
//    NSAssert(NO, @"这是一个异常测试");
    
    QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    QRCodeReaderViewController *readerVC = [QRCodeReaderViewController readerWithCancelButtonTitle:@"cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
    readerVC.modalPresentationStyle = UIModalPresentationFormSheet;
    
    readerVC.delegate = self;
    [reader setCompletionWithBlock:^(NSString * _Nullable resultAsString) {
        [self dismissViewControllerAnimated:YES completion:NULL];
        NSLog(@"%@", resultAsString);
    }];
    
    
    [self presentViewController:readerVC animated:YES completion:nil];
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%@", result);
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)sphereMenu {
    UIImage *startImage = [UIImage imageNamed:@"start"];
    UIImage *image1 = [UIImage imageNamed:@"icon-twitter"];
    UIImage *image2 = [UIImage imageNamed:@"icon-email"];
    UIImage *image3 = [UIImage imageNamed:@"icon-facebook"];
    NSArray *images = @[image1, image2, image3];
    SphereMenu *sphereMenu = [[SphereMenu alloc] initWithStartPoint:CGPointMake(CGRectGetWidth(self.view.frame) / 2, 320)
                                                         startImage:startImage
                                                      submenuImages:images];
    sphereMenu.sphereDamping = 0.3;
    sphereMenu.sphereLength = 85;
    sphereMenu.delegate = self;
    [self.view addSubview:sphereMenu];
}

- (void)dcPathMenu {
    DCPathButton *dcPathButton = [[DCPathButton alloc]initWithCenterImage:[UIImage imageNamed:@"chooser-button-tab"]
                                                         highlightedImage:[UIImage imageNamed:@"chooser-button-tab-highlighted"]];
    dcPathButton.delegate = self;
    
    // Configure item buttons
    //
    DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-music"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-music-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_2 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-place"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-place-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_3 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-camera"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-camera-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_4 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-thought"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-thought-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_5 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-sleep"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-sleep-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    // Add the item button into the center button
    
    [dcPathButton addPathItems:@[itemButton_1,
                                 itemButton_2,
                                 itemButton_3,
                                 itemButton_4,
                                 itemButton_5
                                 ]];
    
    // Change the bloom radius, default is 105.0f

    dcPathButton.bloomRadius = 120.0f;
    dcPathButton.bloomAngel = 180;
    // Change the DCButton's center
    
    dcPathButton.dcButtonCenter = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height - 25.5f);
    
    // Setting the DCButton appearance
    
    dcPathButton.allowSounds = YES;
    dcPathButton.allowCenterButtonRotation = YES;
    dcPathButton.bottomViewColor = [UIColor blackColor];
    dcPathButton.bloomDirection = kDCPathButtonBloomDirectionTop;
    
    [self.view addSubview:dcPathButton];
}

- (void)hexColor {

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(300, 400, 100, 100)];
    view.backgroundColor = [UIColor hx_colorWithHexRGBAString: @"#ff8942"];
    [self.view addSubview:view];
}


- (void)addCalendar {
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(20, 20, 320, 640)];
    calendar.dataSource = self;
    calendar.delegate = self;
    [self.view addSubview:calendar];
    self.calendar = calendar;
}

- (void)addGif {
    YLImageView *imageView = [[YLImageView alloc] initWithFrame:CGRectMake(200, 50, 293*2, 213*2)];
    imageView.image = [YLGIFImage imageNamed:@"22.gif"];
    [self.view addSubview:imageView];
}

- (void)menu {
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    
    UIImage *starImage = [UIImage imageNamed:@"icon-star.png"];
    
    // Default Menu
    
    AwesomeMenuItem *starMenuItem1 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem2 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem3 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem4 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem5 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem6 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem7 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem8 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem9 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    
    NSArray *menuItems = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, starMenuItem5, starMenuItem6, starMenuItem7,starMenuItem8,starMenuItem9, nil];
    
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:self.view.frame menus:menuItems];
    menu.delegate = self;
    
    //  参数
    menu.menuWholeAngle = M_PI;
    menu.farRadius = 110.0f;
    menu.endRadius = 100.0f;
    menu.nearRadius = 90.0f;
    menu.closeRotation = 0.3f;
    menu.startPoint = CGPointMake(500.0, 410.0);
    
    
    [self.view addSubview:menu];
}

- (void)AwesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx {
    NSLog(@"%ld", (long)idx);
}


- (void)pathButton:(DCPathButton *)dcPathButton clickItemButtonAtIndex:(NSUInteger)itemButtonIndex {
    NSLog(@"%ld", (long)itemButtonIndex);
}


- (void)sphereDidSelected:(int)index {
    NSLog(@"%d", index);
}

@end



