/**
 * Created by max.rozdobudko@gmail.com on 8/31/17.
 */
package feathersx.mvvc {
import feathers.controls.ButtonGroup;
import feathers.controls.Label;
import feathers.controls.Screen;
import feathers.core.FeathersControl;
import feathers.data.IListCollection;
import feathers.data.ListCollection;
import feathers.layout.Direction;

import flash.geom.Point;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Quad;
import starling.filters.DropShadowFilter;

public class NavigationBarContent extends Screen {

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function NavigationBarContent(navigationItem: NavigationItem): void {
        super();
        _navigationItem = navigationItem;
        _navigationItem.setChangeCallback(function (animated: Boolean): void {
            isChangeAnimated = animated;
            invalidate(INVALIDATION_FLAG_DATA);
        });
    }

    //--------------------------------------------------------------------------
    //
    //  Dispose
    //
    //--------------------------------------------------------------------------

    override public function dispose(): void {
        trace("dispose NavigationBarContent of", _navigationItem);
        super.dispose();
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

    protected var isChangeAnimated: Boolean = false;

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    override protected function initialize(): void {
        super.initialize();

        backgroundSkin = createBackground();

        if (leftButtonGroup == null) {
            leftButtonGroup = createLeftButtonGroup();
        }
        addChild(leftButtonGroup);

        if (rightButtonGroup == null) {
            rightButtonGroup = createRightButtonGroup();
        }
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

        if (sizeInvalid || dataInvalid) {
            layoutChildren();
            updateDropShadow();
        }
    }

    override protected function refreshBackgroundLayout(): void {
        super.refreshBackgroundLayout();

        if (currentBackgroundSkin == null) {
            return;
        }

        currentBackgroundSkin.x = 0;
        currentBackgroundSkin.y = - owner.y;
        currentBackgroundSkin.width = actualWidth;
        currentBackgroundSkin.height = actualHeight + owner.y;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    protected function commitData(): void {
        leftButtonGroup.dataProvider = composeLeftItems();
        rightButtonGroup.dataProvider = composeRightItems();

        updateTitle(isChangeAnimated);
        updateSearchController(isChangeAnimated);
    }

    //------------------------------------
    //  Update Title
    //------------------------------------

    private var isTitleFadeOutAnimating: Boolean = false;
    private var isTitleFadeInAnimating: Boolean = false;
    protected function updateTitle(animated: Boolean): void {
        var titleLabel: Label = titleView as Label;

        if (titleLabel == null) {
            return;
        }

        if (titleLabel.text == _navigationItem.title) {
            return;
        }

        if (!animated || titleLabel.text == null) {
            titleLabel.text = _navigationItem.title;
            return;
        }

        if (isTitleFadeOutAnimating) {
            return;
        }

        if (isTitleFadeInAnimating) {
            titleLabel.text = _navigationItem.title;
        }

        isTitleFadeOutAnimating = true;
        Starling.current.juggler.tween(titleLabel, 0.3, {alpha: 0.0});
        Starling.current.juggler.delayCall(function (): void {
            isTitleFadeOutAnimating = false;
            isTitleFadeInAnimating = true;
            titleLabel.text = _navigationItem.title;
            Starling.current.juggler.tween(titleLabel, 0.3, {alpha: 1.0});
            layoutTitle();
            Starling.current.juggler.delayCall(function(): void {
                isTitleFadeInAnimating = false;
            }, 0.3);
        }, 0.3);
    }

    //------------------------------------
    //  Update Search Controller
    //------------------------------------

    private function updateSearchController(animated: Boolean): void {
        if (_navigationItem.searchController) {
            showSearchBar(animated);
        } else {
            hideSearchBar(animated);
        }
    }

    protected function showSearchBar(animated: Boolean): void {
        var existedSearchBar: SearchBar = findSearchBar();
        if (existedSearchBar != null) {
            return;
        }
        addChild(_navigationItem.searchController.searchBar);
    }

    protected function hideSearchBar(animated: Boolean): void {
        var existedSearchBar: SearchBar = findSearchBar();
        if (existedSearchBar == null) {
            return;
        }
        removeChild(existedSearchBar);
    }

    protected function findSearchBar(): SearchBar {
        for (var i: int = 0, n: int = numChildren; i < n; i++) {
            var child: DisplayObject = getChildAt(i);
            if (child is SearchBar) {
                return child as SearchBar;
            }
        }
        return null;
    }

    //------------------------------------
    //  Layout
    //------------------------------------

    protected function layoutChildren(): void {
        leftButtonGroup.validate();
        rightButtonGroup.validate();

        leftButtonGroup.x = NavigationBar.appearance.paddingLeft;
        leftButtonGroup.y = NavigationBar.appearance.paddingTop + (actualHeight - leftButtonGroup.height - NavigationBar.appearance.paddingTop - NavigationBar.appearance.paddingBottom) / 2;

        rightButtonGroup.x = actualWidth - rightButtonGroup.width - NavigationBar.appearance.paddingRight;
        rightButtonGroup.y = NavigationBar.appearance.paddingTop + (actualHeight - rightButtonGroup.height - NavigationBar.appearance.paddingTop - NavigationBar.appearance.paddingBottom) / 2;

        layoutTitle();
        layoutSearchBar();
    }

    private function layoutTitle(): void {
        titleView.maxWidth = rightButtonGroup.x - (leftButtonGroup.x + leftButtonGroup.width);
        titleView.validate();
        titleView.x = (actualWidth - titleView.width) / 2;
        titleView.y = NavigationBar.appearance.paddingTop + (actualHeight - titleView.height - NavigationBar.appearance.paddingTop - NavigationBar.appearance.paddingBottom) / 2;
    }

    private function layoutSearchBar(): void {
        var existedSearchBar: SearchBar = findSearchBar();
        if (existedSearchBar == null) {
            return;
        }
        if (_navigationItem.searchController.hidesNavigationBarDuringPresentation) {
            existedSearchBar.x = 0;
            existedSearchBar.y = 0;
            existedSearchBar.width = actualWidth;
            existedSearchBar.height = actualHeight;
        }
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
                if (skin.filter) {
                    skin.filter.dispose();
                }
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

    //-------------------------------------
    //  Back button
    //-------------------------------------

    private function createBackButtonItem(): BarButtonItem {
        var navigationBar:NavigationBar = _owner as NavigationBar;

        var backButtonItem: BarButtonItem = _navigationItem.backBarButtonItem;

        if (backButtonItem == null) {
            backButtonItem = new BarButtonItem();
            backButtonItem.defaultIcon = null; // TBA
            backButtonItem.label = "Back";
        }

        backButtonItem.triggered = function(): void {
            navigationBar.notifyBackCallbacks();
        };

        return backButtonItem;
    }

    //-------------------------------------
    //  Left items
    //-------------------------------------

    private function createLeftButtonGroup(): ButtonGroup {
        var navigationBar:NavigationBar = _owner as NavigationBar;

        var group: ButtonGroup = new ButtonGroup();
        group.direction = Direction.HORIZONTAL;
        group.gap = 16;
        group.customButtonStyleName = navigationBar.leftItemStyleName;
        return group;
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

    //-------------------------------------
    //  Right items
    //-------------------------------------

    private function createRightButtonGroup(): ButtonGroup {
        var navigationBar:NavigationBar = _owner as NavigationBar;
        var group: ButtonGroup = new ButtonGroup();
        group.direction = Direction.HORIZONTAL;
        group.gap = 16;
        group.customButtonStyleName = navigationBar.rightItemStyleName;
        return group;
    }

    private function composeRightItems(): IListCollection {
        return new ListCollection(_navigationItem.rightItems);
    }
}
}
