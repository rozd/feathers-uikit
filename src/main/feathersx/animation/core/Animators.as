/**
 * Created by max.rozdobudko@gmail.com on 8/22/17.
 */
package feathersx.animation.core {
import feathers.core.IFeathersControl;

import feathersx.animation.animators.Animator;
import feathersx.animation.animators.FeathersControlAnimator;

import flash.utils.Dictionary;

import starling.animation.Juggler;
import starling.core.Starling;

public class Animators {

    private static const _animators: Dictionary = new Dictionary();
    {
        _animators[IFeathersControl] = FeathersControlAnimator;
    }

    private static var _juggler: Juggler;
    public static function get juggler(): Juggler {
        if (_juggler == null) {
            _juggler = new Juggler();
            Starling.juggler.add(juggler);
        }
        return _juggler;
    }

    public static function registerAnimatorForControl(animator: Class, control: Class): void {

    }

    public static function getAnimatorForControl(control: Object): Animator {
        var ControlClass: Class = control.constructor;
        var AnimatorClass: Class = _animators[ControlClass];
        if (AnimatorClass == null) {
            for each (var Type: Class in _animators) {
                if (control is Type) {
                    AnimatorClass = Type;
                    break;
                }
            }
        }
        if (AnimatorClass == null) {
            throw new Error("Could not locate animator for control: " + control);
        }

        return new AnimatorClass(control);
    }
    
    public function Animators() {
    }
}
}
