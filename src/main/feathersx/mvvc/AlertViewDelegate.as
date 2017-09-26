/**
 * Created by max.rozdobudko@gmail.com on 9/19/17.
 */
package feathersx.mvvc {
public interface AlertViewDelegate {
    function alertViewDidCloseWithAction(alert: AlertView, action: AlertAction): void;
}
}
