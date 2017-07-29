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

    override protected function viewDidLoad():void {
        trace("viewDidLoad");
    }

    override protected function viewWillLoad():void {
        trace("viewWillLoad");
    }

    override protected function viewWillAppear():void {
        trace("viewWillAppear");
    }

    override protected function viewDidAppear():void {
        trace("viewDidAppear");
    }

    override protected function viewWillDisappear():void {
        trace("viewWillDisappear");
    }

    override protected function viewDidDisappear():void {
        trace("viewDidDisappear");
    }
}
}
