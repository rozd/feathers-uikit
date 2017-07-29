/**
 * Created by max.rozdobudko@gmail.com on 7/29/17.
 */
package feathersx.mvvc.examples.helloWorld {
import feathersx.mvvc.NavigationController;
import feathersx.mvvc.ViewController;

public class MainController extends NavigationController {
    public function MainController() {
        super(new AViewController());
    }
}
}
