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

    public function WindowDecorator(target: DisplayObjectContainer) {
        super();
        _target = target;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    protected var _target: DisplayObjectContainer;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //  rootViewController

    private var _rootViewController: ViewController;
    public function get rootViewController(): ViewController {
        return _rootViewController;
    }
    public function set rootViewController(vc: ViewController): void {
        if (vc == _rootViewController) return;
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
