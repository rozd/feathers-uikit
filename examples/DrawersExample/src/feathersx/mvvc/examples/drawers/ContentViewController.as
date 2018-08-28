/**
 * Created by max.rozdobudko@gmail.com on 7/30/17.
 */
package feathersx.mvvc.examples.drawers {
import feathersx.mvvc.ViewController;
import feathersx.mvvc.examples.drawers.view.ContentView;

import starling.display.DisplayObject;
import starling.events.Event;

public class ContentViewController extends ViewController {
    public function ContentViewController() {
        super();
    }

    override protected function loadView(): DisplayObject {
        return new ContentView();
    }

    override protected function viewDidLoad(): void {
        var view:ContentView = this.view as ContentView;
        view.menuButton.addEventListener(Event.TRIGGERED, menuHandler)
    }

    override protected function viewWillDisappear(): void {
        super.viewWillDisappear();
        trace("ContentViewController.viewWillDisappear");
    }

    override protected function viewWillAppear(): void {
        super.viewWillAppear();
        trace("ContentViewController.viewWillAppear");
    }

    override protected function viewDidAppear(): void {
        super.viewDidAppear();
        trace("ContentViewController.viewDidAppear");
    }

    override protected function viewDidDisappear(): void {
        super.viewDidDisappear();
        trace("ContentViewController.viewDidDisappear");
    }

    private function menuHandler(): void {
        drawersController.showLeftViewController(true);
    }
}
}
