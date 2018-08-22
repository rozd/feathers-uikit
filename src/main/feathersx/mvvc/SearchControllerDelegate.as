/**
 * Created by max.rozdobudko@gmail.com on 8/22/18.
 */
package feathersx.mvvc {
public interface SearchControllerDelegate {
    function didDismissSearchController(controller: SearchController): void;
    function didPresentSearchController(controller: SearchController): void;
    function presentSearchController(controller: SearchController): void;
    function willDismissSearchController(controller: SearchController): void;
    function willPresentSearchController(controller: SearchController): void;
}
}
