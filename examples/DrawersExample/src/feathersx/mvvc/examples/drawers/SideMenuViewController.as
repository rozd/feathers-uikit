/**
 * Created by max.rozdobudko@gmail.com on 7/30/17.
 */
package feathersx.mvvc.examples.drawers {
import feathersx.mvvc.ViewController;
import feathersx.mvvc.examples.drawers.view.SideMenuView;

import starling.display.DisplayObject;

public class SideMenuViewController extends ViewController {
    public function SideMenuViewController() {
        super();
    }

    override protected function loadView(): DisplayObject {
        var menu:SideMenuView =  new SideMenuView();
        menu.width = 200;
        return menu;
    }

    override protected function viewWillDisappear(): void {
        super.viewWillDisappear();
        trace("SideMenuViewController.viewWillDisappear");
    }

    override protected function viewWillAppear(): void {
        super.viewWillAppear();
        trace("SideMenuViewController.viewWillAppear");
    }

    override protected function viewDidAppear(): void {
        super.viewDidAppear();
        trace("SideMenuViewController.viewDidAppear");
    }

    override protected function viewDidDisappear(): void {
        super.viewDidDisappear();
        trace("SideMenuViewController.viewDidDisappear");
    }
}
}
