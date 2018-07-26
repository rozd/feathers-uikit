/**
 * Created by max.rozdobudko@gmail.com on 2/24/18.
 */
package feathersx.mvvc.support {
import feathers.controls.ScreenNavigatorItem;
import feathers.controls.StackScreenNavigator;
import feathers.controls.StackScreenNavigatorItem;
import feathers.controls.supportClasses.IScreenNavigatorItem;
import feathers.events.FeathersEventType;

import starling.events.Event;

public class StackScreenNavigatorHolderHelper {

    // Constructor

    public function StackScreenNavigatorHolderHelper(navigator: StackScreenNavigator) {
        super();
        _navigator = navigator;
    }

    // Navigator

    private var _navigator: StackScreenNavigator;

    // Add

    public function addScreenWithId(id: String, screen: StackScreenNavigatorItem, completion: Function): void {

        removeScreenWithId(id, function (): void {
            _navigator.addScreen(id, screen);

            if (completion != null) {
                completion();
            }
        });
    }

    // Remove

    public function removeScreenWithId(id: String, completion: Function): void {
        removeScreenWithIds(new <String>[id], completion);
    }

    public function removeScreenWithIds(ids: Vector.<String>, completion: Function): void {
        var hasScreen: Boolean = ids.some(function(id: String, ...rest): Boolean {
            return _navigator.hasScreen(id);
        });

        if (!hasScreen) {
            if (completion != null) {
                completion();
            }
            return;
        }

        if (_navigator.isTransitionActive) {
            _navigator.addEventListener(FeathersEventType.TRANSITION_COMPLETE, function(event: Event): void {
                _navigator.removeEventListener(FeathersEventType.TRANSITION_COMPLETE, arguments.callee);
                doRemoveScreenWithIds(ids, completion);
            });
        }

        doRemoveScreenWithIds(ids, completion);
    }

    protected function doRemoveScreenWithIds(ids: Vector.<String>, completion: Function): Vector.<StackScreenNavigatorItem> {
        var result: Vector.<StackScreenNavigatorItem> = new Vector.<StackScreenNavigatorItem>();
        for (var i: int = 0; i < ids.length; i++) {
            var id: String = ids[i];
            result[i] = _navigator.hasScreen(id) ? _navigator.removeScreen(id) : null;
        }
        if (completion != null) {
            completion();
        }
        return result;
    }
}
}
