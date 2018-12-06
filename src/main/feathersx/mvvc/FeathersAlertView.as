/**
 * Created by max.rozdobudko@gmail.com on 9/20/17.
 */
package feathersx.mvvc {
import feathers.controls.Alert;
import feathers.core.PopUpManager;
import feathers.data.ArrayCollection;
import feathers.data.VectorCollection;

import flash.utils.Dictionary;

import skein.core.WeakReference;

import starling.events.Event;

public class FeathersAlertView extends Alert implements AlertView {

    public static const buttonNormal: String       = "mvvc-alert-view-normal-button";
    public static const buttonDefault: String      = "mvvc-alert-view-default-button";
    public static const buttonDestructive: String  = "mvvc-alert-view-destructive-button";
    public static const buttonCancellation: String = "mvvc-alert-view-cancellation-button";

    private static const STYLE_NAMES:Dictionary = new Dictionary();
    {
        STYLE_NAMES[AlertActionStyle.normal] = buttonNormal;
        STYLE_NAMES[AlertActionStyle.destructive] = buttonDestructive;
        STYLE_NAMES[AlertActionStyle.cancellation] = buttonCancellation;
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
        if (actions.length == 1) {
            _defaultAction = actions[0];
        }
        for (var i:uint = 0, n:uint = actions ? actions.length : 0; i < n; i++) {
            buttons[buttons.length] = {
                action    : actions[i],
                label     : actions[i].title,
                triggered : buttons_triggeredHandler
            };

            if (i == 0) {
                if (actions[i] == _defaultAction) {
                    buttonGroupProperties.customFirstButtonStyleName = buttonDefault;
                } else {
                    buttonGroupProperties.customFirstButtonStyleName = STYLE_NAMES[actions[i].style];
                }
            } else if (i == (n - 1)) {
                if (actions[i] == _defaultAction) {
                    buttonGroupProperties.customLastButtonStyleName = buttonDefault;
                } else {
                    buttonGroupProperties.customLastButtonStyleName = STYLE_NAMES[actions[i].style];
                }
            } else {
                if (actions[i] == _defaultAction) {
                    buttonGroupProperties.customButtonStyleName = buttonDefault;
                } else {
                    buttonGroupProperties.customButtonStyleName = STYLE_NAMES[actions[i].style];
                }
            }
        }
        buttonsDataProvider = new ArrayCollection(buttons);
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

    public function show(modal: Boolean): void {
        PopUpManager.addPopUp(this, modal, true, Alert.overlayFactory);
    }

    public function hide(): void {
        PopUpManager.removePopUp(this);
    }

    public function setPreferredStyle(preferredStyle: AlertControllerStyle): void {
    }
}
}
