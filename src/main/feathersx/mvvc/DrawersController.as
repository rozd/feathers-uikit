/**
 * Created by max.rozdobudko@gmail.com on 7/30/17.
 */
package feathersx.mvvc {
import feathers.controls.Drawers;
import feathers.core.IFeathersControl;

import starling.display.DisplayObject;

public class DrawersController extends ViewController {

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function DrawersController(rootViewController:ViewController) {
        super();
        this.rootViewController = rootViewController;
    }

    //--------------------------------------------------------------------------
    //
    //  Nested View Controllers
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  rootViewController
    //-------------------------------------

    private var _rootViewController:ViewController;
    public function get rootViewController(): ViewController {
        return _rootViewController;
    }
    public function set rootViewController(value: ViewController): void {
        _rootViewController = value;
    }

    //-------------------------------------
    //  leftViewController
    //-------------------------------------

    private var _leftViewController: ViewController;
    public function get leftViewController(): ViewController {
        return _leftViewController;
    }
    public function set leftViewController(value: ViewController): void {
        _leftViewController = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Work with View
    //
    //--------------------------------------------------------------------------

    override protected function loadView(): DisplayObject {
        return new Drawers();
    }

    //--------------------------------------------------------------------------
    //
    //  Work with Root
    //
    //--------------------------------------------------------------------------

    public function get drawers(): Drawers {
        return this.view as Drawers;
    }

    override protected function setupRootView(): void {
        if (_root == null) {
            throw new Error("[mvvc] root must be set.");
        }
        if (_root is Drawers) {
            _view = _root;
        } else {
            _root.addChild(this.view);
        }
        drawers.content = _rootViewController.view as IFeathersControl;
        _rootViewController.setDrawersController(this);
        if (_leftViewController) {
            drawers.leftDrawer = _leftViewController.view as IFeathersControl;
            _leftViewController.setDrawersController(this);
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Work with Drawers
    //
    //--------------------------------------------------------------------------

    public function showLeftViewController(animated:Boolean): void {
        if (!drawers.isLeftDrawerOpen) {
            if (animated) {
                drawers.toggleLeftDrawer();
            } else {
                drawers.isLeftDrawerOpen = true;
            }
        }
    }
}
}
