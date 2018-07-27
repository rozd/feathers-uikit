/**
 * Created by max.rozdobudko@gmail.com on 7/27/18.
 */
package feathersx.mvvc.debug {
import feathersx.mvvc.ViewController;

import starling.display.DisplayObject;
import starling.events.Event;

public class DummyViewController extends ViewController {

    // MARK: Constructor

    public function DummyViewController() {
        super();
    }

    // MARK: View lifecycle

    override protected function loadView(): DisplayObject {
        return new DummyView();
    }

    override protected function viewDidLoad(): void {
        super.viewDidLoad();

        // navigationItem

        navigationItem.hidesBackButton = true;

        // view

        DummyView(view).popButton.addEventListener(Event.TRIGGERED, popButton_triggeredHanaler);
    }

    private function popButton_triggeredHanaler(event: Event): void {
        if (navigationController) {
            navigationController.popViewController(false);
        }
    }
}
}
