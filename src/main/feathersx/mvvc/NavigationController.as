/**
 * Created by max.rozdobudko@gmail.com on 7/22/17.
 */
package feathersx.mvvc {
import feathers.controls.AutoSizeMode;
import feathers.controls.LayoutGroup;
import feathers.controls.StackScreenNavigator;
import feathers.events.FeathersEventType;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.layout.VerticalLayout;
import feathers.layout.VerticalLayoutData;
import feathers.motion.Fade;

import feathersx.motion.Slide;
import feathersx.mvvc.support.StackScreenNavigatorHolderHelper;

import flash.debugger.enterDebugger;

import skein.core.WeakReference;

import starling.animation.Transitions;
import starling.display.DisplayObject;
import starling.display.DisplayObject;
import starling.display.DisplayObject;

import starling.display.DisplayObject;
import starling.display.Quad;
import starling.events.Event;

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

    override public function get isViewLoaded(): Boolean {
        return _navigator != null; // TODO(dev) if (isViewLoaded) { after loadView signature is changed
    }

    //--------------------------------------------------------------------------
    //
    //  Transition
    //
    //--------------------------------------------------------------------------

    protected function getPushTransition(animated:Boolean): Function {
        var onProgress:Function = function (progress:Number): void {
//            trace("onProgress: " + progress);
        };
        var onComplete:Function = function (): void {
//            trace("onComplete");
        };

        if (animated) {
            return Slide.createSlideLeftTransition(0.5, Transitions.EASE_OUT, null, onProgress, onComplete);
        } else {
            return null;
        }
    }

    protected function getPopTransition(animated:Boolean): Function {
        var onProgress:Function = function (progress:Number) {
//            trace("onProgress: " + progress);
        };
        var onComplete:Function = function () {
//            trace("onComplete");
        };

        if (animated) {
            return Slide.createSlideRightTransition(0.5, Transitions.EASE_OUT, null, onProgress, onComplete);
        } else {
            return null;
        }
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

        prepareScreenForViewController(vc, function (): void {
            pushScreenOfViewController(vc, animated, null);
        });
        _viewControllers.push(vc);

        _navigationBar.pushItem(vc.navigationItem, animated);

        _toolbar.setItems(topViewController.toolbarItems, true);
    }

    // Pop

    public function popViewController(animated: Boolean): ViewController {
        if (_viewControllers.length == 0) {
            return null;
        }

        if (_viewControllers.length == 1) {
            return _viewControllers[0];
        }

        var popped: ViewController = _viewControllers.pop();
        popScreenOfViewController(popped, animated, function(): void {
            disposeScreenOfViewController(popped, null);
        });

        _navigationBar.popItem(animated);

        _toolbar.setItems(topViewController.toolbarItems, true);

        return _viewControllers[_viewControllers.length - 1];
    }

    public function popToRootViewController(animated: Boolean): Vector.<ViewController> {
        if (_viewControllers.length == 0) {
            return null;
        }

        if (_viewControllers.length == 1) {
            return null;
        }

        var popped: Vector.<ViewController> = _viewControllers.splice(1, _viewControllers.length - 1);
        popToRootScreenOfViewControllers(popped, animated, function (): void {
            disposeScreensOfViewControllers(popped, null);
        });

        _navigationBar.popToRootItem(animated);

        _toolbar.setItems(topViewController.toolbarItems, animated);

        return popped;
    }

    public function popToViewController(viewController:ViewController, animated:Boolean): ViewController {
        return null;
    }

    protected function setRootViewController(vc:ViewController, completion: Function = null):void {

        prepareScreenForViewController(vc, function(): void {
            trackScreenTransitionStart(function (): void {
                _toolbar.setItems(vc.toolbarItems, true);
            });
            navigator.rootScreenID = vc.identifier;
        });

        trackScreenTransitionComplete(completion);
    }

    protected function replaceTopViewController(vc: ViewController, animated: Boolean, completion: Function): void {

        prepareScreenForViewController(vc, function(): void {
            trackScreenTransitionStart(function (): void {
                _toolbar.setItems(vc.toolbarItems, true);
            });
            navigator.replaceScreen(vc.identifier, getReplaceTransition(animated));
        });

        trackScreenTransitionComplete(completion);
    }

    private function trackScreenTransitionStart(handler: Function): void {
        navigator.addEventListener(FeathersEventType.TRANSITION_START, function(event: Event): void {
            navigator.removeEventListener(FeathersEventType.TRANSITION_START, arguments.callee);
            if (handler != null) {
                handler();
            }
        });
    }

    private function trackScreenTransitionComplete(handler: Function): void {
        navigator.addEventListener(FeathersEventType.TRANSITION_COMPLETE, function(event: Event): void {
            navigator.removeEventListener(FeathersEventType.TRANSITION_COMPLETE, arguments.callee);
            if (handler != null) {
                handler();
            }
        });
    }

    //--------------------------------------------------------------------------
    //
    //  Navigation Stack
    //
    //--------------------------------------------------------------------------

    protected var _proposedViewControllers: Vector.<ViewController>;

    // viewControllers

    protected var _viewControllers: Vector.<ViewController> = new <ViewController>[];
    public function get viewControllers(): Vector.<ViewController> {
        return _viewControllers;
    }

    // topViewController

    public function get topViewController(): ViewController {
        if (_viewControllers.length > 0) {
            return _viewControllers[_viewControllers.length - 1];
        }
        return null;
    }

    // setViewControllers

    public function setViewControllers(viewControllers: Vector.<ViewController>, animated: Boolean): void {
        if (!isViewLoaded) {
            _proposedViewControllers = viewControllers;
            return;
        }

        resetNavigationBar();

        if (viewControllers.length > 0) {
            if (navigator.activeScreenID == null) {
                var newRootViewController: ViewController = viewControllers[0];
                setRootViewController(newRootViewController, function(): void {
                    setViewControllersInternal(viewControllers);
                });
            } else {
                var newTopViewController: ViewController = viewControllers[viewControllers.length - 1];
                replaceTopViewController(newTopViewController, animated, function(): void {
                    setViewControllersInternal(viewControllers);
                });
            }
        }

        _navigationBar.setItems(navigationItemsFromViewControllers(viewControllers), animated);
    }

    private function setViewControllersInternal(viewControllers: Vector.<ViewController>): void {
        if (viewControllers == _viewControllers) {
            enterDebugger();
            return;
        }

        for each (var oldViewController: ViewController in _viewControllers) {
            if (viewControllers.indexOf(oldViewController) != -1) {
                continue;
            }
            disposeScreenOfViewController(oldViewController, null);
        }

        for each (var newViewController:ViewController in viewControllers) {
            if (navigator.hasScreen(newViewController.identifier)) {
                continue;
            }
            prepareScreenForViewController(newViewController, null);
        }

        _viewControllers = viewControllers;
    }

    protected function releaseViewControllers(viewControllers: Vector.<ViewController>):void {
        for each (var vc:ViewController in viewControllers) {
            vc.setNavigationController(null);
            var item: ViewControllerNavigatorItem = navigator.getScreen(vc.identifier) as ViewControllerNavigatorItem;
            item.release();
        }
    }

    // MARK: StackScreenNavigator utils

    protected function prepareScreenForViewController(vc: ViewController, completion: Function): void {

        var item: ViewControllerNavigatorItem = new ViewControllerNavigatorItem(vc);
        item.retain();

        vc.setNavigationController(this);

        new StackScreenNavigatorHolderHelper(navigator)
            .addScreenWithId(vc.identifier, item, function(): void {
                if (completion != null) {
                    completion();
                }
            });
    }

    protected function disposeScreenOfViewController(vc: ViewController, completion: Function): void {
        disposeScreensOfViewControllers(new <ViewController>[vc], completion);
    }

    protected function disposeScreensOfViewControllers(viewControllers: Vector.<ViewController>, completion: Function): void {

        var ids: Vector.<String> = new <String>[];
        viewControllers.forEach(function (vc: ViewController, ...rest): void {
            ids.push(vc.identifier);
        });

        for (var i: int = 0; i < ids.length; i++) {
            var item: ViewControllerNavigatorItem = navigator.getScreen(ids[i]) as ViewControllerNavigatorItem;
            item.release();
        }

        new StackScreenNavigatorHolderHelper(navigator)
            .removeScreenWithIds(ids, function (): void {
                viewControllers.forEach(function (vc: ViewController, ...rest): void {
                    vc.setNavigationController(null);
                });
                if (completion != null) {
                    completion();
                }
            });
    }

    protected function pushScreenOfViewController(vc: ViewController, animated: Boolean, completion: Function): DisplayObject {
        trackScreenTransitionComplete(completion);
        return navigator.pushScreen(vc.identifier, null, getPushTransition(animated));
    }

    protected function popScreenOfViewController(vc: ViewController, animated: Boolean, completion: Function): DisplayObject {
        trackScreenTransitionComplete(completion);
        return navigator.popScreen(getPopTransition(animated));
    }

    protected function popToRootScreenOfViewControllers(viewControllers: Vector.<ViewController>, animated: Boolean, completion: Function): DisplayObject {
        trackScreenTransitionComplete(completion);
        return navigator.popToRootScreen(getPopTransition(animated));
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

        _navigator = new StackScreenNavigator();
        _navigator.layoutData = new AnchorLayoutData(0, 0, 0, 0);
        view.addChild(_navigator);

        _navigationBar = new NavigationBar();
        _navigationBar.layoutData = new AnchorLayoutData(0, 0, NaN, 0);
        _navigationBar.onBack = navigationBarOnBack;
        view.addChild(_navigationBar);

        _toolbar = new Toolbar();
        _toolbar.layoutData = new AnchorLayoutData(NaN, 0, 0, 0);
        _toolbar.height = 64;
        _toolbar.visible = _toolbar.includeInLayout = !_isToolbarHidden;
        view.addChild(_toolbar);

        if (_proposedViewControllers) {
            setViewControllers(_proposedViewControllers, false);
            _proposedViewControllers = null;
        }

        return view;
    }

    private var _navigator:StackScreenNavigator;
    public function get navigator(): StackScreenNavigator {
        // TODO(dev) each nc has its own navigator
        if (presentingViewController is NavigationController) {
            return NavigationController(presentingViewController).navigator;
        } else {
            return _navigator;
        }
    }

    //--------------------------------------------------------------------------
    //
    //  NavigatorBar
    //
    //--------------------------------------------------------------------------

    private var _navigationBar:NavigationBar;
    public function get navigationBar(): NavigationBar {
        if (presentingViewController is NavigationController) {
            return NavigationController(presentingViewController).navigationBar;
        } else {
            return _navigationBar;
        }
    }

    private function navigationBarOnBack(): void {
        popViewController(true);
    }

    private function navigationItemsFromViewControllers(veiwControllers: Vector.<ViewController>): Vector.<NavigationItem> {
        var items: Vector.<NavigationItem> = new <NavigationItem>[];
        veiwControllers.forEach(function (vc: ViewController, index: int, vector:*):void {
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

    //--------------------------------------------------------------------------
    //
    //  Toolbar
    //
    //--------------------------------------------------------------------------

    private var _toolbar:Toolbar;
    public function get toolbar(): Toolbar {
        if (presentingViewController is NavigationController) {
            return NavigationController(presentingViewController).toolbar;
        } else {
            return _toolbar;
        }
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
}
}

//--------------------------------------------------------------------------
//
//  ViewControllerNavigatorItem
//
//--------------------------------------------------------------------------

import feathers.controls.StackScreenNavigatorItem;

import feathersx.mvvc.ViewController;

import starling.display.DisplayObject;

class ViewControllerNavigatorItem extends StackScreenNavigatorItem {
    public function ViewControllerNavigatorItem(vc: ViewController): void {
        super();
        _viewController = vc;
    }

    private var _retained: Boolean = false;
    private var _viewController: ViewController;

    override public function get canDispose(): Boolean {
        return !_retained;
    }

    override public function getScreen(): DisplayObject {
        return _viewController.view;
    }

    public function retain():void {
        trace("retain", _viewController.identifier);
        _retained = true;
    }

    public function release():void {
        trace("release", _viewController.identifier);
        _retained = false;
    }
}