/**
 * Created by max.rozdobudko@gmail.com on 11/30/17.
 */
package feathersx.mvvc.controls {
import feathersx.mvvc.ViewController;

public interface EmbedViewControllerListDelegate {
    function listViewControllerWillLoadView(vc: ViewController): void;
}
}
