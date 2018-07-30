/**
 * Created by max.rozdobudko@gmail.com on 12/1/17.
 */
package feathersx.mvvc {

public interface Window {
    function get rootViewController(): ViewController;
    function set rootViewController(vc: ViewController): void;
}
}
