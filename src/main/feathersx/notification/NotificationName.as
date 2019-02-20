/**
 * Created by max.rozdobudko@gmail.com on 9/13/17.
 */
package feathersx.notification {
public class NotificationName {

    public function NotificationName(id: String) {
        super();
        _id = id;
    }

    private var _id: String;
    public function get id(): String {
        return _id;
    }
}
}
