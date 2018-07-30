/**
 * Created by max.rozdobudko@gmail.com on 7/29/17.
 */
package feathersx.mvvc {
import feathers.controls.Button;
import feathers.controls.StackScreenNavigator;
import feathers.motion.Fade;

import feathersx.core.feathers_mvvc;
import feathersx.motion.Slide;
import feathersx.mvvc.support.StackScreenNavigatorHolderHelper;

import flash.debugger.enterDebugger;
import flash.geom.Point;

import starling.animation.Transitions;

public class NavigationBar extends StackScreenNavigator {

    public static const TITLE_STYLE_NAME:String = "feathers-mvvc-navigation-bar-title";
    public static const LEFT_ITEM_STYLE_NAME:String = "feathers-mvvc-navigation-bar-left-item";
    public static const RIGHT_ITEM_STYLE_NAME:String = "feathers-mvvc-navigation-bar-right-item";

    public static const appearance: NavigationBarAppearance = new NavigationBarAppearance();

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function NavigationBar() {
        super();
        height = appearance.height;
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

    public function notifyBackCallbacks(): Boolean {
        if (onBack == null) {
            return false;
        }

        onBack();

        return true;
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
        if (animated) {
            var onProgress:Function = function(progress:Number): void {};
            var onComplete:Function = function(): void {};
            return Slide.createSlideLeftTransition(0.5, Transitions.EASE_OUT, null, onProgress, onComplete);
        } else {
            return null;
        }
    }

    protected function getPopTransition(animated:Boolean): Function {
        if (animated) {
            var onProgress:Function = function(progress:Number): void {};
            var onComplete:Function = function(): void {};
            return Slide.createSlideRightTransition(0.5, Transitions.EASE_OUT, null, onProgress, onComplete);
        } else {
            return null;
        }
    }

    protected function getPopToRootTransition(animated: Boolean): Function {
        return getPopTransition(animated);
    }

    private function getReplaceTransition(animated: Boolean): Function {
        if (animated) {
            return Fade.createFadeInTransition();
        } else {
            return null;
        }
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

        _items.push(item);

        doPushNavigationItem(item, animated, null);
    }

    public function popItem(animated: Boolean): NavigationItem {
        if (_items.length == 0) {
            return null;
        }

        if (_items.length == 1) {
            return _items[0];
        }

        var popped: NavigationItem = _items.pop();

        doPopNavigationItem(popped, animated, null);

        return popped;
    }

    public function popToRootItem(animated: Boolean): Vector.<NavigationItem> {
        if (_items.length == 0) {
            return null;
        }

        if (_items.length == 1) {
            return null;
        }

        var popped: Vector.<NavigationItem> = _items.slice(1, _items.length - 1);
        doPopToRootNavigationItem(popped, animated, null);

        return popped;
    }

    public function setItems(items: Vector.<NavigationItem>, animated: Boolean): void {

        var delaySettingItems: Boolean = false;

        if (items.length > 0) {
            if (activeScreenID == null) {
                var newRootItem: NavigationItem = items[0];
                setRootNavigationItem(newRootItem, null);
            } else {
                var newTopItem: NavigationItem = items[items.length - 1];
                replaceTopNavigationItem(newTopItem, animated, function ():void {
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
        if (items == _items) {
            enterDebugger();
            return;
        }

        var helper: StackScreenNavigatorHolderHelper = new StackScreenNavigatorHolderHelper(navigator);

        for each (var oldItem: NavigationItem in _items) {
            if (items.indexOf(oldItem) != -1) {
                continue;
            }
            var oldScreen: NavigationBarStackScreenNavigatorItem = navigator.getScreen(oldItem.identifier) as NavigationBarStackScreenNavigatorItem;
            oldScreen.release();
            helper.removeScreenWithId(oldItem.identifier, null);
        }

        for each (var newItem: NavigationItem in items) {
            if (hasScreen(newItem.identifier)) {
                continue;
            }
            var newScreen: NavigationBarStackScreenNavigatorItem = navigator.getScreen(newItem.identifier) as NavigationBarStackScreenNavigatorItem;
            newScreen.retain();
            helper.addScreenWithId(newItem.identifier, newScreen, null);
        }

        _items = items;
    }

    //--------------------------------------------------------------------------
    //
    //  Work with Navigator
    //
    //--------------------------------------------------------------------------

    public function get navigator(): StackScreenNavigator {
        return this;
    }

    // MARK: StackScreenNavigator utils

    protected function doPushNavigationItem(item: NavigationItem, animated: Boolean, completion: Function): void {
        var screen: NavigationBarStackScreenNavigatorItem = new NavigationBarStackScreenNavigatorItem(item);
        screen.retain();

        var transition: Function = getPushTransition(animated);

        new StackScreenNavigatorHolderHelper(navigator).pushScreenWithId(item.identifier, screen, transition, completion);
    }

    protected function doPopNavigationItem(item: NavigationItem, animated: Boolean, completion: Function): void {
        var screen: NavigationBarStackScreenNavigatorItem = navigator.getScreen(item.identifier) as NavigationBarStackScreenNavigatorItem;
        screen.release();

        var transition: Function = getPopTransition(animated);

        new StackScreenNavigatorHolderHelper(navigator).popScreenWithId(item.identifier, transition, completion);
    }

    protected function doPopToRootNavigationItem(items: Vector.<NavigationItem>, animated: Boolean, completion: Function): void {
        var ids: Vector.<String> = new <String>[];
        items.forEach(function (vc: NavigationItem, ...rest): void {
            ids.push(vc.identifier);
        });

        for (var i: int = 0; i < ids.length; i++) {
            var screen: NavigationBarStackScreenNavigatorItem = navigator.getScreen(ids[i]) as NavigationBarStackScreenNavigatorItem;
            screen.release();
        }

        var transition: Function = getPopToRootTransition(animated);

        new StackScreenNavigatorHolderHelper(navigator).popToRootScreenWithIds(ids, transition, completion);
    }

    protected function setRootNavigationItem(item: NavigationItem, completion: Function): void {
        var screen: NavigationBarStackScreenNavigatorItem = new NavigationBarStackScreenNavigatorItem(item);
        screen.retain();

        new StackScreenNavigatorHolderHelper(navigator).setRootScreenWithId(item.identifier, screen, completion);
    }

    protected function replaceTopNavigationItem(item: NavigationItem, animated: Boolean, completion: Function): void {
        var screen: NavigationBarStackScreenNavigatorItem = new NavigationBarStackScreenNavigatorItem(item);
        screen.retain();

        var transition: Function = getReplaceTransition(animated);

        new StackScreenNavigatorHolderHelper(navigator).replaceScreenWithId(item.identifier, screen, transition, completion);
    }

    //--------------------------------------------------------------------------
    //
    //  Appearance
    //
    //--------------------------------------------------------------------------

    //------------------------------------
    //  isTranslucent
    //------------------------------------

    private var _isTranslucent: Boolean = false;
    public function get isTranslucent(): Boolean {
        return _isTranslucent;
    }
    public function set isTranslucent(value: Boolean): void {
        _isTranslucent = value;
    }

    //------------------------------------
    //  isTransparent
    //------------------------------------

    private var _isTransparent:Boolean = false;
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

import feathersx.mvvc.NavigationBarContent;
import feathersx.mvvc.NavigationItem;
import feathersx.mvvc.NavigatorItem;

import starling.display.DisplayObject;

//--------------------------------------------------------------------------
//
//  NavigationItemNavigatorItem
//
//--------------------------------------------------------------------------

class NavigationBarStackScreenNavigatorItem extends StackScreenNavigatorItem implements NavigatorItem {

    public function NavigationBarStackScreenNavigatorItem(item: NavigationItem) {
        super(null, item.pushTransition, item.popTransition);
        _item = item;
    }

    private var _item: NavigationItem;

    private var _retained: Boolean = false;
    override public function get canDispose(): Boolean {
        return !_retained;
    }

    private var _navigationBarContent: DisplayObject;
    override public function getScreen():DisplayObject {
        if (_navigationBarContent == null) {
            _navigationBarContent = new NavigationBarContent(_item);
        }
        return _navigationBarContent;
    }

    public function disposeIfNeeded(): void {
        if (_navigationBarContent == null) {
            return;
        }

        _navigationBarContent.dispose();
        _navigationBarContent = null;
    }

    public function retain():void {
        trace("retain", _item.identifier);
        _retained = true;
    }

    public function release():void {
        trace("release", _item.identifier);
        _retained = false;
    }
}

//--------------------------------------------------------------------------
//
//  NavigationBarContent
//
//--------------------------------------------------------------------------

