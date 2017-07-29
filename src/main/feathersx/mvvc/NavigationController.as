/**
 * Created by max.rozdobudko@gmail.com on 7/22/17.
 */
package feathersx.mvvc {
import feathers.controls.StackScreenNavigator;

public class NavigationController extends ViewController {

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function NavigationController() {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------



    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    //------------------------------------
    //  Push & Pop stack items
    //------------------------------------

    public function pushViewController(viewController:ViewController, animated:Boolean):void {

    }

    public function popViewController(animated:Boolean):ViewController {
        return null;
    }

    public function popToRootViewController(animated:Boolean):Vector.<ViewController> {
        return null;
    }

    public function popToViewController(viewController:ViewController, animated:Boolean):Vector.<ViewController> {
        return null;
    }
}
}
