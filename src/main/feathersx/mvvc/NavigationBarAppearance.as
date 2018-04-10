/**
 * Created by max.rozdobudko@gmail.com on 4/10/18.
 */
package feathersx.mvvc {
public class NavigationBarAppearance {

    // Constructor

    public function NavigationBarAppearance() {
        super();
    }

    // paddingTop

    private var _paddingTop: Number = 0.0;
    public function get paddingTop(): Number {
        return _paddingTop;
    }
    public function set paddingTop(value: Number): void {
        _paddingTop = value;
    }

    // paddingLeft

    private var _paddingLeft: Number = 20.0;
    public function get paddingLeft(): Number {
        return _paddingLeft;
    }
    public function set paddingLeft(value: Number): void {
        _paddingLeft = value;
    }

    // paddingRight

    private var _paddingRight: Number = 20.0;
    public function get paddingRight(): Number {
        return _paddingRight;
    }
    public function set paddingRight(value: Number): void {
        _paddingRight = value;
    }

    // paddingBottom

    private var _paddingBottom: Number = 0.0;
    public function get paddingBottom(): Number {
        return _paddingBottom;
    }
    public function set paddingBottom(value: Number): void {
        _paddingBottom = value;
    }

    // height

    private var _height: Number = 60.0;
    public function get height(): Number {
        return _height;
    }
    public function set height(value: Number): void {
        _height = value;
    }
}
}
