/**
 * Created by max.rozdobudko@gmail.com on 9/18/20.
 */
package feathersx.mvvc.support {
import feathers.controls.StackScreenNavigatorItem;

import feathersx.mvvc.ViewController;

import starling.display.DisplayObject;

public class ViewControllerStackScreenNavigatorItem extends StackScreenNavigatorItem {

    public function ViewControllerStackScreenNavigatorItem(vc: ViewController): void {
        super();
        _viewController = vc;
    }

    private var _retained: Boolean = false;

    private var _viewController: ViewController;
    public function get viewController(): ViewController {
        return _viewController;
    }

    override public function get canDispose(): Boolean {
        return !_retained;
    }

    override public function getScreen(): DisplayObject {
        return _viewController.view;
    }

    public function retain():void {
        trace("retain", _viewController);
        _retained = true;
    }

    public function release():void {
        trace("release", _viewController);
        _retained = false;
    }
}
}
