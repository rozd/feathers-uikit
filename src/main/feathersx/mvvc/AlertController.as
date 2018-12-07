/**
 * Created by max.rozdobudko@gmail.com on 9/13/17.
 */
package feathersx.mvvc {
import feathersx.data.EdgeInsets;

import starling.display.DisplayObject;

public class AlertController extends ViewController implements AlertViewDelegate {

    // MARK: - Static initialization

    {
        if (!Contracts.hasImplementationFor(AlertView)) {
            Contracts.setImplementationFor(AlertView, FeathersAlertView);
        }
    }

    // MARK: - Constructor

    public function AlertController(title: String, message: String, preferredStyle: AlertControllerStyle) {
        super();
        _title = title;
        _message = message;
        _preferredStyle = preferredStyle;
        _modalPresentationStyle = ModalPresentationStyle.none;
        isModalInPopover = true;
    }

    // MARK: - Properties

    // title

    private var _title: String;
    public function get title(): String {
        return _title;
    }
    public function set title(value: String): void {
        _title = value;
    }

    // message

    private var _message: String;
    public function get message(): String {
        return _message;
    }
    public function set message(value: String): void {
        _message = value;
    }

    // preferredStyle

    private var _preferredStyle: AlertControllerStyle;
    public function get preferredStyle(): AlertControllerStyle {
        return _preferredStyle;
    }

    // MARK: - Overridden behaviour

    override public function get safeArea(): EdgeInsets {
        return additionalSafeAreaInsets;
    }

    // MARK: - View lifecycle

    override protected function loadView(): DisplayObject {
        var alert: AlertView = Contracts.newInstanceFor(AlertView) as AlertView;
        alert.delegate = this;
        alert.setTitle(_title);
        alert.setMessage(_message);
        alert.setPreferredStyle(_preferredStyle);
        alert.setDefaultAction(_preferredAction);
        alert.setActions(_actions);
        return alert as DisplayObject;
    }

    // MARK: - Show / Hide Alert

    public function showAlertFromViewController(vc: ViewController): void {
        AlertView(view).show(isModalInPopover);
        dispose();
    }

    public function hideAlertFromViewController(vc: ViewController): void {
        AlertView(view).hide();
    }

    // MARK: - Actions

    private var _actions: Vector.<AlertAction> = new <AlertAction>[];
    public function get actions(): Vector.<AlertAction> {
        return _actions;
    }

    private var _preferredAction: AlertAction;
    public function get preferredAction(): AlertAction {
        return _preferredAction;
    }
    public function set preferredAction(value: AlertAction): void {
        if (_actions.indexOf(value) == -1) {
            throw new ArgumentError("An action object should be added to the alert controller before assign it to the preferredAction property.");
        }
        _preferredAction = value;
    }

    public function addAction(action: AlertAction): void {
        _actions[_actions.length] = action;
    }

    public function addPreferredAction(action: AlertAction): void {
        addAction(action);
        preferredAction = action;
    }

    // MARK: <AlertViewDelegate>

    public function alertViewDidCloseWithAction(alert: AlertView, action: AlertAction): void {
        dismiss(true);
        if (action) {
            action.notify();
        }
    }
}
}
