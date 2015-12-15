//
//  BookListTableViewCell.m
//  iMagReader
//
//  Created by zuo wq on 12-9-20.
//
//

#import "BookListTableViewCell.h"
#import "DrawView.h"
#import "Utilities.h"

@implementation BookListTableViewCell

-(void)dealloc{
    MYLog(@"%s", __func__);
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        if ([Utilities isiPad]) {
        }else {
            UILabel* titleLabel=[self textLabel];
            titleLabel.font = [UIFont boldSystemFontOfSize:17];
            titleLabel.textColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        }
        
    }
    return self;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

-(void)setDrawViewInCellbyPercent:(float)fPercent{
    DrawView *dv =(DrawView*)[self viewWithTag:-2];
    if (dv) {
        [dv removeFromSuperview];
        dv=nil;
    }
    
    if (fPercent==-100) {
        return;
    }
    
    //int cellHeight = [Utilities isiPad] ? 95.0f : 70.0f ;
    //dv = [[[DrawView alloc] initWithFrame:CGRectMake(listTableView.frame.size.width- ([GenaricClass isiPad] ? 50 : 43) , cellHeight/2-20, 40, 40)] autorelease];
    dv = [[[DrawView alloc] initWithFrame:CGRectMake(0 , 0, 40, 40)] autorelease];
    dv.tag=-2;
    [self addSubview:dv];
    
	MYLog(@"get,,pointy=%.3f",fPercent);
	if (fPercent == -0.1f ) {
		dv.intPersent=0;
	}else {
		dv.intPersent = fPercent *100 ;
	}
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
    BOOL isIPAD = UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad;
    UIView *dv =[self viewWithTag:-2];
    if (dv) {
        int cellHeight = isIPAD ? 95.0f : 70.0f ;
        dv.frame=CGRectMake(self.frame.size.width- (isIPAD ? 55 : 43) , cellHeight/2-20, 40, 40);
    }
    
    //int x= (isIPAD?65:45);
    CGRect titleRect = self.textLabel.frame;
    //titleRect.origin.x = x+10;
    titleRect.size.width =  self.contentView.frame.size.width - titleRect.origin.x -(isIPAD ? 50 : 43) ;
    [self.textLabel setFrame:titleRect];
}

@end
