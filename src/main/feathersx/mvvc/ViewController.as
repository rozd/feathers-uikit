/**
 * Created by max.rozdobudko@gmail.com on 7/22/17.
 */
package feathersx.mvvc {
import avmplus.getQualifiedClassName;

import feathers.controls.ScreenNavigator;
import feathers.controls.Scroller;
import feathers.core.PopUpManager;
import feathers.events.FeathersEventType;
import feathers.motion.Cover;
import feathers.motion.Reveal;

import feathersx.data.EdgeInsets;

import flash.geom.Rectangle;

import skein.logger.Log;

import skein.utils.StringUtil;

import starling.core.Starling;

import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Stage;
import starling.events.Event;
import starling.events.ResizeEvent;

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
                if (drawersController.isTopViewControllerShown()) {
                    return findTopmostViewControllerRecursively(drawersController.topViewController);
                } else if (drawersController.isLeftViewControllerShown()) {
                    return findTopmostViewControllerRecursively(drawersController.leftViewController);
                } else if (drawersController.isBottomViewControllerShown()) {
                    return findTopmostViewControllerRecursively(drawersController.bottomViewController);
                } else if (drawersController.isRightViewControllerShown()) {
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
        trace(this);
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
    protected function setPresentingViewController(vc: ViewController) {
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
    //  Work Layout
    //
    //--------------------------------------------------------------------------

    public function get safeArea(): EdgeInsets {
        var top: int = navigationController ? navigationController.getTopGuide() : 0;
        var bottom: int = navigationController ? navigationController.getBottomGuide() : 0;
        return new EdgeInsets(top, 0, bottom, 0);
    }

    private var _additionalSafeAreaInsets: EdgeInsets;
    public function get additionalSafeAreaInsets(): EdgeInsets {
        return _additionalSafeAreaInsets;
    }
    public function set additionalSafeAreaInsets(value: EdgeInsets): void {
        _additionalSafeAreaInsets = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Work with View
    //
    //--------------------------------------------------------------------------

    protected var _view:DisplayObject;
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

    protected function loadView():DisplayObject {
        return null;
    }

    protected function loadViewIfRequired(): void {
        if (_view == null) {
            viewWillLoad();
            _view = loadView();
            var topGuide: Number    = safeArea.top    + (_additionalSafeAreaInsets ? _additionalSafeAreaInsets.top    : 0);
            var leftGuide: Number   = safeArea.left   + (_additionalSafeAreaInsets ? _additionalSafeAreaInsets.left   : 0);
            var bottomGuide: Number = safeArea.bottom + (_additionalSafeAreaInsets ? _additionalSafeAreaInsets.bottom : 0);
            var rightGuide: Number  = safeArea.right  + (_additionalSafeAreaInsets ? _additionalSafeAreaInsets.right  : 0);
            if (_view is View) {
                View(_view).topGuide = topGuide;
                View(_view).bottomGuide = rightGuide;
            } else if (_view is Scroller && _automaticallyAdjustsScrollerInsets) {
                Scroller(_view).paddingTop    = topGuide;
                Scroller(_view).paddingLeft   = leftGuide;
                Scroller(_view).paddingBottom = bottomGuide;
                Scroller(_view).paddingRight  = rightGuide;
            }
            viewDidLoad();
            _view.addEventListener(FeathersEventType.INITIALIZE, function (event:Event):void {
                _view.removeEventListener(FeathersEventType.INITIALIZE, arguments.callee);
            });
            _view.addEventListener(FeathersEventType.TRANSITION_IN_START, function (event:Event):void {
//                _view.removeEventListener(FeathersEventType.TRANSITION_IN_START, arguments.callee);
            });
            _view.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, function (event:Event):void {
//                _view.removeEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, arguments.callee);
                viewDidAppear();
            });
            _view.addEventListener(FeathersEventType.TRANSITION_OUT_START, function (event:Event):void {
//                _view.removeEventListener(FeathersEventType.TRANSITION_OUT_START, arguments.callee);
                viewWillDisappear();
            });
            _view.addEventListener(FeathersEventType.TRANSITION_OUT_COMPLETE, function (event:Event):void {
//                _view.removeEventListener(FeathersEventType.TRANSITION_OUT_COMPLETE, arguments.callee);
            });
            _view.addEventListener(Event.ADDED_TO_STAGE, function (event: Event):void {
                viewWillAppear();
            });
            _view.addEventListener(Event.REMOVED_FROM_STAGE, function (event: Event): void {
                viewDidDisappear();
            });
        }
    }

    //------------------------------------
    //  View Lifecycle
    //------------------------------------

    protected function viewWillLoad():void {

    }

    protected function viewDidLoad():void {

    }

    protected function viewWillAppear():void {

    }

    protected function viewDidAppear():void {

    }

    protected function viewWillDisappear():void {

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

    //-------------------------------------
    //  Showing View Controller
    //-------------------------------------

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

    //-------------------------------------
    //  Presenting View Controller
    //-------------------------------------

    public function present(vc: ViewController, animated: Boolean, completion: Function = null): void {
        if (presentedViewController != null) {
            Log.w("feathers-mvvm", StringUtil.substitute("Warning: Attempt to present {0} on {1} which is already presenting {2}", vc, this, presentedViewController));
            return;
        }

        vc.setPresentingViewController(this);
        PopUpManager.root.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
        if (vc is AlertController) {
            AlertController(vc).showAlertFromViewController(this);
        } else {
            vc.view.width = view.stage.stageWidth;
            vc.view.height = view.stage.stageHeight;
            PopUpManager.addPopUp(vc.view, vc.isModalInPopover, false);
        }
        this.setPresentedViewController(vc);
        layoutPresentedViewController();
    }

    public function replaceWithViewController(vc: ViewController, animated: Boolean, completion: Function = null): void {

    }

    public function dismiss(animated: Boolean, completion: Function = null): void {

        if (presentedViewController == null) {
            if (presentingViewController != null) {
                presentingViewController.dismiss(animated, completion);
            } else {
                setAsRootViewController(null);
            }

            return;
        }

        presentedViewController.setPresentingViewController(null);

        if (presentedViewController is AlertController) {
            AlertController(presentedViewController).hideAlertFromViewController(this);
        } else if (PopUpManager.isPopUp(presentedViewController.view)) {
            PopUpManager.root.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
            PopUpManager.removePopUp(presentedViewController.view);
            presentedViewController.view.dispose();
        } else {
            navigator.showScreen(this.identifier, Reveal.createRevealDownTransition());
        }

        this.setPresentedViewController(null);
    }

    protected function layoutPresentedViewController(): void {
        if (presentedViewController == null) {
            return;
        }

        var stage:Stage = Starling.current.stage;
        var view:DisplayObject = presentedViewController.view;

        switch (presentedViewController.modalPresentationStyle) {
            case ModalPresentationStyle.fullScreen :
                view.x = 0;
                view.y = 0;
                view.width = stage.stageWidth;
                view.height = stage.stageHeight;
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

    public function performSegue() {

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

    public function setAsRootViewController(root: DisplayObjectContainer):void {
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
        if (isViewLoaded) {
            this.view.dispose();
        }
        if (_navigator) {
            _navigator.dispose();
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function stage_resizeHandler(event: Event): void {
        layoutPresentedViewController();
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