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


@interface ViewController ()<FSCalendarDelegate, FSCalendarDataSource, AwesomeMenuDelegate>

@property (nonatomic, weak) FSCalendar *calendar;

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

@end
