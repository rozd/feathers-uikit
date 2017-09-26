/**
 * Created by max.rozdobudko@gmail.com on 9/13/17.
 */
package feathersx.mvvc {
public class AlertAction {
    public function AlertAction(title: String, style: AlertActionStyle, handler: Function = null) {
        super();
        _title = title;
        _style = style;
        _handler = handler;
    }

    private var _title: String;
    public function get title(): String {
        return _title;
    }

    private var _style: AlertActionStyle;
    public function get style(): AlertActionStyle {
        return _style;
    }

    private var _isEnabled: Boolean = true;
    public function get isEnabled(): Boolean {
        return _isEnabled;
    }
    public function set isEnabled(value: Boolean): void {
        _isEnabled = value;
    }

    private var _handler: Function;
    public function get handler(): Function {
        return _handler;
    }

    public function notify(): void {
        if (_handler != null) {
            if (_handler.length == 1) {
                _handler(this);
            } else {
                _handler();
            }
        }
    }

    public function toString(): String {
        return _title;
    }
}
}
