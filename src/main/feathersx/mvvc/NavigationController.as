/**
 * Created by max.rozdobudko@gmail.com on 7/22/17.
 */
package feathersx.mvvc {
import feathers.controls.AutoSizeMode;
import feathers.controls.LayoutGroup;
import feathers.controls.StackScreenNavigator;
import feathers.controls.StackScreenNavigatorItem;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.motion.Fade;

import feathersx.motion.Slide;
import feathersx.mvvc.support.NavigationControllerStackScreenNavigator;
import feathersx.mvvc.support.StackScreenNavigatorHolderHelper;
import feathersx.mvvc.support.ViewControllerStackScreenNavigatorItem;

import flash.debugger.enterDebugger;

import skein.core.WeakReference;
import skein.logger.Log;
import skein.utils.StringUtil;
import skein.utils.VectorUtil;

import starling.animation.Transitions;
import starling.core.Starling;
import starling.display.DisplayObject;

public class NavigationController extends ViewController {

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function NavigationController(rootViewController: ViewController) {
        super();
        setViewControllers(new <ViewController>[rootViewController], false);
    }

    //--------------------------------------------------------------------------
    //
    //  Dispose
    //
    //--------------------------------------------------------------------------

    override public function dispose(): void {
        viewControllers.forEach(function (vc: ViewController, ...rest): void {
            vc.dispose();
        });

        setViewControllersInternal(new <ViewController>[]);

        super.dispose();
    }

    //--------------------------------------------------------------------------
    //
    //  Delegate
    //
    //--------------------------------------------------------------------------

    private var _delegate: WeakReference;
    public function get delegate(): NavigationControllerDelegate {
        return _delegate ? _delegate.value : null;
    }
    public function set delegate(value: NavigationControllerDelegate): void {
        _delegate = new WeakReference(value);
    }

    //--------------------------------------------------------------------------
    //
    //  View
    //
    //--------------------------------------------------------------------------

//    override public function get isViewLoaded(): Boolean {
//        trace(_navigator, _view);
//        return _navigator != null; // TODO(dev) if (isViewLoaded) { after loadView signature is changed
//    }

    //--------------------------------------------------------------------------
    //
    //  Transition
    //
    //--------------------------------------------------------------------------

    protected function getPushTransition(animated: Boolean): Function {
        if (animated) {
            var onProgress:Function = function (progress:Number): void {};
            var onComplete:Function = function (): void {};
            return Slide.createSlideLeftTransition(0.5, Transitions.EASE_OUT, null, onProgress, onComplete);
        } else {
            return null;
        }
    }

    protected function getPopTransition(animated: Boolean): Function {
        if (animated) {
            var onProgress:Function = function(progress:Number): void {};
            var onComplete:Function = function(): void {};
            return Slide.createSlideRightTransition(0.5, Transitions.EASE_OUT, null, onProgress, onComplete);
        } else {
            return null;
        }
    }

    private function getReplaceTransition(animated: Boolean): Function {
        if (animated) {
            return Fade.createFadeInTransition();
        } else {
            return function (oldScreen: DisplayObject, newScreen: DisplayObject, onComplete: Function): void {
                if (onComplete != null) {
                    onComplete();
                }
            }
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Push & Pop stack items
    //
    //--------------------------------------------------------------------------

    override public function show(vc: ViewController, sender: Object = null): void {
        pushViewController(vc, true);
    }

    // Push

    public function pushViewController(vc: ViewController, animated: Boolean):void {

        resetNavigationBar();

        if (delegate) {
            delegate.navigationControllerWillShow(this, vc, animated);
        }

        setupNavigationControllerForViewControllers(new <ViewController>[vc]);

        doPushScreenOfViewController(vc, animated, null);

        _navigationBar.pushItem(vc.navigationItem, animated);

        _toolbar.setItems(topViewController.toolbarItems, true);
    }

    // Pop

    public function popViewController(animated: Boolean): ViewController {
        if (viewControllers.length == 0) {
            return null;
        }

        if (viewControllers.length == 1) {
            return null;
        }

        var popped: ViewController = viewControllers[viewControllers.length - 1];
        doPopScreenOfViewController(popped, animated, function(): void {
            clearNavigationControllerForViewControllers(new <ViewController>[popped]);
        });

        _navigationBar.popItem(animated);

        _toolbar.setItems(topViewController.toolbarItems, true);

        return popped;
    }

    public function popToRootViewController(animated: Boolean): Vector.<ViewController> {
        if (viewControllers.length == 0) {
            return null;
        }

        if (viewControllers.length == 1) {
            return null;
        }

        var popped: Vector.<ViewController> = viewControllers.splice(1, viewControllers.length - 1);
        doPopToRootScreenOfViewControllers(popped, animated, function (): void {
            clearNavigationControllerForViewControllers(popped);
            popped.forEach(function(vc: ViewController, ...rest): void {
                vc.dispose();
            });
        });

        _navigationBar.popToRootItem(animated);

        _toolbar.setItems(topViewController.toolbarItems, animated);

        return popped;
    }

    public function popToViewController(viewController:ViewController, animated:Boolean): ViewController {
        return null;
    }

    //--------------------------------------------------------------------------
    //
    //  Navigation Stack
    //
    //--------------------------------------------------------------------------

    protected var _proposedViewControllers: Vector.<ViewController>;

    // viewControllers

    public function get viewControllers(): Vector.<ViewController> {
        return _navigator ? NavigationControllerStackScreenNavigator(_navigator).viewControllers : new <ViewController>[];
    }

    // topViewController

    public function get topViewController(): ViewController {
        if (viewControllers.length > 0) {
            return viewControllers[viewControllers.length - 1];
        }
        return null;
    }

    // setViewControllers

    public function setViewControllers(viewControllers: Vector.<ViewController>, animated: Boolean, completion: Function = null): void {
        if (!isViewLoaded) {
            _proposedViewControllers = viewControllers;
            return;
        }
        doSetViewControllers(viewControllers, animated, completion);
    }

    protected function doSetViewControllers(viewControllers: Vector.<ViewController>, animated: Boolean, completion: Function = null): void {

        resetNavigationBar();

        // TODO: handle empty viewControllers list

        if (viewControllers.length > 0) {
            if (navigator.activeScreenID == null) {
                var newRootViewController: ViewController = viewControllers[0];
                setupNavigationControllerForViewControllers(new <ViewController>[newRootViewController]);
                setRootViewController(newRootViewController, function(): void {
                    setViewControllersInternal(viewControllers);
                    if (completion != null) {
                        completion();
                    }
                });
                _toolbar.setItems(newRootViewController.toolbarItems, animated);
            } else {
                var newTopViewController: ViewController = viewControllers[viewControllers.length - 1];
                setupNavigationControllerForViewControllers(new <ViewController>[newTopViewController]);
                replaceTopViewController(newTopViewController, animated, function(): void {
                    setViewControllersInternal(viewControllers);
                    if (completion != null) {
                        completion();
                    }
                });
                _toolbar.setItems(newTopViewController.toolbarItems, animated);
            }
        }

        _navigationBar.setItems(navigationItemsFromViewControllers(viewControllers), animated);
    }

    protected function setViewControllersInternal(viewControllers: Vector.<ViewController>): void {
        if (viewControllers == this.viewControllers) {
            enterDebugger();
            return;
        }

        var helper: StackScreenNavigatorHolderHelper = new StackScreenNavigatorHolderHelper(navigator);

        // oldViewControllers

        var oldViewControllers: Vector.<ViewController> = this.viewControllers.filter(function(oldViewController: ViewController, ...rest): Boolean {
            return viewControllers.indexOf(oldViewController) == -1;
        });

        oldViewControllers.forEach(function (oldViewController: ViewController, ...rest): void {
            var oldScreen: ViewControllerStackScreenNavigatorItem = helper.getScreenWithId(oldViewController.identifier) as ViewControllerStackScreenNavigatorItem;
            if (oldScreen == null) {
                Log.w("feathers-uikit", StringUtil.substitute("Warning: attempt to release view controller's navigator item for view controller {0} failed due to {1} is an invalid navigator item.", oldViewController, helper.getScreenWithId(oldViewController.identifier)));
                return;
            }
            oldScreen.release();
        });

        var idsToRemove: Vector.<String> = idsForViewControllers(oldViewControllers).filter(function(id: String, ...rest): Boolean {
            return viewControllers.every(function(controller: ViewController, ...rest): Boolean {
                return controller.identifier != id;
            })
        });

        helper.removeScreenWithIds(idsToRemove, function(): void {
            clearNavigationControllerForViewControllers(oldViewControllers);
        });

        if (!VectorUtil.same(idsToRemove, idsForViewControllers(oldViewControllers))) {
            enterDebugger();
        }

        // newViewControllers

        var newViewControllers: Vector.<ViewController> = viewControllers.filter(function(newViewController: ViewController, ...rest): Boolean {
            return !helper.hasScreenWithId(newViewController.identifier);
        });

        helper.addScreensWithIds(idsForViewControllers(newViewControllers), screensForViewControllers(newViewControllers), function(): void {
            setupNavigationControllerForViewControllers(newViewControllers);
            newViewControllers.forEach(function (newViewController: ViewController, ...rest): void {
                var newScreen: ViewControllerStackScreenNavigatorItem = helper.getScreenWithId(newViewController.identifier) as ViewControllerStackScreenNavigatorItem;
                if (newScreen == null) {
                    Log.w("feathers-uikit", StringUtil.substitute("Warning: attempt to retain view controllers navigator item for view controller {0} failed due to {1} is an invalid navigator item.", newViewController, helper.getScreenWithId(newViewController.identifier)));
                    return;
                }
                newScreen.retain();
            });
        });
    }

    // MARK: StackScreenNavigator utils

    protected function doPushScreenOfViewController(vc: ViewController, animated: Boolean, completion: Function): void {
        var item: ViewControllerStackScreenNavigatorItem = new ViewControllerStackScreenNavigatorItem(vc);
        item.retain();

        var transition: Function = getPushTransition(animated);

        new StackScreenNavigatorHolderHelper(navigator).pushScreenWithId(vc.identifier, item, transition, completion);
    }

    protected function doPopScreenOfViewController(vc: ViewController, animated: Boolean, completion: Function): void {
        var item: ViewControllerStackScreenNavigatorItem = navigator.getScreen(vc.identifier) as ViewControllerStackScreenNavigatorItem;
        item.release();

        var transition: Function = getPopTransition(animated);

        new StackScreenNavigatorHolderHelper(navigator).popScreenWithId(vc.identifier, transition, completion);
    }

    protected function doPopToRootScreenOfViewControllers(viewControllers: Vector.<ViewController>, animated: Boolean, completion: Function): void {
        var ids: Vector.<String> = idsForViewControllers(viewControllers);
        ids.forEach(function(id: String, ...rest): void {
            var item: ViewControllerStackScreenNavigatorItem = navigator.getScreen(id) as ViewControllerStackScreenNavigatorItem;
            item.release();
        });

        var transition: Function = getPopTransition(animated);

        new StackScreenNavigatorHolderHelper(navigator).popToRootScreenWithIds(ids, transition, completion);
    }

    protected function setRootViewController(vc: ViewController, completion: Function = null):void {
        var item: ViewControllerStackScreenNavigatorItem = new ViewControllerStackScreenNavigatorItem(vc);
        item.retain();

        new StackScreenNavigatorHolderHelper(navigator).setRootScreenWithId(vc.identifier, item, completion);
    }

    protected function replaceTopViewController(vc: ViewController, animated: Boolean, completion: Function): void {
        var oldItem: ViewControllerStackScreenNavigatorItem = navigator.getScreen(navigator.activeScreenID) as ViewControllerStackScreenNavigatorItem;
        oldItem.release();

        var newItem: ViewControllerStackScreenNavigatorItem = new ViewControllerStackScreenNavigatorItem(vc);
        newItem.retain();

        var transition: Function = getReplaceTransition(animated);

        new StackScreenNavigatorHolderHelper(navigator).replaceScreenWithId(vc.identifier, newItem, transition, completion);
    }

    private function setupNavigationControllerForViewControllers(viewControllers: Vector.<ViewController>): void {
        var self: NavigationController = this;
        viewControllers.forEach(function (vc: ViewController, ...rest): void {
            vc.setNavigationController(self);
        });
    }

    private function clearNavigationControllerForViewControllers(viewControllers: Vector.<ViewController>): void {
        viewControllers.forEach(function (vc: ViewController, ...rest): void {
            vc.setNavigationController(null);
        });
    }

    //--------------------------------------------------------------------------
    //
    //  Stack Navigator
    //
    //--------------------------------------------------------------------------

    override protected function loadView(): DisplayObject {
        var view:LayoutGroup = new LayoutGroup();
        view.autoSizeMode = AutoSizeMode.STAGE;
        view.layout = new AnchorLayout();

        _navigator = new NavigationControllerStackScreenNavigator();
        _navigator.layoutData = new AnchorLayoutData(0, 0, 0, 0);
        view.addChild(_navigator);

        _navigationBar = new NavigationBar();
        _navigationBar.layoutData = new AnchorLayoutData(safeArea.top, 0, NaN, 0);
        _navigationBar.onBack = navigationBarOnBack;
        view.addChild(_navigationBar);

        _toolbar = new Toolbar();
        _toolbar.layoutData = new AnchorLayoutData(NaN, 0, 0, 0);
        _toolbar.height += safeArea.bottom;
        _toolbar.visible = _toolbar.includeInLayout = !_isToolbarHidden;
        view.addChild(_toolbar);

        if (_proposedViewControllers) {
            doSetViewControllers(_proposedViewControllers, false);
            _proposedViewControllers = null;
        }

        return view;
    }

    private var _navigator:StackScreenNavigator;
    public function get navigator(): StackScreenNavigator {
        return _navigator;
    }

    //--------------------------------------------------------------------------
    //
    //  NavigatorBar
    //
    //--------------------------------------------------------------------------

    private var _navigationBar: NavigationBar;
    public function get navigationBar(): NavigationBar {
        loadViewIfRequired();
        return _navigationBar;
    }

    private function navigationBarOnBack(): void {
        popViewController(true);
    }

    private function navigationItemsFromViewControllers(viewControllers: Vector.<ViewController>): Vector.<NavigationItem> {
        var items: Vector.<NavigationItem> = new <NavigationItem>[];
        viewControllers.forEach(function (vc: ViewController, index: int, vector:*):void {
            items[items.length] = vc.navigationItem;
        });
        return items;
    }

    public function getTopGuide():Number {
        if (navigationBar != null) {
            return navigationBar.height;
        } else {
            return 0;
        }
    }

    private function resetNavigationBar(): void {
        _navigationBar.resetAppearanceToDefault();
    }

    private var _isNavigationBarHidden: Boolean = false;
    public function get isNavigationBarHidden(): Boolean {
        return _isNavigationBarHidden;
    }
    public function set isNavigationBarHidden(value: Boolean): void {
        setNavigationBarHidden(value, false);
    }

    public function setNavigationBarHidden(hidden: Boolean, animated: Boolean): void {
        if (hidden == _isNavigationBarHidden) {
            return;
        }
        _isNavigationBarHidden = hidden;
        if (animated) {
            Starling.current.juggler.tween(_navigationBar, 0.3, {alpha: hidden ? 0.0 : 1.0});
        } else {
            _navigationBar.alpha = hidden ? 0.0 : 1.0;
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Toolbar
    //
    //--------------------------------------------------------------------------

    private var _toolbar:Toolbar;
    public function get toolbar(): Toolbar {
        return _toolbar;
    }

    private var _isToolbarHidden: Boolean = true;
    public function get isToolbarHidden(): Boolean {
        return _isToolbarHidden;
    }
    public function set isToolbarHidden(value: Boolean): void {
        setToolbarHidden(value, false);
    }

    public function setToolbarHidden(hidden: Boolean, animated: Boolean): void {
        _isToolbarHidden = hidden;
        if (_toolbar != null) {
            _toolbar.visible = _toolbar.includeInLayout = !_isToolbarHidden;
        }
    }

    public function getBottomGuide():Number {
        if (toolbar != null && !isToolbarHidden) {
            return toolbar.height;
        } else {
            return 0;
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Root
    //
    //--------------------------------------------------------------------------

    override protected function cleanRootView(): void {
        if (_root != null) {
            _root.removeChild(this.view);
        }
    }

    override protected function setupRootView(): void {
        if (_root == null) {
            throw new Error("[mvvc] root must be set.");
        }
        _root.addChild(this.view);
    }

    //--------------------------------------------------------------------------
    //
    //  Utils
    //
    //--------------------------------------------------------------------------

    protected function idsForViewControllers(viewControllers: Vector.<ViewController>): Vector.<String> {
        var ids: Vector.<String> = new <String>[];
        viewControllers.forEach(function (vc: ViewController, ...rest): void {
            ids.push(vc.identifier);
        });
        return ids;
    }

    protected function screensForViewControllers(viewControllers: Vector.<ViewController>): Vector.<StackScreenNavigatorItem> {
        var screens: Vector.<StackScreenNavigatorItem> = new <StackScreenNavigatorItem>[];
        viewControllers.forEach(function (vc: ViewController, ...rest): void {
            screens.push(new ViewControllerStackScreenNavigatorItem(vc));
        });
        return screens;
    }

    //--------------------------------------------------------------------------
    //
    //  Description
    //
    //--------------------------------------------------------------------------

    override public function toString(): String {
        return "[NavigationController("+identifier+")]";
    }
}
}
