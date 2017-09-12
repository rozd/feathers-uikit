/**
 * Created by max.rozdobudko@gmail.com on 9/11/17.
 */
package feathersx.mvvc {
public class SearchBarIcon {
    public static const Search: SearchBarIcon = new SearchBarIcon("search");

    public function SearchBarIcon(name: String) {
        super();
        _name = name;
    }

    private var _name: String;
    public function get name(): String {
        return _name;
    }
}
}
