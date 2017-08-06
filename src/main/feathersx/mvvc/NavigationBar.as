/**
 * Created by max.rozdobudko@gmail.com on 7/29/17.
 */
package feathersx.mvvc {
import feathers.controls.LayoutGroup;
import feathers.controls.StackScreenNavigator;
import feathers.controls.StackScreenNavigatorItem;
import feathers.events.FeathersEventType;
import feathers.motion.Fade;

import feathersx.motion.Slide;

import starling.animation.Transitions;
import starling.display.DisplayObject;
import starling.display.Quad;
import starling.events.Event;

public class NavigationBar extends StackScreenNavigator {

    public static const TITLE_STYLE_NAME:String = "feathers-mvvc-navigation-bar-title";
    public static const LEFT_ITEM_STYLE_NAME:String = "feathers-mvvc-navigation-bar-left-item";
    public static const RIGHT_ITEM_STYLE_NAME:String = "feathers-mvvc-navigation-bar-right-item";

    public static var PADDING:uint = 20;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function NavigationBar() {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var _items:Vector.<NavigationItem> = new <NavigationItem>[];

    //--------------------------------------------------------------------------
    //
    //  Callbacks
    //
    //--------------------------------------------------------------------------

    public var onBack:Function;

    public function notifyBackCallbacks():void
    {
        if (onBack != null) {
            onBack();
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Styles
    //
    //--------------------------------------------------------------------------

    private var _barTintColor:uint = 0xCCCCCC;
    public function get barTintColor(): uint {
        return _barTintColor;
    }
    public function set barTintColor(value: uint): void {
        _barTintColor = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Transition
    //
    //--------------------------------------------------------------------------

    protected function getPushTransition(animated:Boolean):Function {
        var onProgress:Function = function (progress:Number) {
        };
        var onComplete:Function = function () {
        };

        return Slide.createSlideLeftTransition(0.5, Transitions.EASE_OUT, null, onProgress, onComplete);
    }

    protected function getPopTransition(animated:Boolean):Function {
        var onProgress:Function = function (progress:Number) {
        };
        var onComplete:Function = function () {
        };

        return Slide.createSlideRightTransition(0.5, Transitions.EASE_OUT, null, onProgress, onComplete);
    }

    private function getReplaceTransition(animated: Boolean): Function {
        return Fade.createFadeInTransition();
    }

    //--------------------------------------------------------------------------
    //
    //  Push & Pop
    //
    //--------------------------------------------------------------------------

    public function get items(): Vector.<NavigationItem> {
        return _items;
    }

    public function pushItem(item: NavigationItem, animated: Boolean): void {
        addScreenWithNavigationItem(item);

        pushScreen(item.identifier, null, getPushTransition(animated));

        _items.push(item);
    }

    public function popItem(animated: Boolean): NavigationItem {
        popScreen(getPopTransition(animated));
        if (_items.length > 0) {
            return _items.pop();
        } else {
            return null;
        }
    }

    public function replaceWithNavigationItem(item: NavigationItem, animated: Boolean, completion: Function = null): void {
        addScreenWithNavigationItem(item);
        replaceScreen(item.identifier, getReplaceTransition(animated));
        addEventListener(FeathersEventType.TRANSITION_COMPLETE, function (event:Event):void {
            removeEventListener(FeathersEventType.TRANSITION_COMPLETE, arguments.callee);
            if (completion != null) {
                completion();
            }
        });
        addEventListener(FeathersEventType.TRANSITION_CANCEL, function (event:Event) {
            removeEventListener(FeathersEventType.TRANSITION_CANCEL, arguments.callee);
            if (completion != null) {
                completion();
            }
        });
    }

    public function setItems(items: Vector.<NavigationItem>, animated: Boolean): void {

        var delaySettingItems: Boolean = false;

        if (items.length > 0) {
            if (activeScreenID == null) {
                var newRootItem: NavigationItem = items[0];
                addScreenWithNavigationItem(newRootItem);
                rootScreenID = newRootItem.identifier;
            } else {
                var newTopItem: NavigationItem = items[items.length - 1];
                replaceWithNavigationItem(newTopItem, animated, function () {
                    setItemsInternal(items);
                });
                delaySettingItems = true;
            }
        }

        if (!delaySettingItems) {
            setItemsInternal(items);
        }
    }

    private function setItemsInternal(items: Vector.<NavigationItem>): void {
        for each (var oldItem: NavigationItem in _items) {
            if (items.indexOf(oldItem) != -1) {
                continue;
            }
            removeScreenWithNavigationItem(oldItem);
        }
        for each (var newItem: NavigationItem in items) {
            if (hasScreen(newItem.identifier)) {
                continue;
            }
            addScreenWithNavigationItem(newItem);
        }

        _items = items;
    }

    //--------------------------------------------------------------------------
    //
    //  Work with Navigator
    //
    //--------------------------------------------------------------------------

    private function addScreenWithNavigationItem(item: NavigationItem): void {
        if (hasScreen(item.identifier)) {
            removeScreen(item.identifier);
        }
        addScreen(item.identifier, new StackScreenNavigatorItem(function(){
            return createNavigationBarContentFor(item);
        }));
    }

    private function removeScreenWithNavigationItem(item: NavigationItem): void {
        if (hasScreen(item.identifier)) {
            removeScreen(item.identifier);
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Work with Content
    //
    //--------------------------------------------------------------------------

    private function createNavigationBarContentFor(item:NavigationItem): NavigationBarContent {
        var content:NavigationBarContent = new NavigationBarContent(item);
        content.backgroundSkin = new Quad(100, 100, _barTintColor);
        if (_isTransparent) {
            content.backgroundSkin.visible = false;
        }
        return content;
    }

    //--------------------------------------------------------------------------
    //
    //  Appearance
    //
    //--------------------------------------------------------------------------

    //------------------------------------
    //  isTranslucent
    //------------------------------------

    private var _isTranslucent: Boolean;
    public function get isTranslucent(): Boolean {
        return _isTranslucent;
    }
    public function set isTranslucent(value: Boolean): void {
        _isTranslucent = value;
    }

    //------------------------------------
    //  isTransparent
    //------------------------------------

    private var _isTransparent:Boolean;
    public function get isTransparent(): Boolean {
        return _isTransparent;
    }

    public function set isTransparent(value: Boolean): void {
        _isTransparent = value;
    }

    //------------------------------------
    //  titleStyleName
    //------------------------------------

    private var _titleStyleName:String;
    public function get titleStyleName(): String {
        return _titleStyleName || TITLE_STYLE_NAME;
    }

    public function set titleStyleName(value: String): void {
        _titleStyleName = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Background
    //
    //--------------------------------------------------------------------------

    private var _background:DisplayObject;

    private function createBackground(): void {
        if (_background == null) {
            _background = new Quad(100, 100, 0xFF0000);
            _background.alpha = 0.5;
        }
    }
}
}

import feathers.controls.ButtonGroup;
import feathers.controls.Label;
import feathers.controls.Screen;
import feathers.core.FeathersControl;
import feathers.data.IListCollection;
import feathers.data.ListCollection;

import feathersx.mvvc.BarButtonItem;
import feathersx.mvvc.NavigationBar;
import feathersx.mvvc.NavigationItem;

//--------------------------------------------------------------------------
//
//  NavigationBarContent
//
//--------------------------------------------------------------------------

class NavigationBarContent extends Screen {

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function NavigationBarContent(navigationItem: NavigationItem): void {
        super();
        _navigationItem = navigationItem;
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

        leftButtonGroup = new ButtonGroup();
        leftButtonGroup.customButtonStyleName = NavigationBar.LEFT_ITEM_STYLE_NAME;
        addChild(leftButtonGroup);

        rightButtonGroup = new ButtonGroup();
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
        rightButtonGroup.y = (actualHeight - rightButtonGroup.width) / 2;

        titleView.maxWidth = rightButtonGroup.x - (leftButtonGroup.x + leftButtonGroup.width);
        titleView.validate();
        titleView.x = (actualWidth - titleView.width) / 2;
        titleView.y = (actualHeight - titleView.height) / 2;
    }

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

        var item: BarButtonItem = new BarButtonItem();
        item.triggered = function () {
            navigationBar.notifyBackCallbacks();
        };

        item.label = "Back";

        return item;
    }

    private function composeLeftItems(): IListCollection {
        var items:Vector.<BarButtonItem> = new <BarButtonItem>[];
        if (_navigationItem.leftItems == null || _navigationItem.leftItems.length == 0) {
            items.push(createBackButtonItem());
        } else {
            if (_navigationItem.leftItemsSupplementBackButton) {
                items.push(createBackButtonItem());
            }
            items = items.concat(_navigationItem.leftItems);
        }
        return new ListCollection(items);
    }

    private function composeRightItems(): IListCollection {
        return new ListCollection(_navigationItem.rightItems);
    }
}