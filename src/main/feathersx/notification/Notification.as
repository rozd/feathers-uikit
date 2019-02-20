/**
 * Created by max.rozdobudko@gmail.com on 9/13/17.
 */
package feathersx.notification {
public class Notification {
    public function Notification(name: String, userInfo: Object = null) {
        super();
        _name = name;
        _userInfo = userInfo;
    }

    private var _name: String;
    public function get name(): String {
        return _name;
    }
    public function set name(value: String): void {
        _name = value;
    }

    private var _userInfo: Object;
    public function get userInfo(): Object {
        return _userInfo;
    }
        public function set userInfo(value: Object): void {
        _userInfo = value;
    }
}
}
