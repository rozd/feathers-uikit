/**
 * Created by max.rozdobudko@gmail.com on 25.11.2019.
 */
package screens.issue3 {
import feathersx.mvvc.ViewController;

import starling.display.DisplayObject;

public class PopoverViewController extends ViewController {

    // MARK: Constructor

    public function PopoverViewController() {
        super();
    }

    // MARK: View lifecycle

    override protected function loadView(): DisplayObject {
        return new PopoverView();
    }
}
}
