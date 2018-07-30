/**
 * Created by max.rozdobudko@gmail.com on 7/30/17.
 */
package feathersx.motion {
import feathers.motion.Slide;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.display.DisplayObject;

public class Slide extends feathers.motion.Slide {

    public static function createSlideLeftTransition(duration: Number = 0.5, ease: Object = Transitions.EASE_OUT, tweenProperties: Object = null, onProgress: Function = null, onComplete: Function = null): Function {
        var externalOnComplete: Function = onComplete;

        return function (oldScreen: DisplayObject, newScreen: DisplayObject, internalOnComplete: Function): void {
            function onComplete(): void {
                internalOnComplete();
                externalOnComplete();
            }

            if (!oldScreen && !newScreen) {
                throw new ArgumentError(SCREEN_REQUIRED_ERROR);
            }
            if (newScreen) {
                if (oldScreen) {
                    oldScreen.x = 0;
                    oldScreen.y = 0;
                }
                newScreen.x = newScreen.width;
                newScreen.y = 0;
                new SlideTween(newScreen, oldScreen, -newScreen.width, 0, duration, ease, onComplete, onProgress, tweenProperties);
            }
            else //we only have the old screen
            {
                oldScreen.x = 0;
                oldScreen.y = 0;
                new SlideTween(oldScreen, null, -oldScreen.width, 0, duration, ease, onComplete, onProgress, tweenProperties);
            }
        }
    }

    public static function createSlideRightTransition(duration: Number = 0.5, ease: Object = Transitions.EASE_OUT, tweenProperties: Object = null, onProgress: Function = null, onComplete: Function = null): Function {
        var externalOnComplete: Function = onComplete;

        return function (oldScreen: DisplayObject, newScreen: DisplayObject, internalOnComplete: Function): void {
            function onComplete(): void {
                internalOnComplete();
                externalOnComplete();
            }

            if (!oldScreen && !newScreen) {
                throw new ArgumentError(SCREEN_REQUIRED_ERROR);
            }
            if (newScreen) {
                if (oldScreen) {
                    oldScreen.x = 0;
                    oldScreen.y = 0;
                }
                newScreen.x = -newScreen.width;
                newScreen.y = 0;
                new SlideTween(newScreen, oldScreen, newScreen.width, 0, duration, ease, onComplete, onProgress, tweenProperties);
            }
            else //we only have the old screen
            {
                oldScreen.x = 0;
                oldScreen.y = 0;
                new SlideTween(oldScreen, null, oldScreen.width, 0, duration, ease, onComplete, onProgress, tweenProperties);
            }
        }
    }
}
}

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;

class SlideTween extends Tween {
    public function SlideTween(target: DisplayObject, otherTarget: DisplayObject,
                               xOffset: Number, yOffset: Number, duration: Number, ease: Object,
                               onCompleteCallback: Function, onProgressCallback:Function, tweenProperties: Object) {
        super(target, duration, ease);
        if (xOffset != 0) {
            _xOffset = xOffset;
            animate("x", target.x + xOffset);
        }
        if (yOffset != 0) {
            _yOffset = yOffset;
            animate("y", target.y + yOffset);
        }
        if (tweenProperties) {
            for (var propertyName: String in tweenProperties) {
                this[propertyName] = tweenProperties[propertyName];
            }
        }
        _navigator = target.parent;
        if (otherTarget) {
            _otherTarget = otherTarget;
            this.onUpdate = this.updateOtherTarget;
        } else {
            this.onUpdate = this.updateProgress;
        }
        _onCompleteCallback = onCompleteCallback;
        _onProgressCallback = onProgressCallback;
        this.onComplete = this.cleanupTween;
        Starling.juggler.add(this);
    }

    private var _navigator: DisplayObject;
    private var _otherTarget: DisplayObject;
    private var _onCompleteCallback: Function;
    private var _onProgressCallback: Function;
    private var _xOffset: Number = 0;
    private var _yOffset: Number = 0;

    private function updateProgress(): void {
        if (_onProgressCallback !== null) {
            if (_onProgressCallback.length == 1) {
                _onProgressCallback(this.progress);
            } else {
                _onProgressCallback();
            }
        }
    }

    private function updateOtherTarget(): void {
        var newScreen: DisplayObject = DisplayObject(this.target);
        if (_xOffset < 0) {
            _otherTarget.x = newScreen.x - _navigator.width;
        }
        else if (_xOffset > 0) {
            _otherTarget.x = newScreen.x + newScreen.width;
        }
        if (_yOffset < 0) {
            _otherTarget.y = newScreen.y - _navigator.height;
        }
        else if (_yOffset > 0) {
            _otherTarget.y = newScreen.y + newScreen.height;
        }
        if (_onProgressCallback !== null) {
            if (_onProgressCallback.length == 1) {
                _onProgressCallback(this.progress);
            } else {
                _onProgressCallback();
            }
        }
    }

    private function cleanupTween(): void {
        this.target.x = 0;
        this.target.y = 0;
        if (_otherTarget) {
            _otherTarget.x = 0;
            _otherTarget.y = 0;
        }
        if (_onCompleteCallback !== null) {
            _onCompleteCallback();
        }
    }
}