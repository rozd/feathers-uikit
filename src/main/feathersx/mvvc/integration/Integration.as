/**
 * Created by max.rozdobudko@gmail.com on 8/17/18.
 */
package feathersx.mvvc.integration {
import feathersx.data.EdgeInsets;

public class Integration {

    private static var _safeAreaFunction: Function;
    public static function get safeAreaFunction(): Function {
        return _safeAreaFunction;
    }
    public static function set safeAreaFunction(value: Function): void {
        _safeAreaFunction = value;
    }

    public static function get safeArea(): EdgeInsets {
        if (_safeAreaFunction == null) {
            return new EdgeInsets(0, 0, 0, 0);
        }
        return _safeAreaFunction();
    }
}
}
