/**
 * Created by max.rozdobudko@gmail.com on 7/26/17.
 */
package feathersx.mvvc.examples.helloWorld {
import feathersx.mvvc.ViewController;
import feathersx.mvvc.examples.helloWorld.view.B1View;
import feathersx.mvvc.examples.helloWorld.view.B2View;

import starling.display.DisplayObject;
import starling.events.Event;

public class B1ViewController extends ViewController {
    public function B1ViewController() {
        super();
        this.navigationItem.title = "B1";
    }

    override protected function loadView(): DisplayObject {
        return new B1View();
    }

    override protected function viewDidLoad():void {
        trace("viewDidLoad");
        var view:B1View = this.view as B1View;
        view.popToScreenAButton.addEventListener(Event.TRIGGERED, popToScreenA);
        view.pushScreenCButton.addEventListener(Event.TRIGGERED, pushScreenC);
        view.replaceWithScreenB2Button.addEventListener(Event.TRIGGERED, replaceWithScreenB2);
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

    public function popToScreenA(): void {
        this.dismiss(true, null);
        if (navigationController) {
            navigationController.popViewController(true);
        }
    }

    public function pushScreenC(): void {
        var c: CViewController = new CViewController();
        this.show(c);
        if (navigationController) {
            this.navigationController.pushViewController(c, true);
        }
    }

    public function replaceWithScreenB2(): void {
        var b2:B2ViewController = new B2ViewController();
        this.replaceWithViewController(b2);
    }
}
}
