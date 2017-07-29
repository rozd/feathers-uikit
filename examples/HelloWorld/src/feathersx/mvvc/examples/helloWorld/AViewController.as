/**
 * Created by max.rozdobudko@gmail.com on 7/23/17.
 */
package feathersx.mvvc.examples.helloWorld {
import feathersx.mvvc.ViewController;
import feathersx.mvvc.examples.helloWorld.view.AView;

import starling.display.DisplayObject;
import starling.events.Event;

public class AViewController extends ViewController {
    public function AViewController() {
        super();
    }

    override protected function loadView(): DisplayObject {
        return new AView();
    }

    override protected function viewDidLoad() {
        var aView:AView = this.view as AView;
        aView.button.addEventListener(Event.TRIGGERED, showB1View);
    }

    public function showB1View(): void {
        var b1:B1ViewController = new B1ViewController();
        this.show(b1);
        this.navigationController.pushViewController(b1, true);
    }
}
}
