/**
 * Created by max.rozdobudko@gmail.com on 8/17/17.
 */
package feathersx.notification {
import flash.events.Event;

public class NotificationCenter {

    public function NotificationCenter() {
        super();
    }

    protected var handlers: Object = {};

    public function addObserver(notificationName: String, handler: Function): void {
        var handlers: Vector.<Function> = handlersForNotificationName(notificationName);
        if (handlers.indexOf(handler) == -1) {
            handlers[handlers.length] = handler;
        }
    }

    public function isRegistered(notificationName: String, handler: Function): void {

    }

    public function post(notification: Notification): void {

    }

    protected function handlersForNotificationName(notificationName: String): Vector.<Function> {
        if (notificationName in handlers) {
            return handlers[notificationName];
        } else {
            handlers[notificationName] = new <Function>[];
            return handlers[notificationName];
        }
    }
}
}
