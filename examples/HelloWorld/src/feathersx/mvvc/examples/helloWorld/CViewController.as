/**
 * Created by max.rozdobudko@gmail.com on 7/29/17.
 */
package feathersx.mvvc.examples.helloWorld {
import feathersx.mvvc.ViewController;
import feathersx.mvvc.examples.helloWorld.view.CView;

import starling.display.DisplayObject;
import starling.events.Event;

public class CViewController extends ViewController {
    public function CViewController() {
        super();
    }

    override protected function loadView(): DisplayObject {
        return new CView();
    }

    override protected function viewDidLoad() {
        var view:CView = view as CView;
        view.popToRootButton.addEventListener(Event.TRIGGERED, popToRoot);
        view.popToScreenBButton.addEventListener(Event.TRIGGERED, popToScreenBButton);
    }

    private function popToRoot(event: Event): void {
        this.navigationController.popToRootViewController(true);
    }

    private function popToScreenBButton(event: Event): void {
        this.dismiss(true, null);
        this.navigationController.popViewController(true);
    }
}
}
