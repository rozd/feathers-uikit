/**
 * Created by max.rozdobudko@gmail.com on 8/22/17.
 */
package feathersx.animation.animators {
import feathers.core.IFeathersControl;

import feathersx.animation.core.Animators;

public class FeathersControlAnimator implements Animator {

    private static const PropertyNames: Vector.<String> = new <String>["x", "y"];

    public function FeathersControlAnimator(control: IFeathersControl) {
        super();
        _control = control;
    }

    private var _control: IFeathersControl;
    public function get control(): IFeathersControl {
        return _control;
    }

    public function animateWithDuration(duration: Number, animations: Function): void {
        var startProperties: Object = retrieveAnimatablePropertiesFromControl(_control);
        animations();
        var finishProperties: Object = retrieveAnimatablePropertiesFromControl(_control);

        finishProperties = getDifferenceBetween(startProperties, finishProperties);

        applyAnimatablePropertiesForControl(startProperties, control);

        Animators.juggler.tween(control, duration / 1000, finishProperties);
    }

    protected function retrieveAnimatablePropertiesFromControl(control: IFeathersControl): Object {
        var props: Object = {};
        for each (var propertyName: String in PropertyNames) {
            props[propertyName] = control[propertyName];
        }
        return props;
    }

    protected function applyAnimatablePropertiesForControl(properties: Object, control: IFeathersControl): void {
        for each (var propertyName: String in PropertyNames) {
            if (properties.hasOwnProperty(propertyName)) {
                control[propertyName] = properties[propertyName];
            }
        }
    }

    protected function getDifferenceBetween(start: Object, finish: Object): Object {
        var props: Object = {};
        for (var propertyName: String in finish) {
            if (start.hasOwnProperty(propertyName) && start[propertyName] == finish[propertyName]) {
                continue;
            }
            props[propertyName] = finish[propertyName];
        }
        return props;
    }
}
}
