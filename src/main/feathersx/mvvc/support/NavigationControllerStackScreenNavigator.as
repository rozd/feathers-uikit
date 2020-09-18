/**
 * Created by max.rozdobudko@gmail.com on 9/18/20.
 */
package feathersx.mvvc.support {
import feathers.controls.StackScreenNavigator;

import feathersx.mvvc.ViewController;

public class NavigationControllerStackScreenNavigator extends StackScreenNavigator {

    // MARK: - Lifecycle

    public function NavigationControllerStackScreenNavigator() {
        super();
    }

    // MARK: - ViewControllers

    public function get viewControllers(): Vector.<ViewController> {
        var result: Vector.<ViewController> = new <ViewController>[];

        for (var i: int = 0, n: int = _stack.length; i < n; i++) {
            result[result.length] = ViewControllerStackScreenNavigatorItem(getScreen(_stack[i].id)).viewController;
        }

        if (activeScreenID != null) {
            result[result.length] = ViewControllerStackScreenNavigatorItem(getScreen(activeScreenID)).viewController;
        }

        return result;
    }
}
}
