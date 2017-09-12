/**
 * Created by max.rozdobudko@gmail.com on 9/11/17.
 */
package feathersx.mvvc {
public interface SearchBarDelegate {
    function searchBarTextDidChange(searchBar: SearchBar, text: String): void;
    function searchBarCancelButtonClicked(searchBar: SearchBar): void;
}
}
