/**
 * Created by max.rozdobudko@gmail.com on 12/1/17.
 */
package feathersx.mvvc {
import feathers.core.IFeathersDisplayObject;

public interface Window extends IFeathersDisplayObject {
    function get rootViewController(): ViewController;
    function set rootViewController(vc: ViewController): void;
}
}
