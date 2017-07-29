/**
 * Created by max.rozdobudko@gmail.com on 7/22/17.
 */
package feathersx.mvvc {
import avmplus.getQualifiedClassName;

import feathers.controls.ScreenNavigator;
import feathers.controls.ScreenNavigatorItem;
import feathers.controls.supportClasses.BaseScreenNavigator;
import feathers.controls.supportClasses.IScreenNavigatorItem;
import feathers.events.FeathersEventType;

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
        return _presentingViewController;
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

//    public function get navigationController(): NavigationController {
//        if (this is NavigationController) {
//            return this as NavigationController;
//        } else if (presentingViewController != null) {
//            return presentingViewController.navigationController;
//        } else {
//            return null;
//        }
//    }

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
        }
    }

    //------------------------------------
    //  View Lifecycle
    //------------------------------------

    protected function viewWillLoad() {

    }

    protected function viewDidLoad() {

    }

    protected function viewWillAppear() {

    }

    protected function viewDidAppear() {

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

        var navigator:ScreenNavigator = this.navigator as ScreenNavigator;
        if (navigator.hasScreen(vc.identifier)) {
            navigator.removeScreen(vc.identifier);
        }
        navigator.addScreen(vc.identifier, new ViewControllerNavigatorItem(vc));
        vc.setPresentingViewController(this);
        navigator.showScreen(vc.identifier);
        this.setPresentedViewController(vc);
    }

    public function showDetailViewController(vc: ViewController, sender: Object = null): void {
        if (_navigationController != null) {
            return;
        }
    }

    public function present(vc: ViewController, animated: Boolean, completion: Function): void {
        if (_navigationController != null) {
            return;
        }
    }

    public function dismiss(animated: Boolean, completion: Function): void {
        if (_navigationController != null) {
            return;
        }

        if (presentedViewController == null) {
            presentingViewController.dismiss(animated, completion);
            return;
        }

        var navigator:ScreenNavigator = this.navigator as ScreenNavigator;
        presentedViewController.setPresentingViewController(null);
        navigator.showScreen(this.identifier);
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

    private var _navigator:BaseScreenNavigator;
    public function get navigator(): BaseScreenNavigator {
        if (presentingViewController) {
            return presentingViewController.navigator;
        } else {
            createNavigatorIfRequired();
            return _navigator;
        }
    }

    private function createNavigatorIfRequired(): void {
        if (_navigator != null) return;
        _navigator = createNavigator();
        if (_root == null) {
            throw new Error("[mvvc] root must be set.");
        }
        _root.addChild(_navigator);
    }

    protected function createNavigator():BaseScreenNavigator {
        var navigator:ScreenNavigator = new ScreenNavigator();
        return navigator;
    }

    protected function setupNavigatorAsRoot():void {
        var navigator:ScreenNavigator = navigator as ScreenNavigator;
        navigator.addScreen(this.identifier, new ViewControllerNavigatorItem(this));
        navigator.showScreen(this.identifier);
    }

    //------------------------------------
    //  Work with Root
    //------------------------------------

    private var _root:DisplayObjectContainer;
    public function get root(): DisplayObjectContainer {
        return _root;
    }

    public function setAsRootViewController(root:DisplayObjectContainer):void {
        if (_root != null) {
            _root.removeChild(_navigator);
        }
        _root = root;
        if (_root != null) {
            createNavigatorIfRequired();
            setupNavigatorAsRoot();
        }
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