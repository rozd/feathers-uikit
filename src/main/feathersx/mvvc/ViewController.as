/**
 * Created by max.rozdobudko@gmail.com on 7/22/17.
 */
package feathersx.mvvc {
import avmplus.getQualifiedClassName;

import feathers.controls.LayoutGroup;
import feathers.controls.ScreenNavigator;
import feathers.controls.Scroller;
import feathers.core.IFeathersControl;
import feathers.core.PopUpManager;
import feathers.events.FeathersEventType;
import feathers.motion.Cover;
import feathers.motion.Reveal;
import feathers.utils.display.getDisplayObjectDepthFromStage;

import feathersx.core.feathers_mvvc;
import feathersx.data.EdgeInsets;
import feathersx.mvvc.integration.Integration;

import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

import skein.logger.Log;
import skein.utils.StringUtil;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Stage;
import starling.events.Event;
import starling.events.ResizeEvent;

use namespace feathers_mvvc;

public class ViewController {

    //--------------------------------------------------------------------------
    //
    //  Static methods
    //
    //--------------------------------------------------------------------------

    public static function topmostViewController(vc: ViewController): ViewController {
        if (vc == null) {
            return null;
        }

        function findTopmostViewControllerRecursively(vc: ViewController): ViewController {
            if (vc.presentedViewController && !(vc.presentedViewController is AlertController)) {
                return findTopmostViewControllerRecursively(vc.presentedViewController);
            } else if (vc is NavigationController) {
                return findTopmostViewControllerRecursively(NavigationController(vc).topViewController);
            } else if (vc is DrawersController) {
                var drawersController: DrawersController = vc as DrawersController;
                if (drawersController.isTopViewControllerShown) {
                    return findTopmostViewControllerRecursively(drawersController.topViewController);
                } else if (drawersController.isLeftViewControllerShown) {
                    return findTopmostViewControllerRecursively(drawersController.leftViewController);
                } else if (drawersController.isBottomViewControllerShown) {
                    return findTopmostViewControllerRecursively(drawersController.bottomViewController);
                } else if (drawersController.isRightViewControllerShown) {
                    return findTopmostViewControllerRecursively(drawersController.rightViewController);
                } else {
                    return findTopmostViewControllerRecursively(drawersController.rootViewController);
                }
            } else {
                return vc;
            }
        }

        return findTopmostViewControllerRecursively(vc);
    }

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function ViewController() {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    // presentingViewController

    private var _presentingViewController: ViewController;
    public function get presentingViewController(): ViewController {
        if (_presentingViewController != null) {
            return _presentingViewController;
        }
        if (_navigationController != null) {
            return _navigationController.presentingViewController;
        }
        return null;
    }
    protected function setPresentingViewController(vc: ViewController): void {
        _presentingViewController = vc;
    }

    // presentedViewController

    private var _presentedViewController: ViewController;
    public function get presentedViewController(): ViewController {
        return _presentedViewController;
    }
    protected function setPresentedViewController(vc: ViewController): void {
        _presentedViewController = vc;
    }

    // automaticallyAdjustsScrollerPadding

    private var _automaticallyAdjustsScrollerInsets: Boolean = true;
    public function get automaticallyAdjustsScrollerInsets(): Boolean {
        return _automaticallyAdjustsScrollerInsets;
    }
    public function set automaticallyAdjustsScrollerInsets(value: Boolean): void {
        _automaticallyAdjustsScrollerInsets = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Navigation Controller
    //
    //--------------------------------------------------------------------------

    private var _navigationController: NavigationController;
    public function get navigationController(): NavigationController {
        return _navigationController;
    }
    public function setNavigationController(nc:NavigationController): void {
        _navigationController = nc;
    }

    private var _navigationItem: NavigationItem;
    public function get navigationItem(): NavigationItem {
        if (_navigationItem == null) {
            _navigationItem = new NavigationItem(this.identifier);
        }
        return _navigationItem;
    }

    private var _toolbarItems:Vector.<BarButtonItem>;
    public function get toolbarItems():Vector.<BarButtonItem> {
        return _toolbarItems;
    }
    public function set toolbarItems(value:Vector.<BarButtonItem>):void {
        _toolbarItems = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Drawers Controller
    //
    //--------------------------------------------------------------------------

    private var _drawersController:DrawersController;
    public function get drawersController(): DrawersController {
        if (_drawersController != null) {
            return _drawersController;
        }
        if (presentingViewController != null) {
            return presentingViewController.drawersController;
        }
        if (navigationController != null) {
            return navigationController.drawersController;
        }
        return null;
    }
    public function setDrawersController(value: DrawersController): void {
        _drawersController = value;
    }

    //--------------------------------------------------------------------------
    //
    //  MARK: - Work with Layout
    //
    //--------------------------------------------------------------------------

    public function get safeArea(): EdgeInsets {
        if (parent != null) {
            return new EdgeInsets(0, 0, 0, 0);
        }
        var insets: EdgeInsets = Integration.safeArea;
        if (navigationController) {
            insets.top = insets.top + navigationController.getTopGuide();
            insets.bottom = insets.bottom + navigationController.getBottomGuide();
        }
        return insets;
    }

    private var _additionalSafeAreaInsets: EdgeInsets = new EdgeInsets(0, 0, 0, 0);
    public function get additionalSafeAreaInsets(): EdgeInsets {
        return _additionalSafeAreaInsets;
    }
    public function set additionalSafeAreaInsets(value: EdgeInsets): void {
        _additionalSafeAreaInsets = value;
    }

    private function updateViewSafeArea(): void {
        var topGuide: Number    = safeArea.top    + (_additionalSafeAreaInsets ? _additionalSafeAreaInsets.top    : 0);
        var leftGuide: Number   = safeArea.left   + (_additionalSafeAreaInsets ? _additionalSafeAreaInsets.left   : 0);
        var bottomGuide: Number = safeArea.bottom + (_additionalSafeAreaInsets ? _additionalSafeAreaInsets.bottom : 0);
        var rightGuide: Number  = safeArea.right  + (_additionalSafeAreaInsets ? _additionalSafeAreaInsets.right  : 0);
        if (_view is View) {
            View(_view).topGuide = topGuide;
            View(_view).bottomGuide = bottomGuide;
        } else if (_view is Scroller && _automaticallyAdjustsScrollerInsets) {
            Scroller(_view).paddingTop    = topGuide;
            Scroller(_view).paddingLeft   = leftGuide;
            Scroller(_view).paddingBottom = bottomGuide;
            Scroller(_view).paddingRight  = rightGuide;
        }
    }

    private function installOrientationHandlers(view: DisplayObject): void {
        view.stage.starling.nativeStage.addEventListener("orientationChange", nativeStage_orientationChangeHandler);
    }

    private function removeOrientationHandlers(view: DisplayObject): void {
        view.stage.starling.nativeStage.removeEventListener("orientationChange", nativeStage_orientationChangeHandler);
    }

    private function nativeStage_orientationChangeHandler(event: Object): void {
        updateViewSafeArea();
    }

    //--------------------------------------------------------------------------
    //
    //  MARK: - Work with View
    //
    //--------------------------------------------------------------------------

    protected var _view: DisplayObject;
    public function get view(): DisplayObject {
        loadViewIfRequired();
        return _view;
    }
    public function set view(value: DisplayObject): void {
        _view = value;
    }

    public function get viewIfLoaded(): DisplayObject {
        return _view;
    }

    public function get isViewLoaded(): Boolean {
        return _view != null;
    }

    protected function loadView(): DisplayObject {
        var view: DisplayObject = new LayoutGroup();
        return view;
    }

    protected function loadViewIfRequired(): void {
        if (_view == null) {
            viewWillLoad();
            _view = loadView();
            updateViewSafeArea();
            _view.addEventListener(FeathersEventType.INITIALIZE, function(event:Event):void {
                _view.removeEventListener(FeathersEventType.INITIALIZE, arguments.callee);
            });
            _view.addEventListener(FeathersEventType.TRANSITION_IN_START, function(event:Event):void {
//                _view.removeEventListener(FeathersEventType.TRANSITION_IN_START, arguments.callee);
            });
            _view.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, function(event:Event):void {
//                _view.removeEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, arguments.callee);
                notifyViewDidAppear();
            });
            _view.addEventListener(FeathersEventType.TRANSITION_OUT_START, function(event:Event):void {
//                _view.removeEventListener(FeathersEventType.TRANSITION_OUT_START, arguments.callee);
                notifyViewWillDisappear();
            });
            _view.addEventListener(FeathersEventType.TRANSITION_OUT_COMPLETE, function(event:Event):void {
//                _view.removeEventListener(FeathersEventType.TRANSITION_OUT_COMPLETE, arguments.callee);
            });
            _view.addEventListener(Event.ADDED_TO_STAGE, function(event: Event): void {
                installHardKeysSupport(_view);
                installOrientationHandlers(_view);
                notifyViewWillAppear();
            });
            _view.addEventListener(Event.REMOVED_FROM_STAGE, function(event: Event): void {
                removeHardKeysSupport(_view);
                removeOrientationHandlers(_view);
                notifyViewDidDisappear();
            });
            if (_view is IFeathersControl) {
                IFeathersControl(_view).initializeNow();
            }
            viewDidLoad();
        }
    }

    protected function disposeViewIfLoaded(): void {
        if (_view != null) {
            _view.removeFromParent(true);
            _view = null;
        }
    }

    //  MARK: - View Lifecycle

    protected function viewWillLoad():void {

    }

    protected function viewDidLoad():void {

    }

    internal function notifyViewWillAppear(): void {
        viewWillAppear();
    }
    protected function viewWillAppear():void {

    }

    internal function notifyViewDidAppear(): void {
        viewDidAppear();
    }
    protected function viewDidAppear():void {

    }

    internal function notifyViewWillDisappear(): void {
        viewWillDisappear();
    }
    protected function viewWillDisappear():void {

    }

    internal function notifyViewDidDisappear(): void {
        viewDidDisappear();
    }
    protected function viewDidDisappear():void {

    }

    //--------------------------------------------------------------------------
    //
    //  Presenting View Controllers
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  presentationStyle
    //-------------------------------------

    protected var _modalPresentationStyle: ModalPresentationStyle = ModalPresentationStyle.fullScreen;
    public function get modalPresentationStyle(): ModalPresentationStyle {
        return _modalPresentationStyle;
    }
    public function set modalPresentationStyle(value: ModalPresentationStyle): void {
        _modalPresentationStyle = value;
    }

    //-------------------------------------
    //  isModalInPopover
    //-------------------------------------

    private var _isModalInPopover: Boolean = false;
    public function get isModalInPopover(): Boolean {
        return _isModalInPopover;
    }
    public function set isModalInPopover(value: Boolean): void {
        _isModalInPopover = value;
    }

    //  MARK: Showing View Controller

    public function show(vc: ViewController, sender: Object = null): void {
        if (_navigationController != null) {
            return;
        }

        if (navigator.hasScreen(vc.identifier)) {
            navigator.removeScreen(vc.identifier);
        }
        navigator.addScreen(vc.identifier, new ViewControllerNavigatorItem(vc));
        vc.setPresentingViewController(this);
        navigator.showScreen(vc.identifier, Cover.createCoverUpTransition());
        this.setPresentedViewController(vc);
    }

    public function showDetailViewController(vc: ViewController, sender: Object = null): void {
        if (_navigationController != null) {
            return;
        }
    }

    //  MARK: - Presenting View Controller

    public function present(vc: ViewController, animated: Boolean, completion: Function = null): void {
        if (presentedViewController != null) {
            Log.w("feathers-uikit", StringUtil.substitute("Warning: Attempt to present {0} on {1} which is already presenting {2}", vc, this, presentedViewController));
            return;
        }

        vc.setPresentingViewController(this);
        setPresentedViewController(vc);

        function onAdded(): void {
            presentedViewController.notifyViewDidAppear();
            if (completion != null) {
                completion();
            }
        }

        if (vc is AlertController) {
            presentAlertController(vc as AlertController, animated, onAdded);
        } else {
            presentViewController(vc, animated, onAdded);
        }
    }

    // MARK: - Dismissing View Controller

    public function dismiss(animated: Boolean, completion: Function = null): void {
        doDismiss(animated, true, completion);
    }

    public function dismissWithoutDisposing(animated: Boolean, completion: Function = null): void {
        doDismiss(animated, false, completion);
    }

    protected function doDismiss(animated: Boolean, shouldDispose: Boolean, completion: Function = null): void {
        if (presentedViewController == null) {
            if (presentingViewController != null) {
                presentingViewController.dismiss(animated, completion);
            } else {
                setAsRootViewController(null);
            }
            return;
        }

        function onRemoved(): void {
            presentedViewController.setPresentingViewController(null);
            setPresentedViewController(null);
            if (completion != null) {
                completion();
            }
        }

        presentedViewController.notifyViewWillDisappear();

        if (presentedViewController is AlertController) {
            dismissAlertController(presentedViewController as AlertController, animated, onRemoved);
        } else {
            dismissViewController(presentedViewController, animated, shouldDispose, onRemoved);
        }
    }

    // MARK: - Present & Dismiss Alert Controller

    protected function presentAlertController(vc: AlertController, animated: Boolean, completion: Function): void {
        AlertController(vc).showAlertFromViewController(this);
        // TODO: adds transition support
        completion();
    }

    private function dismissAlertController(vc: AlertController, animated: Boolean, completion: Function): void {
        AlertController(vc).hideAlertFromViewController(this);
        // TODO: adds transition support
        completion();
    }

    // MARK: - Present & Dismiss View Controller

    protected function presentViewController(vc: ViewController, animated: Boolean, completion: Function): void {
        PopUpManager.root.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);

        layoutPresentedViewController();

        PopUpManager.addPopUp(vc.view, vc.isModalInPopover, false);

        if (animated) {
            currentPresentTransition(this, vc, completion);
        } else {
            completion();
        }
    }

    private function dismissViewController(vc: ViewController, animated: Boolean, shouldDispose: Boolean, completion: Function): void {
        PopUpManager.root.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);

        function doRemovePopup(): void {
            PopUpManager.removePopUp(presentedViewController.view, shouldDispose);
            if (shouldDispose) {
                presentedViewController.dispose();
            }
            completion();
        }

        if (animated) {
            currentDismissTransition(this, presentedViewController, doRemovePopup);
        } else {
            doRemovePopup();
        }
    }

    // MARK: - Layout Presented View Controller

    protected function layoutPresentedViewController(): void {
        if (presentedViewController == null) {
            return;
        }

        var stage: Stage = Starling.current.stage;
        var view: DisplayObject = presentedViewController.view;

        switch (presentedViewController.modalPresentationStyle) {
            case ModalPresentationStyle.fullScreen :
                view.x = 0;
                view.y = 0;
                view.width = stage.stageWidth;
                view.height = stage.stageHeight;
                break;
        }
    }

    //  MARK: - Present & Dismiss Transitions

    // present transition

    protected static function defaultPresentTransition(presentingViewController: ViewController, presentedViewController: ViewController, completeCallback: Function): void {
        completeCallback();
    }

    public static var _presentTransition: Function;
    public static function get presentTransition(): Function {
        return _presentTransition;
    }
    public static function set presentTransition(value: Function): void {
        _presentTransition = value;
    }

    private var _presentTransition: Function;
    public function get presentTransition(): Function {
        return _presentTransition;
    }
    public function set presentTransition(value: Function): void {
        _presentTransition = value;
    }

    protected function get currentPresentTransition(): Function {
        return _presentTransition || ViewController._presentTransition || defaultPresentTransition;
    }

    // dismiss transition

    protected static function defaultDismissTransition(presentingViewController: ViewController, presentedViewController: ViewController, completeCallback: Function): void {
        completeCallback();
    }

    public static var _dismissTransition: Function;
    public static function get dismissTransition(): Function {
        return _dismissTransition;
    }
    public static function set dismissTransition(value: Function): void {
        _dismissTransition = value;
    }

    private var _dismissTransition: Function;
    public function get dismissTransition(): Function {
        return _dismissTransition;
    }
    public function set dismissTransition(value: Function): void {
        _dismissTransition = value;
    }

    protected function get currentDismissTransition(): Function {
        return _dismissTransition || ViewController._dismissTransition || defaultPresentTransition;
    }

    //--------------------------------------------------------------------------
    //
    //  Work with hard buttons
    //
    //--------------------------------------------------------------------------

    protected function backButtonDidTapped(): Boolean {
        if (navigationController && !navigationItem.hidesBackButton) {
            return navigationController.navigationBar.notifyBackCallbacks();
        }
        return false;
    }

    protected function menuButtonDidTapped(): Boolean {
        return false;
    }

    protected function searchButtonDidTapped(): Boolean {
        return false;
    }

    private function installHardKeysSupport(view: DisplayObject): void {
        var priority:int = -getDisplayObjectDepthFromStage(view);
        view.stage.starling.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler, false, priority, true);
    }

    private function removeHardKeysSupport(view: DisplayObject): void {
        view.stage.starling.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler);
    }

    private function nativeStage_keyDownHandler(event: KeyboardEvent): void {
        if (event.isDefaultPrevented()) {
            //someone else already handled this one
            return;
        }

        switch (event.keyCode) {
            case Keyboard.BACK:
                if (backButtonDidTapped()) {
                    event.preventDefault();
                }
                break;
            case Keyboard.MENU:
                menuButtonDidTapped();
                break;
            case Keyboard.SEARCH:
                searchButtonDidTapped();
                break;
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Work with Child view controllers
    //
    //--------------------------------------------------------------------------

    private var _isMovingFromParentViewController: Boolean = false;
    public function get isMovingFromParentViewController(): Boolean {
        return _isMovingFromParentViewController;
    }
    private var _isMovingToParentViewController: Boolean = false;
    public function get isMovingToParentViewController(): Boolean {
        return _isMovingToParentViewController;
    }

    private var _parent: ViewController;
    public function get parent(): ViewController {
        return _parent;
    }

    protected var _childViewControllers: Vector.<ViewController> = new <ViewController>[];
    public function get childViewControllers(): Vector.<ViewController> {
        return _childViewControllers;
    }

    public function addChildViewController(vc: ViewController): void {
        vc.willMoveToParentViewController(this);
        _childViewControllers.push(vc);
        vc.didMoveToParentViewController(this);
    }

    public function removeFromParentViewController(): void {
        _isMovingFromParentViewController = true;
        _parent._childViewControllers.removeAt(_parent._childViewControllers.indexOf(this));
        _parent = null;
        _isMovingFromParentViewController = false;
    }

    protected function willMoveToParentViewController(parent: ViewController): void {
        _parent = parent;
        _isMovingToParentViewController = true;
    }

    protected function didMoveToParentViewController(parent: ViewController): void {
        _parent = parent;
        _isMovingToParentViewController = false;
    }

    //--------------------------------------------------------------------------
    //
    //  Work with Segues
    //
    //--------------------------------------------------------------------------

    public function performSegue(): void {

    }

    //--------------------------------------------------------------------------
    //
    //  Work with Screen Navigator
    //
    //--------------------------------------------------------------------------

    public function get identifier(): String {
        return getQualifiedClassName(this);
    }

    private var _navigator: ScreenNavigator;
    private function get navigator(): ScreenNavigator {
        if (presentingViewController) {
            return presentingViewController.navigator;
        } else {
            return _navigator;
        }
    }

    //------------------------------------
    //  Work with Root
    //------------------------------------

    protected var _root: DisplayObjectContainer;
    public function get root(): DisplayObjectContainer {
        return _root;
    }

    public function setAsRootViewController(root: DisplayObjectContainer): void {
        if (_root != null) {
            cleanRootView();
        }
        _root = root;
        if (_root != null) {
            setupRootView();
        }
    }

    protected function cleanRootView(): void {
        if (_root != null) {
            _root.removeChild(_navigator);
            _navigator = null;
        }
    }

    protected function setupRootView(): void {
        if (_root == null) {
            throw new Error("[mvvc] root must be set.");
        }
        _navigator = new ScreenNavigator();
        _root.addChild(_navigator);
        _navigator.addScreen(this.identifier, new ViewControllerNavigatorItem(this));
        _navigator.showScreen(this.identifier);
    }

    public function dispose(): void {
        trace("dispose", this);
        disposeViewIfLoaded();
        if (_navigator) {
            _navigator.dispose();
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  Event handlers: stage
    //-------------------------------------

    private function stage_resizeHandler(event: Event): void {
        layoutPresentedViewController();
    }

    //-------------------------------------
    //  Event handlers: view
    //-------------------------------------

    //--------------------------------------------------------------------------
    //
    //  Description
    //
    //--------------------------------------------------------------------------

    public function toString(): String {
        return "[ViewController("+identifier+")]";
    }
}
}

//--------------------------------------------------------------------------
//
//  ViewControllerNavigatorItem
//
//--------------------------------------------------------------------------

import feathers.controls.ScreenNavigatorItem;

import feathersx.mvvc.ViewController;

import starling.display.DisplayObject;

class ViewControllerNavigatorItem extends ScreenNavigatorItem {
    public function ViewControllerNavigatorItem(vc: ViewController): void {
        super();
        _viewController = vc;
    }

    private var _viewController: ViewController;

    override public function get canDispose(): Boolean {
        return true;
    }

    override public function getScreen(): DisplayObject {
        return _viewController.view;
    }
}