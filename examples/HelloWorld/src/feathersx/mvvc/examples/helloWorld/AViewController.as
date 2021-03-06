/**
 * Created by max.rozdobudko@gmail.com on 7/23/17.
 */
package feathersx.mvvc.examples.helloWorld {
import feathers.data.ArrayCollection;

import feathersx.mvvc.AlertAction;
import feathersx.mvvc.AlertActionStyle;

import feathersx.mvvc.AlertController;
import feathersx.mvvc.AlertControllerStyle;

import feathersx.mvvc.BarButtonItem;
import feathersx.mvvc.ViewController;
import feathersx.mvvc.examples.helloWorld.view.AView;

import starling.display.DisplayObject;
import starling.events.Event;

public class AViewController extends ViewController {
    public function AViewController() {
        super();
        this.navigationItem.title = "A";
        var menuItem: BarButtonItem = new BarButtonItem();
        menuItem.label = "Menu";
        this.navigationItem.leftItems = new <BarButtonItem>[menuItem];
    }

    override protected function loadView(): DisplayObject {
        return new AView();
    }

    override protected function viewDidLoad():void {

//        trace("viewDidLoad");
        var aView:AView = this.view as AView;
        aView.pushScreenB1Button.addEventListener(Event.TRIGGERED, showB1View);
        aView.pushScreenSButton.addEventListener(Event.TRIGGERED, showSView);
        aView.presentScreenDButton.addEventListener(Event.TRIGGERED, presentScreenD);
        aView.showAlertButton.addEventListener(Event.TRIGGERED, showAlert);
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
        if (this.navigationController) {
            this.navigationController.pushViewController(b1, true);
        }
    }

    public function showSView(): void {
        var s: SViewController = new SViewController();
        if (this.navigationController) {
            this.navigationController.pushViewController(s, true);
        }
    }

    public function presentScreenD(): void {
        var d:DNavigationController = new DNavigationController();
        present(d, true);
    }

    public function showAlert(): void {
        var alert: AlertController = new AlertController("Title", "Hello World", AlertControllerStyle.alert);
        alert.isModalInPopover = true;
        alert.addAction(new AlertAction("OK", AlertActionStyle.normal, function (): void {
            trace("OK");
        }));
        alert.addAction(new AlertAction("Cancel", AlertActionStyle.normal, function (): void {
            trace("Cancel");
        }));
        present(alert, true);
    }
}
}
