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

    override protected function viewDidLoad():void {
//        trace("viewDidLoad");
        var aView:AView = this.view as AView;
        aView.pushScreenB1Button.addEventListener(Event.TRIGGERED, showB1View);
        aView.presentScreenDButton.addEventListener(Event.TRIGGERED, presentScreenD);
    }

    override protected function viewWillLoad():void {
//        trace("viewWillLoad");
    }

    override protected function viewWillAppear():void {
//        trace("viewWillAppear");
    }

    override protected function viewDidAppear():void {
//        trace("viewDidAppear");
    }

    override protected function viewWillDisappear():void {
//        trace("viewWillDisappear");
    }

    override protected function viewDidDisappear():void {
//        trace("viewDidDisappear");
    }

    public function showB1View(): void {
        var b1:B1ViewController = new B1ViewController();
        this.show(b1);
        if (this.navigationController) {
            this.navigationController.pushViewController(b1, true);
        }
    }

    public function presentScreenD(): void {
        var d:DNavigationController = new DNavigationController();
        present(d, true);
    }
}
}
