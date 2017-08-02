/**
 * Created by max.rozdobudko@gmail.com on 7/30/17.
 */
package feathersx.mvvc {
import starling.display.DisplayObject;
import starling.display.Image;

public class BarButtonItem extends BarItem {
    public function BarButtonItem() {
    }

    public var defaultIcon:DisplayObject;

    public var downIcon:DisplayObject;

    public var disabledIcon:DisplayObject;

    public var triggered:Function;
}
}
