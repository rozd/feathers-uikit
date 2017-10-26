/**
 * Created by max.rozdobudko@gmail.com on 8/31/17.
 */
package feathersx.mvvc {
import feathers.controls.ButtonGroup;
import feathers.controls.Label;
import feathers.controls.Screen;
import feathers.controls.StackScreenNavigatorItem;
import feathers.core.FeathersControl;
import feathers.data.IListCollection;
import feathers.data.ListCollection;
import feathers.layout.Direction;

import feathersx.mvvc.BarButtonItem;
import feathersx.mvvc.NavigationBar;
import feathersx.mvvc.NavigationItem;

import flash.geom.Point;

import starling.display.DisplayObject;
import starling.display.Quad;
import starling.filters.DropShadowFilter;

internal class NavigationBarContent extends Screen {

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function NavigationBarContent(navigationItem: NavigationItem): void {
        super();
        _navigationItem = navigationItem;
        _navigationItem.setChangeCallback(function (): void {
            invalidate(INVALIDATION_FLAG_DATA);
        });
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var _navigationItem: NavigationItem;

    public var leftButtonGroup: ButtonGroup;
    public var titleView: FeathersControl;
    public var rightButtonGroup: ButtonGroup;

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    override protected function initialize(): void {
        super.initialize();

        backgroundSkin = createBackground();

        leftButtonGroup = new ButtonGroup();
        leftButtonGroup.direction = Direction.HORIZONTAL;
        leftButtonGroup.gap = 16;
        leftButtonGroup.customButtonStyleName = NavigationBar.LEFT_ITEM_STYLE_NAME;
        addChild(leftButtonGroup);

        rightButtonGroup = new ButtonGroup();
        rightButtonGroup.direction = Direction.HORIZONTAL;
        rightButtonGroup.gap = 16;
        rightButtonGroup.customButtonStyleName = NavigationBar.RIGHT_ITEM_STYLE_NAME;
        addChild(rightButtonGroup);

        if (titleView == null) {
            titleView = createTitleView();
        }
        addChild(titleView);
    }

    override protected function draw(): void {
        super.draw();
        var dataInvalid: Boolean = isInvalid(INVALIDATION_FLAG_DATA);
        var sizeInvalid: Boolean = isInvalid(INVALIDATION_FLAG_SIZE);

        if (dataInvalid) {
            commitData();
        }

        if (sizeInvalid) {
            layoutChildren();
            updateDropShadow();
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    private function commitData(): void {
        leftButtonGroup.dataProvider = composeLeftItems();
        rightButtonGroup.dataProvider = composeRightItems();

        if (titleView is Label) {
            Label(titleView).text = _navigationItem.title;
        }
    }

    private function layoutChildren(): void {
        var padding:uint = NavigationBar.PADDING;
        leftButtonGroup.validate();
        rightButtonGroup.validate();

        leftButtonGroup.x = padding;
        leftButtonGroup.y = (actualHeight - leftButtonGroup.height) / 2;

        rightButtonGroup.x = actualWidth - rightButtonGroup.width - padding;
        rightButtonGroup.y = (actualHeight - rightButtonGroup.height) / 2;

        titleView.maxWidth = rightButtonGroup.x - (leftButtonGroup.x + leftButtonGroup.width);
        titleView.validate();
        titleView.x = (actualWidth - titleView.width) / 2;
        titleView.y = (actualHeight - titleView.height) / 2;
    }

    //-------------------------------------
    //  Background
    //-------------------------------------

    private function createBackground():DisplayObject {
        var navigationBar:NavigationBar = _owner as NavigationBar;

        var skin:Quad = new Quad(100, 100, navigationBar.barTintColor);

        if (navigationBar.isTransparent) {
            skin.visible = false;
        } else if (navigationBar.isTranslucent) {
            // TODO implement
        } else {
            if (navigationBar.shadowColor != uint.MAX_VALUE) {
                skin.filter = createDropShadow();
            }
        }

        return skin;
    }

    private function createDropShadow():DropShadowFilter {
        var navigationBar:NavigationBar = _owner as NavigationBar;

        if (navigationBar.shadowColor == uint.MAX_VALUE) {
            return null;
        }

        var alpha:Number = isNaN(navigationBar.shadowAlpha) ? 0.5 : navigationBar.shadowAlpha;
        var blur:Number = isNaN(navigationBar.shadowRadius) ? 1.0 : navigationBar.shadowRadius;

        var center:Point = new Point();
        var offset:Point = navigationBar.shadowOffset || center;
        var delta:Point = offset.subtract(center);

        var distance:Number = Math.sqrt((offset.x - center.x) ^ 2 + (offset.y - center.y) ^ 2);
        var angle:Number = Math.atan2(delta.y, delta.x);

        var filter:DropShadowFilter = new DropShadowFilter(distance, angle, navigationBar.shadowColor, alpha, blur);
        filter.cache();
        return filter;
    }

    private function updateDropShadow():void {
        if (backgroundSkin != null && backgroundSkin.filter is DropShadowFilter) {
            backgroundSkin.filter.cache();
        }
    }

    //-------------------------------------
    //  Title
    //-------------------------------------

    private function createTitleView(): FeathersControl {
        var navigationBar:NavigationBar = _owner as NavigationBar;

        if (_navigationItem.titleView) {
            return _navigationItem.titleView;
        } else {
            var label:Label = new Label();
            label.styleName = navigationBar.titleStyleName;
            return label;
        }
    }

    private function createBackButtonItem(): BarButtonItem {
        var navigationBar:NavigationBar = _owner as NavigationBar;

        var backButtonItem: BarButtonItem = _navigationItem.backBarButtonItem;

        if (backButtonItem == null) {
            backButtonItem = new BarButtonItem();
            backButtonItem.defaultIcon = null; // TBA
            backButtonItem.label = "Back";
        }

        backButtonItem.triggered = function () {
            navigationBar.notifyBackCallbacks();
        };

        return backButtonItem;
    }

    private function composeLeftItems(): IListCollection {
        var navigationBar:NavigationBar = _owner as NavigationBar;

        var items:Vector.<BarButtonItem> = new <BarButtonItem>[];

        if (!_navigationItem.hidesBackButton && navigationBar.stackCount > 1) {
            if (_navigationItem.leftItems == null || _navigationItem.leftItems.length == 0) {
                items.push(createBackButtonItem());
            } else {
                if (_navigationItem.leftItemsSupplementBackButton) {
                    items.push(createBackButtonItem());
                }
            }
        }

        if (_navigationItem.leftItems != null) {
            items = items.concat(_navigationItem.leftItems);
        }

        return new ListCollection(items);
    }

    private function composeRightItems(): IListCollection {
        return new ListCollection(_navigationItem.rightItems);
    }
}
}
