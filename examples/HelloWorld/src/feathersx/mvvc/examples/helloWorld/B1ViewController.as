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
    }

    override protected function loadView(): DisplayObject {
        return new B1View();
    }

    override protected function viewDidLoad() {
        var view:B1View = this.view as B1View;
        view.popToScreenAButton.addEventListener(Event.TRIGGERED, popToScreenA);
        view.pushScreenCButton.addEventListener(Event.TRIGGERED, pushScreenC);
        view.replaceWithScreenB2Button.addEventListener(Event.TRIGGERED, replaceWithScreenB2);
    }

    public function popToScreenA(): void {
        this.dismiss(true, null);
    }

    public function pushScreenC(): void {
        var c: CViewController = new CViewController();
        this.show(c);
    }

    public function replaceWithScreenB2(): void {
        var b2:B2ViewController = new B2ViewController();
        this.replaceWithViewController(b2);
    }
}
}
