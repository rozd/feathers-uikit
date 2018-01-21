/**
 * Created by max.rozdobudko@gmail.com on 7/29/17.
 */
package feathersx.mvvc {
import feathers.controls.Button;
import feathers.controls.StackScreenNavigator;
import feathers.events.FeathersEventType;
import feathers.motion.Fade;

import feathersx.core.feathers_mvvc;

import feathersx.motion.Slide;

import flash.geom.Point;

import starling.animation.Transitions;
import starling.events.Event;

public class NavigationBar extends StackScreenNavigator {

    public static const TITLE_STYLE_NAME:String = "feathers-mvvc-navigation-bar-title";
    public static const LEFT_ITEM_STYLE_NAME:String = "feathers-mvvc-navigation-bar-left-item";
    public static const RIGHT_ITEM_STYLE_NAME:String = "feathers-mvvc-navigation-bar-right-item";

    public static var PADDING:uint = 20;

    public static const Height: uint = 60;

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

    private var _barTintColor:uint = 0xFFFFFF;
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

    protected function getPushTransition(animated:Boolean): Function {
        var onProgress:Function = function (progress:Number) {
        };
        var onComplete:Function = function () {
        };

        if (animated) {
            return Slide.createSlideLeftTransition(0.5, Transitions.EASE_OUT, null, onProgress, onComplete);
        } else {
            return null;
        }
    }

    protected function getPopTransition(animated:Boolean): Function {
        var onProgress:Function = function (progress:Number) {
        };
        var onComplete:Function = function () {
        };

        if (animated) {
            return Slide.createSlideRightTransition(0.5, Transitions.EASE_OUT, null, onProgress, onComplete);
        } else {
            return null;
        }
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

    protected function setRootNavigationItem(item: NavigationItem, completion: Function = null): void {
        addScreenWithNavigationItem(item);
        rootScreenID = item.identifier;
        addEventListener(FeathersEventType.TRANSITION_START, function (event:Event):void {
            removeEventListener(FeathersEventType.TRANSITION_START, arguments.callee);
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
                setRootNavigationItem(newRootItem);
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
    //  leftItemStyleName
    //------------------------------------

    private var _leftItemStyleName:String;
    public function get leftItemStyleName(): String {
        return _leftItemStyleName || LEFT_ITEM_STYLE_NAME;
    }
    public function set leftItemStyleName(value: String): void {
        _leftItemStyleName = value;
    }

    //------------------------------------
    //  rightItemStyleName
    //------------------------------------

    private var _rightItemStyleName:String;
    public function get rightItemStyleName(): String {
        return _rightItemStyleName || LEFT_ITEM_STYLE_NAME;
    }
    public function set rightItemStyleName(value: String): void {
        _rightItemStyleName = value;
    }

    //------------------------------------
    //  Appearance methods
    //------------------------------------

    public function resetAppearanceToDefault():void {
        barTintColor = 0xFFFFFF;
        isTranslucent = false;
        isTransparent = false;
        titleStyleName = TITLE_STYLE_NAME;
        leftItemStyleName = LEFT_ITEM_STYLE_NAME;
        rightItemStyleName = RIGHT_ITEM_STYLE_NAME;
        shadowColor = uint.MAX_VALUE;
        shadowOffset = null;
        shadowRadius = NaN;
        shadowAlpha = NaN;
    }

    //--------------------------------------------------------------------------
    //
    //  Protected API
    //
    //--------------------------------------------------------------------------

    feathers_mvvc function getRightButtonAtIndex(index: int): Button {
        var content: NavigationBarContent = activeScreen as NavigationBarContent;
        if (content == null) {
            return null;
        }

        if (content.rightButtonGroup.numChildren == 0) {
            return null;
        }

        if (content.rightButtonGroup.numChildren < index) {
            return null;
        }

        return content.rightButtonGroup.getChildAt(index) as Button;
    }

    feathers_mvvc function getLeftButtonAtIndex(index: int): Button {
        var content: NavigationBarContent = activeScreen as NavigationBarContent;
        if (content == null) {
            return null;
        }

        if (content.leftButtonGroup.numChildren == 0) {
            return null;
        }

        if (content.leftButtonGroup.numChildren < index) {
            return null;
        }

        return content.leftButtonGroup.getChildAt(index) as Button;
    }
}
}

import feathers.controls.StackScreenNavigatorItem;

import starling.display.DisplayObject;

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

    private var _navigationBarContent: DisplayObject;

    override public function getScreen():DisplayObject {
        if (_navigationBarContent == null) {
            _navigationBarContent = super.getScreen();
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

