/**
 * Created by max.rozdobudko@gmail.com on 7/22/17.
 */
package feathersx.mvvc {
import feathers.controls.StackScreenNavigator;
import feathers.controls.StackScreenNavigatorItem;
import feathers.controls.supportClasses.BaseScreenNavigator;
import feathers.motion.Slide;

import starling.display.DisplayObject;

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

    private var _navigator:StackScreenNavigator;
    public function get navigator(): StackScreenNavigator {
        if (presentingViewController is NavigationController) {
            return NavigationController(presentingViewController).navigator;
        } else {
            return _navigator;
        }
    }

    override protected function setupViewContainer(): void {
        if (_root == null) {
            throw new Error("[mvvc] root must be set.");
        }
        _navigator = new StackScreenNavigator();
        _root.addChild(navigator);
        _navigator.addScreen(rootViewController.identifier, new ViewControllerNavigatorItem(rootViewController));
        _navigator.rootScreenID = rootViewController.identifier;
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