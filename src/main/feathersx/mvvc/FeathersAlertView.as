/**
 * Created by max.rozdobudko@gmail.com on 9/20/17.
 */
package feathersx.mvvc {
import feathers.controls.Alert;
import feathers.data.ArrayCollection;
import feathers.data.VectorCollection;

import flash.utils.Dictionary;

import skein.core.WeakReference;

import starling.events.Event;

public class FeathersAlertView extends Alert implements AlertView {

    public static const BUTTON_NORMAL: String       = "mvvc-alert-view-normal-button";
    public static const BUTTON_DEFAULT: String      = "mvvc-alert-view-default-button";
    public static const BUTTON_DESTRUCTIVE: String  = "mvvc-alert-view-destructive-button";
    public static const BUTTON_CANCELLATION: String = "mvvc-alert-view-cancellation-button";

    private static const STYLE_NAMES:Dictionary = new Dictionary();
    {
        STYLE_NAMES[AlertActionStyle.normal] = BUTTON_NORMAL;
        STYLE_NAMES[AlertActionStyle.destructive] = BUTTON_DESTRUCTIVE;
        STYLE_NAMES[AlertActionStyle.cancellation] = BUTTON_CANCELLATION;
    }

    public function FeathersAlertView() {
        super();
    }

    private var _delegate: WeakReference;
    public function get delegate(): AlertViewDelegate {
        return _delegate ? _delegate.value : null;
    }
    public function set delegate(value: AlertViewDelegate): void {
        _delegate = new WeakReference(value);
    }

    public function setTitle(title: String): void {
        this.title = title;
    }

    public function setMessage(message: String): void {
        this.message = message;
    }

    public function setActions(actions: Vector.<AlertAction>): void {
        var buttons: Array = [];
        for (var i:uint = 0, n:uint = actions ? actions.length : 0; i < n; i++) {
            buttons[buttons.length] = {
                action    : actions[i],
                label     : actions[i].title,
                triggered : buttons_triggeredHandler
            };

            if (i == 0) {
                if (actions[i] == _defaultAction) {
                    buttonGroupProperties.customFirstButtonStyleName = BUTTON_DEFAULT;
                } else {
                    buttonGroupProperties.customFirstButtonStyleName = STYLE_NAMES[actions[i].style];
                }
            } else if (i == (n - 1)) {
                if (actions[i] == _defaultAction) {
                    buttonGroupProperties.customLastButtonStyleName = BUTTON_DEFAULT;
                } else {
                    buttonGroupProperties.customLastButtonStyleName = STYLE_NAMES[actions[i].style];
                }
            } else {
                if (actions[i] == _defaultAction) {
                    buttonGroupProperties.customButtonStyleName = BUTTON_DEFAULT;
                } else {
                    buttonGroupProperties.customButtonStyleName = STYLE_NAMES[actions[i].style];
                }
            }
        }
        this.buttonsDataProvider = new ArrayCollection(buttons);
//        for (var i:uint = 0, n:uint = actions ? actions.length : 0; i < n; i++) {
//            if (i == 0) {
//                if (actions[i] == _defaultAction) {
//                    buttonGroupProperties.customFirstButtonStyleName = BUTTON_DEFAULT;
//                } else {
//                    buttonGroupProperties.customFirstButtonStyleName = STYLE_NAMES[actions[i].style];
//                }
//            } else if (i == (n - 1)) {
//                if (actions[i] == _defaultAction) {
//                    buttonGroupProperties.customLastButtonStyleName = BUTTON_DEFAULT;
//                } else {
//                    buttonGroupProperties.customLastButtonStyleName = STYLE_NAMES[actions[i].style];
//                }
//            } else {
//                if (actions[i] == _defaultAction) {
//                    buttonGroupProperties.customButtonStyleName = BUTTON_DEFAULT;
//                } else {
//                    buttonGroupProperties.customButtonStyleName = STYLE_NAMES[actions[i].style];
//                }
//            }
//        }
    }

    private var _defaultAction: AlertAction;
    public function setDefaultAction(action: AlertAction): void {
        _defaultAction = action;
    }

    private function buttons_triggeredHandler(event: Event, data: Object, button: Object): void {
        if (delegate) {
            delegate.alertViewDidCloseWithAction(this, button.action as AlertAction);
        }
    }
}
}
