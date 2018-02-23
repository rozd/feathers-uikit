/**
 * Created by max.rozdobudko@gmail.com on 8/23/17.
 */
package feathersx.mvvc {
public interface NavigationControllerDelegate {
    function navigationControllerWillShow(navigationController: NavigationController, viewController: ViewController, animated: Boolean): void;
//    function navigationControllerDidShow(navigationController: NavigationController, viewController: ViewController, animated: Boolean);
}
}
