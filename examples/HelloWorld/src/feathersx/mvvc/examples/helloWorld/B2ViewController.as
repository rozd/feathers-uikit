/**
 * Created by max.rozdobudko@gmail.com on 7/29/17.
 */
package feathersx.mvvc.examples.helloWorld {
import feathersx.mvvc.ViewController;
import feathersx.mvvc.examples.helloWorld.view.B2View;

import starling.display.DisplayObject;

public class B2ViewController extends ViewController {
    public function B2ViewController() {
        super();
    }

    override protected function loadView(): DisplayObject {
        return new B2View();
    }
}
}
