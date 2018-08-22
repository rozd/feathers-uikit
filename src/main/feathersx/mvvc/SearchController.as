/**
 * Created by max.rozdobudko@gmail.com on 8/22/18.
 */
package feathersx.mvvc {
import feathers.events.FeathersEventType;

import feathersx.core.feathers_mvvc;

import skein.core.WeakReference;

import starling.display.DisplayObject;
import starling.events.Event;

use namespace feathers_mvvc;

public class SearchController extends ViewController {

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function SearchController(searchResultsController: ViewController) {
        super();
        _searchResultsController = searchResultsController;
    }

    //--------------------------------------------------------------------------
    //
    //  Updater
    //
    //--------------------------------------------------------------------------

    private var _searchResultsUpdater: WeakReference;
    public function get searchResultsUpdater(): SearchResultsUpdating {
        return _searchResultsUpdater ? _searchResultsUpdater.value : null;
    }
    public function set searchResultsUpdater(value: SearchResultsUpdating): void {
        _searchResultsUpdater = new WeakReference(value);
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //------------------------------------
    //  searchBar
    //------------------------------------

    public function get searchBar(): SearchBar {
        return view as SearchBar;
    }

    //------------------------------------
    //  searchResultsController
    //------------------------------------

    private var _searchResultsController: ViewController;
    public function get searchResultsController(): ViewController {
        return _searchResultsController;
    }

    //------------------------------------
    //  isActive
    //------------------------------------

    private var _isActive: Boolean;
    public function get isActive(): Boolean {
        return _isActive;
    }
    public function set isActive(value: Boolean): void {
        _isActive = value;
    }

    //------------------------------------
    //  hidesNavigationBarDuringPresentation
    //------------------------------------

    private var _hidesNavigationBarDuringPresentation: Boolean;
    public function get hidesNavigationBarDuringPresentation(): Boolean {
        return true;
    }
    public function set hidesNavigationBarDuringPresentation(value: Boolean): void {
        _hidesNavigationBarDuringPresentation = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    override protected function loadView(): DisplayObject {
        var searchBar: SearchBar = new SearchBar();
        searchBar.addEventListener(FeathersEventType.INITIALIZE, searchBar_initializeHandler);
        return searchBar;
    }

    override protected function viewDidLoad(): void {
        super.viewDidLoad();
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function searchBar_initializeHandler(event: Event): void {
        searchBar.textField.addEventListener(Event.CHANGE, textField_changeHandler);
        searchBar.textField.addEventListener(FeathersEventType.FOCUS_IN, textField_focusInHandler);
    }

    private function textField_changeHandler(event: Event): void {
        if (searchResultsUpdater) {
            searchResultsUpdater.updateSearchResults(this);
        }
    }

    private function textField_focusInHandler(event: Event): void {
        if (searchResultsUpdater) {
            searchResultsUpdater.updateSearchResults(this);
        }
    }
}
}
