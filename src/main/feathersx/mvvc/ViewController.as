/**
 * Created by max.rozdobudko@gmail.com on 7/22/17.
 */
package feathersx.mvvc {
import avmplus.getQualifiedClassName;

import feathers.controls.ScreenNavigator;
import feathers.core.PopUpManager;
import feathers.events.FeathersEventType;
import feathers.motion.Cover;
import feathers.motion.Reveal;

import starling.core.Starling;

import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Stage;
import starling.events.Event;
import starling.events.ResizeEvent;

public class ViewController {

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function ViewController() {
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

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

    private var _presentedViewController: ViewController;
    public function get presentedViewController(): ViewController {
        return _presentedViewController;
    }
    protected function setPresentedViewController(vc: ViewController) {
        _presentedViewController = vc;
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
    public function setNavigationController(nc:NavigationController) {
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

    private function loadViewIfRequired(): void {
        if (_view == null) {
            viewWillLoad();
            _view = loadView();
            if (_view is View) {
                View(_view).topGuide = navigationController ? navigationController.getTopGuide() : 0;
                View(_view).bottomGuide = navigationController ? navigationController.getBottomGuide() : 0;
            }
            viewDidLoad();
            _view.addEventListener(FeathersEventType.INITIALIZE, function (event:Event):void {
                _view.removeEventListener(FeathersEventType.INITIALIZE, arguments.callee);
            });
            _view.addEventListener(FeathersEventType.TRANSITION_IN_START, function (event:Event):void {
//                _view.removeEventListener(FeathersEventType.TRANSITION_IN_START, arguments.callee);
                viewWillAppear();
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

    private var _presentationStyle: ModalPresentationStyle = ModalPresentationStyle.fullScreen;
    public function get presentationStyle(): ModalPresentationStyle {
        return _presentationStyle;
    }
    public function set presentationStyle(value: ModalPresentationStyle): void {
        _presentationStyle = value;
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
        vc.setPresentingViewController(this);
        PopUpManager.root.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
        PopUpManager.addPopUp(vc.view, vc.isModalInPopover);
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

        if (PopUpManager.isPopUp(presentedViewController.view)) {
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

        switch (presentedViewController.presentationStyle) {
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

    private var _navigator:ScreenNavigator;
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

    protected var _root:DisplayObjectContainer;
    public function get root(): DisplayObjectContainer {
        return _root;
    }

    public function setAsRootViewController(root:DisplayObjectContainer):void {
        if (_root != null) {
            _root.removeChild(_navigator);
        }
        _root = root;
        if (_root != null) {
            setupRootView();
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