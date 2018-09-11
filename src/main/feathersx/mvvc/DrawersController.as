/**
 * Created by max.rozdobudko@gmail.com on 7/30/17.
 */
package feathersx.mvvc {
import feathers.controls.Drawers;
import feathers.core.IFeathersControl;

import starling.display.DisplayObject;
import starling.events.Event;

public class DrawersController extends ViewController {

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function DrawersController(rootViewController: ViewController) {
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
    //  topViewController
    //-------------------------------------

    private var _topViewController: ViewController;
    public function get topViewController(): ViewController {
        return _topViewController;
    }
    public function set topViewController(value: ViewController): void {
        _topViewController = value;
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

    //-------------------------------------
    //  bottomViewController
    //-------------------------------------

    private var _bottomViewController: ViewController;
    public function get bottomViewController(): ViewController {
        return _bottomViewController;
    }
    public function set bottomViewController(value: ViewController): void {
        _bottomViewController = value;
    }

    //-------------------------------------
    //  rightViewController
    //-------------------------------------

    private var _rightViewController: ViewController;
    public function get rightViewController(): ViewController {
        return _rightViewController;
    }
    public function set rightViewController(value: ViewController): void {
        _rightViewController = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Navigation Controllers
    //
    //--------------------------------------------------------------------------

    override public function setNavigationController(nc: NavigationController): void {
        super.setNavigationController(nc);
        if (_rootViewController) {
            _rootViewController.setNavigationController(nc);
        }
        if (_topViewController) {
            _topViewController.setNavigationController(nc);
        }
        if (_leftViewController) {
            _leftViewController.setNavigationController(nc);
        }
        if (_bottomViewController) {
            _bottomViewController.setNavigationController(nc);
        }
        if (_rightViewController) {
            _rootViewController.setNavigationController(nc);
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Work with View
    //
    //--------------------------------------------------------------------------

    override protected function loadViewIfRequired(): void {
        var hasViewLoadedBefore: Boolean = isViewLoaded;
        super.loadViewIfRequired();
        if (!hasViewLoadedBefore) {
            setupDrawers();
        }
    }

    override protected function loadView(): DisplayObject {
        return new Drawers();
    }

    //--------------------------------------------------------------------------
    //
    //  Work with View Controllers
    //
    //--------------------------------------------------------------------------

    protected function viewToViewController(view: DisplayObject): ViewController {

        if (_rootViewController != null && _rootViewController.view == view) {
            return _rootViewController;
        }

        if (_topViewController != null && _topViewController.view == view) {
            return _topViewController;
        }

        if (_leftViewController != null && _leftViewController.view == view) {
            return _leftViewController;
        }

        if (_rightViewController != null && _rightViewController.view == view) {
            return _rightViewController;
        }

        if (_bottomViewController != null && _bottomViewController.view == view) {
            return _bottomViewController;
        }

        return null;
    }

    //--------------------------------------------------------------------------
    //
    //  Work with Root
    //
    //--------------------------------------------------------------------------

    public function get drawers(): Drawers {
        return this.view as Drawers;
    }

    override protected function cleanRootView(): void {
        if (_root != null) {
            _root.removeChild(this.view);
        }
    }

    override protected function setupRootView(): void {
        if (_root == null) {
            throw new Error("[mvvc] root must be set.");
        }
        if (_root is Drawers) {
            _view = _root;
            setupDrawers();
        } else {
            _root.addChild(this.view);
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Setup Drawers
    //
    //--------------------------------------------------------------------------

    protected function setupDrawers(): void {
        drawers.addEventListener(Event.REMOVED_FROM_STAGE, drawers_removedFromStageHandler);

        _rootViewController.setDrawersController(this);
        drawers.content = _rootViewController.view as IFeathersControl;
        _rootViewController.notifyViewDidAppear();

        if (_topViewController) {
            _topViewController.setDrawersController(this);
            drawers.topDrawer = _topViewController.view as IFeathersControl;
        }

        if (_leftViewController) {
            _leftViewController.setDrawersController(this);
            drawers.leftDrawer = _leftViewController.view as IFeathersControl;
        }

        if (_rightViewController) {
            _rightViewController.setDrawersController(this);
            drawers.rightDrawer = _rightViewController.view as IFeathersControl;
        }

        if (_bottomViewController) {
            _bottomViewController.setDrawersController(this);
            drawers.bottomDrawer = _bottomViewController.view as IFeathersControl;
        }

        drawers.addEventListener(Event.OPEN, function (event:Event):void {
            var vc: ViewController = viewToViewController(event.data as DisplayObject);
            if (vc != null) {
                vc.notifyViewDidAppear();
            }
        });

        drawers.addEventListener(Event.CLOSE, function (event:Event):void {
            var vc: ViewController = viewToViewController(event.data as DisplayObject);
            if (vc != null) {
                vc.notifyViewWillDisappear();
            }
        });
    }

    //--------------------------------------------------------------------------
    //
    //  Work with Drawers
    //
    //--------------------------------------------------------------------------

    // Top drawer

    public function get isTopViewControllerShown(): Boolean {
        return drawers.isTopDrawerOpen;
    }
    public function showTopViewController(animated: Boolean, completion: Function = null): void {
        if (!drawers.isTopDrawerOpen && animated) {
            drawers.addEventListener(Event.OPEN, function(event: Event): void {
                drawers.removeEventListener(Event.OPEN, arguments.callee);
                if (completion != null) {
                    completion();
                }
            });
            drawers.toggleTopDrawer();
        } else {
            drawers.isTopDrawerOpen = true;
            if (completion != null) {
                completion();
            }
        }
    }
    public function hideTopViewController(animated: Boolean, completion: Function = null): void {
        if (drawers.isTopDrawerOpen && animated) {
            drawers.addEventListener(Event.CLOSE, function(event: Event): void {
                drawers.removeEventListener(Event.CLOSE, arguments.callee);
                if (completion != null) {
                    completion();
                }
            });
            drawers.toggleTopDrawer();
        } else {
            drawers.isTopDrawerOpen = false;
            if (completion != null) {
                completion();
            }
        }
    }

    // Left drawer

    public function get isLeftViewControllerShown(): Boolean {
        return drawers.isLeftDrawerOpen;
    }
    public function showLeftViewController(animated: Boolean, completion: Function = null): void {
        if (!drawers.isLeftDrawerOpen && animated) {
            drawers.addEventListener(Event.OPEN, function(event: Event): void {
                drawers.removeEventListener(Event.OPEN, arguments.callee);
                if (completion != null) {
                    completion();
                }
            });
            drawers.toggleLeftDrawer();
        } else {
            drawers.isLeftDrawerOpen = true;
            if (completion != null) {
                completion();
            }
        }
    }
    public function hideLeftViewController(animated: Boolean, completion: Function = null): void {
        if (drawers.isLeftDrawerOpen && animated) {
            drawers.addEventListener(Event.CLOSE, function(event: Event): void {
                drawers.removeEventListener(Event.CLOSE, arguments.callee);
                if (completion != null) {
                    completion();
                }
            });
            drawers.toggleLeftDrawer();
        } else {
            drawers.isLeftDrawerOpen = false;
            if (completion != null) {
                completion();
            }
        }
    }

    // Bottom drawer

    public function get isBottomViewControllerShown(): Boolean {
        return drawers.isBottomDrawerOpen;
    }
    public function showBottomViewController(animated: Boolean, completion: Function = null): void {
        if (!drawers.isBottomDrawerOpen && animated) {
            drawers.addEventListener(Event.OPEN, function(event: Event): void {
                drawers.removeEventListener(Event.OPEN, arguments.callee);
                if (completion != null) {
                    completion();
                }
            });
            drawers.toggleBottomDrawer();
        } else {
            drawers.isBottomDrawerOpen = true;
            if (completion != null) {
                completion();
            }
        }
    }
    public function hideBottomViewController(animated: Boolean, completion: Function = null): void {
        if (drawers.isBottomDrawerOpen && animated) {
            drawers.addEventListener(Event.CLOSE, function(event: Event): void {
                drawers.removeEventListener(Event.CLOSE, arguments.callee);
                if (completion != null) {
                    completion();
                }
            });
            drawers.toggleBottomDrawer();
        } else {
            drawers.isBottomDrawerOpen = false;
            if (completion != null) {
                completion();
            }
        }
    }

    // Right drawer

    public function get isRightViewControllerShown(): Boolean {
        return drawers.isRightDrawerOpen;
    }
    public function showRightViewController(animated: Boolean, completion: Function = null): void {
        if (!drawers.isRightDrawerOpen && animated) {
            drawers.addEventListener(Event.OPEN, function(event: Event): void {
                drawers.removeEventListener(Event.OPEN, arguments.callee);
                if (completion != null) {
                    completion();
                }
            });
            drawers.toggleRightDrawer();
        } else {
            drawers.isRightDrawerOpen = true;
            if (completion != null) {
                completion();
            }
        }
    }
    public function hideRightViewController(animated: Boolean, completion: Function = null): void {
        if (drawers.isRightDrawerOpen && animated) {
            drawers.addEventListener(Event.CLOSE, function(event: Event): void {
                drawers.removeEventListener(Event.CLOSE, arguments.callee);
                if (completion != null) {
                    completion();
                }
            });
            drawers.toggleRightDrawer();
        } else {
            drawers.isRightDrawerOpen = false;
            if (completion != null) {
                completion();
            }
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Dispose
    //
    //--------------------------------------------------------------------------

    override public function dispose(): void {
        if (_rootViewController) {
            _rootViewController.dispose();
        }

        if (_topViewController) {
            _topViewController.dispose();
        }

        if (_leftViewController) {
            _leftViewController.dispose();
        }

        if (_rightViewController) {
            _rightViewController.dispose();
        }

        if (_bottomViewController) {
            _bottomViewController.dispose();
        }

        super.dispose();
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function drawers_removedFromStageHandler(event: Event): void {
        if (_rootViewController) {
            _rootViewController.notifyViewWillDisappear();
        }

        if (_topViewController) {
            _topViewController.notifyViewWillDisappear();
        }

        if (_leftViewController) {
            _leftViewController.notifyViewWillDisappear();
        }

        if (_rightViewController) {
            _rightViewController.notifyViewWillDisappear();
        }

        if (_bottomViewController) {
            _bottomViewController.notifyViewWillDisappear();
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Description
    //
    //--------------------------------------------------------------------------

    override public function toString(): String {
        return "[DrawersController("+identifier+")]";
    }
}
}
