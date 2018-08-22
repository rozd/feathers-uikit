/**
 * Created by max.rozdobudko@gmail.com on 8/22/18.
 */
package feathersx.mvvc.examples.helloWorld {
import feathersx.mvvc.SearchController;
import feathersx.mvvc.SearchResultsUpdating;
import feathersx.mvvc.ViewController;
import feathersx.mvvc.examples.helloWorld.view.SView;

import starling.display.DisplayObject;

public class SViewController extends ViewController implements SearchResultsUpdating{

    public function SViewController() {
        super();
    }

    protected var searchController: SearchController = new SearchController(null);

    override protected function loadView(): DisplayObject {
        return new SView();
    }

    override protected function viewDidLoad(): void {
        super.viewDidLoad();

        searchController.searchResultsUpdater = this;
        searchController.searchBar.placeholder = "Search";
        navigationItem.searchController = searchController;
    }

    // MARK: <SearchResultsUpdating>

    public function updateSearchResults(searchController: SearchController): void {
        trace(searchController.searchBar.text);
    }
}
}
