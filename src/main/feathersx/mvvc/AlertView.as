/**
 * Created by max.rozdobudko@gmail.com on 9/13/17.
 */
package feathersx.mvvc {
public interface AlertView {

    function set delegate(value: AlertViewDelegate): void;
    function get delegate(): AlertViewDelegate;

    function setTitle(title: String): void;
    function setMessage(message: String): void;
    function setActions(actions: Vector.<AlertAction>): void;
    function setDefaultAction(action: AlertAction): void;
}
}
