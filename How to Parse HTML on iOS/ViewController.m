//
//  ViewController.m
//  How to Parse HTML on iOS
//
//  Created by Mark MaMian on 2016/10/6.
//  Copyright © 2016年 Mark MaMian. All rights reserved.
//

#import "ViewController.h"
#import "TFHpple.h"
#import "Tutorial.h"
#import "Contributor.h"

@interface ViewController ()

@property (weak, nonatomic) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView = tableView;
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self loadTutorials];
    [self loadContributors];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadTutorials {
    // 1
    NSURL *tutorialsUrl = [NSURL URLWithString:@"https://www.raywenderlich.com/tutorials"];
    NSData *tutorialsHtmlData = [NSData dataWithContentsOfURL:tutorialsUrl];
    
    // 2
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:tutorialsHtmlData];
    
    // 3
    NSString *tutorialsXpathQueryString = @"//div[@class='content-wrapper']/ul/li/a";
    NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
    
    // 4
    NSMutableArray *newTutorials = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *element in tutorialsNodes) {
        // 5
        Tutorial *tutorial = [[Tutorial alloc] init];
        [newTutorials addObject:tutorial];
        
        // 6
        tutorial.title = [[element firstChild] content];
        
        // 7
        tutorial.url = [NSURL URLWithString:[element objectForKey:@"href"]];
    }
    
    // 8
    _objects = newTutorials;
    [self.tableView reloadData];
}

-(void)loadContributors {
    // 1
    NSURL *contributorsUrl = [NSURL URLWithString:@"https://www.raywenderlich.com/about"];
    NSData *contributorsHtmlData = [NSData dataWithContentsOfURL:contributorsUrl];
    
    // 2
    TFHpple *contributorsParser = [TFHpple hppleWithHTMLData:contributorsHtmlData];
    
    // 3
    NSString *contributorsXpathQueryString = @"//ul[@class='team-members']/li";
    NSArray *contributorsNodes = [contributorsParser searchWithXPathQuery:contributorsXpathQueryString];
    
    // 4
    NSMutableArray *newContributors = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *element in contributorsNodes) {
        // 5
        Contributor *contributor = [[Contributor alloc] init];
        [newContributors addObject:contributor];
        
        
        
        // 6
        //寻找子标签
        for (TFHppleElement *child in element.children) {
            //如果是a
            if ([child.tagName isEqualToString:@"a"]) {
                // 7
                //                    contributor.imageUrl = [@"https://www.raywenderlich.com/about" stringByAppendingString:[child objectForKey:@"src"]];
                //继续寻找子标签
                for (TFHppleElement *childA in child.children) {
                    //如果是src
                    contributor.imageUrl = [childA objectForKey:@"src"];
                    
                    
                }
                
                    
//                    NSString *str = [temp objectForKey:@"img"];
                
            } else if ([child.tagName isEqualToString:@"h3"]) {
                // 8
                contributor.name = [[child firstChild] content];
            }
        }
    }
    
    
    
    // 9
    _contributors = newContributors;
    [self.tableView reloadData];
}


-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Tutorials";
            break;
        case 1:
            return @"Contributors";
            break;
    }
    return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return _objects.count;
            break;
        case 1:
            return _contributors.count;
            break;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.section == 0) {
        Tutorial *thisTutorial = [_objects objectAtIndex:indexPath.row];
        cell.textLabel.text = thisTutorial.title;
        cell.detailTextLabel.text = thisTutorial.url.absoluteString;
    } else if (indexPath.section == 1) {
        Contributor *thisContributor = [_contributors objectAtIndex:indexPath.row];
        cell.textLabel.text = thisContributor.name;
        
        //转换为data
        NSString *ImageURL = thisContributor.imageUrl;
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
        
        cell.imageView.image = [UIImage imageWithData:imageData];
        
        
        cell.detailTextLabel.text = thisContributor.imageUrl;
    }
    
    return cell;
}




@end
