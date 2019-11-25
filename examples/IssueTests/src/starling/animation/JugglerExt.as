/**
 * Created by max.rozdobudko@gmail.com on 3/16/18.
 */
package starling.animation {
import starling.core.starling_internal;
import starling.events.Event;

use namespace starling_internal;

public class JugglerExt extends Juggler {

    private static const HINT_MARKER:String = '#';

    internal static function getPropertyHint(property:String):String
    {
        // colorization is special; it does not require a hint marker, just the word 'color'.
        if (property.indexOf("color") != -1 || property.indexOf("Color") != -1)
            return "rgb";

        var hintMarkerIndex:int = property.indexOf(HINT_MARKER);
        if (hintMarkerIndex != -1) return property.substr(hintMarkerIndex+1);
        else return null;
    }

    internal static function getPropertyName(property:String):String
    {
        var hintMarkerIndex:int = property.indexOf(HINT_MARKER);
        if (hintMarkerIndex != -1) return property.substring(0, hintMarkerIndex);
        else return property;
    }

    public function JugglerExt() {
        super();
    }

    public function tweenWithEase(target: Object, time: Number, properties: Object, ease: Object, complete: Function = null): uint {
        if (target == null) {
            throw new ArgumentError("target must not be null");
        }

        var tween:Tween = Tween.starling_internal::fromPool(target, time, ease);

        for (var property:String in properties) {
            var value:Object = properties[property];
            if (tween.hasOwnProperty(property)) {
                tween[property] = value;
            } else if (target.hasOwnProperty(getPropertyName(property))) {
                tween.animate(property, value as Number);
            } else {
                throw new ArgumentError("Invalid property: " + property);
            }
        }

        tween.addEventListener(Event.REMOVE_FROM_JUGGLER, function (event:Event):void {
            if (complete != null) {
                complete();
            }
            Tween.starling_internal::toPool(event.target as Tween);
        });

        return add(tween);
    }

    public function tweenPropertiesWithEase(target: Object, time: Number, fromProperties: Object, toProperties: Object, ease: Object, complete: Function = null): uint {
        for (var property:String in fromProperties) {
            var value:Object = fromProperties[property];
            if (target.hasOwnProperty(getPropertyName(property))) {
                target[property] = value as Number;
            } else {
                throw new ArgumentError("Invalid property: " + property);
            }
        }
        return tweenWithEase(target, time, toProperties, ease, complete);
    }
}
}
