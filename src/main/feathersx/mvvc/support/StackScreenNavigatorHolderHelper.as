/**
 * Created by max.rozdobudko@gmail.com on 2/24/18.
 */
package feathersx.mvvc.support {
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

    // Methods

    public function addScreenWithId(id: String, screen: StackScreenNavigatorItem, completion: Function): void {

        removeScreenWithId(id, function (): void {
            _navigator.addScreen(id, screen);

            if (completion != null) {
                completion();
            }
        });
    }

    public function removeScreenWithId(id: String, completion: Function): void {

        function removeScreen(id: String): void {
            _navigator.removeScreen(id);

            if (completion != null) {
                completion();
            }
        }

        if (_navigator.hasScreen(id)) {
            if (_navigator.isTransitionActive) {
                _navigator.addEventListener(FeathersEventType.TRANSITION_COMPLETE, function(event: Event): void {
                    _navigator.removeEventListener(FeathersEventType.TRANSITION_COMPLETE, arguments.callee);
                    removeScreen(id);
                })
            } else {
                removeScreen(id);
            }
        } else if (completion != null) {
            completion();
        }
    }

}
}
