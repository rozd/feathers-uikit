/**
 * Created by max.rozdobudko@gmail.com on 11/11/17.
 */
package feathersx.data {
public class EdgeInsets {

    public function EdgeInsets(top: Number, left: Number, bottom: Number, right: Number) {
        super();

        _top    = top;
        _left   = left;
        _bottom = bottom;
        _right  = right;
    }

    private var _top: Number;
    public function get top(): Number {
        return _top;
    }
    public function set top(value: Number): void {
        _top = value;
    }

    private var _left: Number;
    public function get left(): Number {
        return _left;
    }
    public function set left(value: Number): void {
        _left = value;
    }

    private var _right: Number;
    public function get right(): Number {
        return _right;
    }
    public function set right(value: Number): void {
        _right = value;
    }

    private var _bottom: Number;
    public function get bottom(): Number {
        return _bottom;
    }
    public function set bottom(value: Number): void {
        _bottom = value;
    }
}
}
