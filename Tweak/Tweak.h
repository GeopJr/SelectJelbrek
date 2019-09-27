@interface UICalloutBar : UIView

@property (nonatomic,readonly) bool isDisplayingVertically; 
@property (nonatomic, retain) NSArray *extraItems;
@property (nonatomic, retain) UIMenuItem *slcJelbrekItem;

@end

@interface UICalloutBarButton : UIButton

@property (nonatomic, assign) SEL action;

@end
