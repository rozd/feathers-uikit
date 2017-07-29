/**
 * Created by max.rozdobudko@gmail.com on 7/29/17.
 */
package feathersx.mvvc.examples.helloWorld {
import feathersx.mvvc.ViewController;
import feathersx.mvvc.examples.helloWorld.view.D1View;

import starling.display.DisplayObject;
import starling.events.Event;

public class D1ViewController extends ViewController {
    public function D1ViewController() {
    }


    override protected function loadView(): DisplayObject {
        return new D1View();
    }


    override protected function viewDidLoad() {
        var view:D1View = this.view as D1View;
        view.dismissButton.addEventListener(Event.TRIGGERED, dismissSelf);
    }

    private function dismissSelf(event: Event): void {
        dismiss(true, null);
    }
}
}
