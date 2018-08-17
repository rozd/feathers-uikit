/**
 * Created by max.rozdobudko@gmail.com on 8/17/18.
 */
package feathersx.mvvc {
public class ToolbarAppearance {

    // height

    private var _height: Number = 64.0;
    public function get height(): Number {
        return _height;
    }
    public function set height(value: Number): void {
        _height = value;
    }

}
}
