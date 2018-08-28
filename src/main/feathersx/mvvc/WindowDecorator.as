/**
 * Created by max.rozdobudko@gmail.com on 7/30/18.
 */
package feathersx.mvvc {
import starling.display.DisplayObjectContainer;

public class WindowDecorator implements Window {

    //--------------------------------------------------------------------------
    //
    // Constructor
    //
    //--------------------------------------------------------------------------

    public function WindowDecorator(target: DisplayObjectContainer = null) {
        super();
        _target = target;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    // target

    private var _target: DisplayObjectContainer;
    public function get target(): DisplayObjectContainer {
        return _target;
    }
    public function set target(value: DisplayObjectContainer): void {
        if (value == _target) return;
        _target = value;
    }

    // rootViewController

    private var _rootViewController: ViewController;
    public function get rootViewController(): ViewController {
        return _rootViewController;
    }
    public function set rootViewController(vc: ViewController): void {
        if (vc == _rootViewController) {
            return;
        }
        if (_rootViewController) {
            _rootViewController.setAsRootViewController(null);
        }
        _rootViewController = vc;
        if (_rootViewController) {
            _rootViewController.setAsRootViewController(_target);
        }
    }

}
}
