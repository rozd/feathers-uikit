/**
 * Created by max.rozdobudko@gmail.com on 7/30/17.
 */
package feathersx.mvvc {
import feathers.controls.Drawers;
import feathers.core.IFeathersControl;
import feathers.core.IFeathersEventDispatcher;
import feathers.events.FeathersEventType;

import starling.display.DisplayObject;
import starling.events.Event;

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

    //--------------------------------------------------------------------------
    //
    //  Work with View
    //
    //--------------------------------------------------------------------------

    override protected function loadViewIfRequired(): void {
        var wasViewLoaded: Boolean = isViewLoaded;
        super.loadViewIfRequired();
        if (!wasViewLoaded) {
            _rootViewController.setDrawersController(this);
            drawers.content = _rootViewController.view as IFeathersControl;
            IFeathersEventDispatcher(_rootViewController.view).dispatchEventWith(FeathersEventType.TRANSITION_IN_START);
            IFeathersEventDispatcher(_rootViewController.view).dispatchEventWith(FeathersEventType.TRANSITION_IN_COMPLETE);

            if (_leftViewController) {
                _leftViewController.setDrawersController(this);
                drawers.leftDrawer = _leftViewController.view as IFeathersControl;
            }

            if (_bottomViewController) {
                _bottomViewController.setDrawersController(this);
                drawers.bottomDrawer = _bottomViewController.view as IFeathersControl;
            }

            drawers.addEventListener(FeathersEventType.BEGIN_INTERACTION, function (event:Event):void {
                // TODO: add view appear
            });

            drawers.addEventListener(FeathersEventType.END_INTERACTION, function (event:Event):void {
                // TODO: add view disappear
            });

            drawers.addEventListener(Event.OPEN, function (event:Event):void {
                if (event.data is IFeathersEventDispatcher) {
                    IFeathersEventDispatcher(event.data).dispatchEventWith(FeathersEventType.TRANSITION_IN_START);
                    IFeathersEventDispatcher(event.data).dispatchEventWith(FeathersEventType.TRANSITION_IN_COMPLETE);
                }
            });

            drawers.addEventListener(Event.CLOSE, function (event:Event):void {
                if (event.data is IFeathersEventDispatcher) {
                    IFeathersEventDispatcher(event.data).dispatchEventWith(FeathersEventType.TRANSITION_OUT_START);
                    IFeathersEventDispatcher(event.data).dispatchEventWith(FeathersEventType.TRANSITION_OUT_COMPLETE);
                }
            });
        }
    }

    override protected function loadView(): DisplayObject {
        return new Drawers();
    }
//
//    protected function loadViewIfRequired(): void {
//        if (_view == null) {
//            viewWillLoad();
//            _view = loadView();
//            if (_view is View) {
//                View(_view).topGuide = navigationController ? navigationController.getTopGuide() : 0;
//                View(_view).bottomGuide = navigationController ? navigationController.getBottomGuide() : 0;
//            }
//            _rootViewController.setDrawersController(this);
//            drawers.content = _rootViewController.view as IFeathersControl;
//            if (_leftViewController) {
//                _leftViewController.setDrawersController(this);
//                drawers.leftDrawer = _leftViewController.view as IFeathersControl;
//            }
//            if (_bottomViewController) {
//                _bottomViewController.setDrawersController(this);
//                drawers.bottomDrawer = _bottomViewController.view as IFeathersControl;
//            }
//            viewDidLoad();
//            _view.addEventListener(FeathersEventType.INITIALIZE, function (event:Event):void {
//                _view.removeEventListener(FeathersEventType.INITIALIZE, arguments.callee);
//            });
//            _view.addEventListener(FeathersEventType.BEGIN_INTERACTION, function (event:Event):void {
//                if (_leftViewController) {
//                    _leftViewController.view.dispatchEventWith(FeathersEventType.TRANSITION_IN_START);
//                }
//                if (_bottomViewController) {
//                    _bottomViewController.view.dispatchEventWith(FeathersEventType.TRANSITION_IN_START);
//                }
//                viewWillAppear();
//            });
//            _view.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, function (event:Event):void {
////                _view.removeEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, arguments.callee);
//                viewDidAppear();
//            });
//            _view.addEventListener(FeathersEventType.TRANSITION_OUT_START, function (event:Event):void {
////                _view.removeEventListener(FeathersEventType.TRANSITION_OUT_START, arguments.callee);
//                viewWillDisappear();
//            });
//            _view.addEventListener(FeathersEventType.TRANSITION_OUT_COMPLETE, function (event:Event):void {
////                _view.removeEventListener(FeathersEventType.TRANSITION_OUT_COMPLETE, arguments.callee);
//                viewDidDisappear();
//            });
//        }
//    }

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
    }

    //--------------------------------------------------------------------------
    //
    //  Work with Drawers
    //
    //--------------------------------------------------------------------------

    public function showLeftViewController(animated: Boolean): void {
        if (!drawers.isLeftDrawerOpen) {
            if (animated) {
                drawers.toggleLeftDrawer();
            } else {
                drawers.isLeftDrawerOpen = true;
            }
        }
    }

    public function hideLeftViewController(animated: Boolean): void {
        if (drawers.isLeftDrawerOpen) {
            if (animated) {
                drawers.toggleLeftDrawer()
            } else {
                drawers.isLeftDrawerOpen = false;
            }
        }
    }

    public function showBottomViewController(animated: Boolean): void {
        if (!drawers.isBottomDrawerOpen) {
            if (animated) {
                drawers.toggleBottomDrawer()
            } else {
                drawers.isBottomDrawerOpen = true;
            }
        }
    }
    public function hideBottomViewController(animated: Boolean): void {
        if (drawers.isBottomDrawerOpen) {
            if (animated) {
                drawers.toggleBottomDrawer()
            } else {
                drawers.isBottomDrawerOpen = false;
            }
        }
    }
}
}
