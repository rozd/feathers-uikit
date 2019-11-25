/**
 * Created by max.rozdobudko@gmail.com on 2/20/18.
 */
package utils {

import flash.utils.Dictionary;

import starling.animation.JugglerExt;
import starling.animation.Transitions;
import starling.core.Starling;
import starling.core.starling_internal;
import starling.display.DisplayObject;

use namespace starling_internal;

public class Tweens extends JugglerExt {

    public static const shared: Tweens = new Tweens();
    {
        Starling.juggler.add(shared);
    }

    // Pulse

    public function pulse(target: Object, time: Number, scale: Number, ease: Object = null, options: Object = null): uint {
        ease = ease || Transitions.LINEAR;
        if (target is DisplayObject && (options == null || !options.doNotCenterize)) {
            DisplayObject(target).pivotX = DisplayObject(target).width / 2;
            DisplayObject(target).pivotY = DisplayObject(target).height / 2;
        }
        return tweenWithEase(target, time, {reverse: true, repeatCount: 0, scale: scale}, ease);
    }

    public function spin(target: Object, time: Number, ease: Object = null, options: Object = null): void {
        options = options || {};
        options.delay = 0.4;
        tweenWithEase(target, time, {repeatCount: 0, rotation: -Math.PI * 2, repeatDelay: 0.4}, Transitions.EASE_OUT);
        tweenWithEase(target, time / 2, {repeatCount: 0, reverse: true, scale: 0.8, repeatDelay: 0.2}, Transitions.EASE_IN_OUT);
    }
}
}
