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

import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.events.Event;

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

    private var _navigationController: NavigationController;
    public function get navigationController(): NavigationController {
        return _navigationController;
    }
    public function setNavigationController(nc:NavigationController) {
        _navigationController = nc;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    //
    //  Work with View
    //
    //--------------------------------------------------------------------------

    private var _view:DisplayObject;

    public function get view(): DisplayObject {
        loadViewIfRequired();
        return _view;
    }

    public function set view(value: DisplayObject): void {
        _view = value;
    }

    protected function loadView():DisplayObject {
        return null;
    }

    private function loadViewIfRequired(): void {
        if (_view == null) {
            viewWillLoad();
            _view = loadView();
            _view.addEventListener(FeathersEventType.INITIALIZE, function (event:Event):void {
                _view.removeEventListener(FeathersEventType.INITIALIZE, arguments.callee);
                viewDidLoad();
            });
            _view.addEventListener(FeathersEventType.TRANSITION_IN_START, function (event:Event):void {
                _view.removeEventListener(FeathersEventType.TRANSITION_IN_START, arguments.callee);
                viewWillAppear();
            });
            _view.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, function (event:Event):void {
                _view.removeEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, arguments.callee);
                viewDidAppear();
            });
            _view.addEventListener(FeathersEventType.TRANSITION_OUT_START, function (event:Event):void {
                _view.removeEventListener(FeathersEventType.TRANSITION_OUT_START, arguments.callee);
                viewWillDisappear();
            });
            _view.addEventListener(FeathersEventType.TRANSITION_OUT_COMPLETE, function (event:Event):void {
                _view.removeEventListener(FeathersEventType.TRANSITION_OUT_COMPLETE, arguments.callee);
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

    public function present(vc: ViewController, animated: Boolean, completion: Function = null): void {
        vc.setPresentingViewController(this);
        PopUpManager.addPopUp(vc.view);
        this.setPresentedViewController(vc);
    }

    public function dismiss(animated: Boolean, completion: Function = null): void {

        if (presentedViewController == null) {
            if (presentingViewController != null) {
                presentingViewController.dismiss(animated, completion);
            }

            return;
        }

        presentedViewController.setPresentingViewController(null);

        if (PopUpManager.isPopUp(presentedViewController.view)) {
            PopUpManager.removePopUp(presentedViewController.view);
        } else {
            navigator.showScreen(this.identifier, Reveal.createRevealDownTransition());
        }

        this.setPresentedViewController(null);
    }

    public function replaceWithViewController(vc: ViewController, sender: Object = null): void {

    }

    //------------------------------------
    //  Segues
    //------------------------------------

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
        return false;
    }

    override public function getScreen(): DisplayObject {
        return _viewController.view;
    }
}