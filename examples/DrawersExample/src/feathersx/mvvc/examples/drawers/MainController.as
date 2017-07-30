/**
 * Created by max.rozdobudko@gmail.com on 7/30/17.
 */
package feathersx.mvvc.examples.drawers {
import feathersx.mvvc.DrawersController;
import feathersx.mvvc.ViewController;

public class MainController extends DrawersController {
    public function MainController() {
        super(new ContentViewController());
        leftViewController = new SideMenuViewController();
    }
}
}
