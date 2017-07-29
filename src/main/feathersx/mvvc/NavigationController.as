/**
 * Created by max.rozdobudko@gmail.com on 7/22/17.
 */
package feathersx.mvvc {
import feathers.controls.AutoSizeMode;
import feathers.controls.LayoutGroup;
import feathers.controls.StackScreenNavigator;
import feathers.layout.VerticalLayout;
import feathers.layout.VerticalLayoutData;
import feathers.motion.Slide;

import starling.display.DisplayObject;
import starling.display.Quad;

public class NavigationController extends ViewController {

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function NavigationController(rootViewController:ViewController) {
        super();
        this.rootViewController = rootViewController;
        this.rootViewController.setNavigationController(this);
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    private var rootViewController: ViewController;

    //--------------------------------------------------------------------------
    //
    //  Push & Pop stack items
    //
    //--------------------------------------------------------------------------

    public var pushTransition:Function = Slide.createSlideLeftTransition();

    public var popTransition:Function = Slide.createSlideRightTransition();

    //--------------------------------------------------------------------------
    //
    //  Push & Pop stack items
    //
    //--------------------------------------------------------------------------

    override public function show(vc: ViewController, sender: Object = null): void {
        pushViewController(vc, true);
    }

    public function pushViewController(vc:ViewController, animated:Boolean):void {
        var navigator:StackScreenNavigator = this._navigator as StackScreenNavigator;
        if (navigator.hasScreen(vc.identifier)) {
            navigator.removeScreen(vc.identifier);
        }
        navigator.addScreen(vc.identifier, new ViewControllerNavigatorItem(vc));
        var transition:Function = animated ? pushTransition : null;
        navigator.pushScreen(vc.identifier, null, transition);
        vc.setNavigationController(this);
    }

    public function popViewController(animated:Boolean):ViewController {
        var navigator:StackScreenNavigator = this._navigator as StackScreenNavigator;
        var transition:Function = animated ? popTransition : null;
        var view:DisplayObject = navigator.popScreen(transition);
//        navigator.sc
        return null;
    }

    public function popToRootViewController(animated:Boolean):Vector.<ViewController> {
        return null;
    }

    public function popToViewController(viewController:ViewController, animated:Boolean):Vector.<ViewController> {
        return null;
    }

    //--------------------------------------------------------------------------
    //
    //  Stack Navigator
    //
    //--------------------------------------------------------------------------

    override protected function loadView(): DisplayObject {
        var view:LayoutGroup = new LayoutGroup();
        view.autoSizeMode = AutoSizeMode.STAGE;
        view.layout = new VerticalLayout();

        _navigationBar = new NavigationBar();
        _navigationBar.layoutData = new VerticalLayoutData(100);
        _navigationBar.height = 60;
        _navigationBar.backgroundSkin = new Quad(100, 100, 0xFF000);
        view.addChild(_navigationBar);

        _navigator = new StackScreenNavigator();
        _navigator.layoutData = new VerticalLayoutData(100, 100);
        _navigator.addScreen(rootViewController.identifier, new ViewControllerNavigatorItem(rootViewController));
        _navigator.rootScreenID = rootViewController.identifier;
        view.addChild(_navigator);

        _toolbar = new Toolbar();
        _toolbar.layoutData = new VerticalLayoutData(100);
        _toolbar.height = 40;
        view.addChild(_toolbar);

        return view;
    }

    private var _navigator:StackScreenNavigator;
    public function get navigator(): StackScreenNavigator {
        if (presentingViewController is NavigationController) {
            return NavigationController(presentingViewController).navigator;
        } else {
            return _navigator;
        }
    }

    private var _navigationBar:NavigationBar;
    public function get navigationBar(): NavigationBar {
        if (presentingViewController is NavigationController) {
            return NavigationController(presentingViewController).navigationBar;
        } else {
            return _navigationBar;
        }
    }

    private var _toolbar:Toolbar;
    public function get toolbar(): Toolbar {
        if (presentingViewController is NavigationController) {
            return NavigationController(presentingViewController).toolbar;
        } else {
            return _toolbar;
        }
    }

    public function set toolbar(value: Toolbar): void {
        _toolbar = value;
    }

    override protected function setupViewContainer(): void {
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

    private var _viewController: ViewController;

    override public function get canDispose(): Boolean {
        return false;
    }

    override public function getScreen(): DisplayObject {
        return _viewController.view;
    }
}