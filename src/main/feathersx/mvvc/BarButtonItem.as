/**
 * Created by max.rozdobudko@gmail.com on 7/30/17.
 */
package feathersx.mvvc {
import starling.display.Image;

public class BarButtonItem extends BarItem {
    public function BarButtonItem() {
    }

    public var defaultIcon:Image;

    public var downIcon:Image;

    public var disabledIcon:Image;

    public var triggered:Function;
}
}
