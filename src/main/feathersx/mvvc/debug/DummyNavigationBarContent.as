/**
 * Created by max.rozdobudko@gmail.com on 7/26/18.
 */
package feathersx.mvvc.debug {
import feathers.controls.Screen;

public class DummyNavigationBarContent extends Screen {

    public function DummyNavigationBarContent() {
        super();
    }

    override public function dispose(): void {
        super.dispose();
        trace("DummyNavigationBarContent.dispose");
    }
}
}
