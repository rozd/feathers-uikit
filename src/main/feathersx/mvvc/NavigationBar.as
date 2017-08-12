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
import feathersx.mvvc.NavigationItem;

import flash.geom.Point;

import starling.animation.Transitions;
import starling.display.DisplayObject;
import starling.display.Quad;
import starling.events.Event;
import starling.filters.DropShadowFilter;

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

        resetAppearanceToDefault();

        pushScreen(item.identifier, null, getPushTransition(animated));

        _items.push(item);
        retainNavigationItems(new <NavigationItem>[item]);
    }

    public function popItem(animated: Boolean): NavigationItem {
        popScreen(getPopTransition(animated));
        if (_items.length > 0) {
            var item:NavigationItem = _items.pop();
            releaseNavigationItems(new <NavigationItem>[item]);
            return item;
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
        addEventListener(FeathersEventType.TRANSITION_CANCEL, function (event:Event):void {
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
                replaceWithNavigationItem(newTopItem, animated, function ():void {
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
        releaseNavigationItems(_items);

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

        retainNavigationItems(_items);
    }

    private function retainNavigationItems(navigationItems: Vector.<NavigationItem>):void {
        for each (var navigationItem:NavigationItem in navigationItems) {
            var item: NavigationBarStackScreenNavigatorItem = getScreen(navigationItem.identifier) as NavigationBarStackScreenNavigatorItem;
            item.retain();
        }
    }

    private function releaseNavigationItems(navigationItems: Vector.<NavigationItem>):void {
        for each (var vc:NavigationItem in navigationItems) {
            var item: NavigationBarStackScreenNavigatorItem = getScreen(vc.identifier) as NavigationBarStackScreenNavigatorItem;
            item.release();
        }
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
        addScreen(item.identifier, new NavigationBarStackScreenNavigatorItem(function(){
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

    //------------------------------------
    //  shadowColor
    //------------------------------------

    private var _shadowColor:uint = uint.MAX_VALUE;
    public function get shadowColor():uint {
        return _shadowColor;
    }
    public function set shadowColor(value:uint):void {
        _shadowColor = value;
    }

    //------------------------------------
    //  shadowOffset
    //------------------------------------

    private var _shadowOffset:Point;
    public function get shadowOffset():Point {
        return _shadowOffset;
    }
    public function set shadowOffset(value:Point):void {
        _shadowOffset = value;
    }

    //------------------------------------
    //  shadowRadius
    //------------------------------------

    private var _shadowRadius:Number;
    public function get shadowRadius():Number {
        return _shadowRadius;
    }
    public function set shadowRadius(value:Number):void {
        _shadowRadius = value;
    }

    //------------------------------------
    //  shadowAlpha
    //------------------------------------

    private var _shadowAlpha:Number;
    public function get shadowAlpha():Number {
        return _shadowAlpha;
    }
    public function set shadowAlpha(value:Number):void {
        _shadowAlpha = value;
    }

    //------------------------------------
    //  Appearance methods
    //------------------------------------

    private function resetAppearanceToDefault():void {
        isTranslucent = false;
        isTransparent = false;
        titleStyleName = TITLE_STYLE_NAME;
        shadowColor = uint.MAX_VALUE;
        shadowOffset = null;
        shadowRadius = NaN;
        shadowAlpha = NaN;
    }
}
}

import feathers.controls.ButtonGroup;
import feathers.controls.Label;
import feathers.controls.Screen;
import feathers.controls.StackScreenNavigatorItem;
import feathers.core.FeathersControl;
import feathers.data.IListCollection;
import feathers.data.ListCollection;

import feathersx.mvvc.BarButtonItem;
import feathersx.mvvc.NavigationBar;
import feathersx.mvvc.NavigationItem;

import flash.geom.Point;

import starling.display.DisplayObject;
import starling.display.Quad;
import starling.filters.DropShadowFilter;

//--------------------------------------------------------------------------
//
//  NavigationItemNavigatorItem
//
//--------------------------------------------------------------------------

class NavigationBarStackScreenNavigatorItem extends StackScreenNavigatorItem {

    public function NavigationBarStackScreenNavigatorItem(screen:Object = null, pushEvents:Object = null, popEvent:String = null, properties:Object = null) {
        super(screen, pushEvents, popEvent, properties);
    }

    private var _retained: Boolean = false;

    override public function get canDispose(): Boolean {
        return !_retained;
    }

    private var _navigationBarContent: NavigationBarContent;

    override public function getScreen():DisplayObject {
        if (_navigationBarContent == null) {
            _navigationBarContent = super.getScreen() as NavigationBarContent;
        }
        return _navigationBarContent;
    }

    public function retain():void {
        _retained = true;
    }

    public function release():void {
        _retained = false;
        _navigationBarContent = null;
    }
}

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

        backgroundSkin = createBackground();

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
        rightButtonGroup.y = (actualHeight - rightButtonGroup.width) / 2;

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