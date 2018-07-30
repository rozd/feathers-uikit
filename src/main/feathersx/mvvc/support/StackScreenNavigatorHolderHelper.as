/**
 * Created by max.rozdobudko@gmail.com on 2/24/18.
 */
package feathersx.mvvc.support {
import feathers.controls.ScreenNavigatorItem;
import feathers.controls.StackScreenNavigator;
import feathers.controls.StackScreenNavigatorItem;
import feathers.controls.StackScreenNavigatorItem;
import feathers.controls.StackScreenNavigatorItem;
import feathers.controls.supportClasses.IScreenNavigatorItem;
import feathers.events.FeathersEventType;

import feathersx.mvvc.NavigatorItem;

import starling.events.Event;

public class StackScreenNavigatorHolderHelper {

    // Constructor

    public function StackScreenNavigatorHolderHelper(navigator: StackScreenNavigator) {
        super();
        _navigator = navigator;
    }

    // Navigator

    private var _navigator: StackScreenNavigator;

    // MARK: Add

    public function addScreenWithId(id: String, screen: StackScreenNavigatorItem, completion: Function): void {
        addScreensWithIds(new <String>[id], new <StackScreenNavigatorItem>[screen], completion);
    }

    public function addScreensWithIds(ids: Vector.<String>, screens: Vector.<StackScreenNavigatorItem>, completion: Function): void {
        waitForTransitionCompleteIfNeeded(function (): void {
            doAddScreensWithIds(ids, screens, completion);
        });
    }

    protected function doAddScreensWithIds(ids: Vector.<String>, items: Vector.<StackScreenNavigatorItem>, completion: Function): void {
        var result: Vector.<StackScreenNavigatorItem> = new Vector.<StackScreenNavigatorItem>();
        for (var i: int = 0; i < ids.length; i++) {
            var id: String = ids[i];
            var item: StackScreenNavigatorItem = items[i];
            if (_navigator.hasScreen(id)) {
                _navigator.removeScreen(id);
            }
            _navigator.addScreen(id, item);
        }
        if (completion != null) {
            completion();
        }
    }

    // MARK: Remove

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

        waitForTransitionCompleteIfNeeded(function (): void {
            doRemoveScreensWithIds(ids, completion);
        });
    }

    protected function doRemoveScreensWithIds(ids: Vector.<String>, completion: Function, dispose: Boolean = false): Vector.<StackScreenNavigatorItem> {
        var result: Vector.<StackScreenNavigatorItem> = new Vector.<StackScreenNavigatorItem>();
        for (var i: int = 0; i < ids.length; i++) {
            var id: String = ids[i];
            if (!_navigator.hasScreen(id)) {
                result[i] = null;
                continue;
            }
            var screen: StackScreenNavigatorItem = _navigator.getScreen(id);
            if (dispose && screen is NavigatorItem) {
                NavigatorItem(screen).disposeIfNeeded();
            }
            result[i] = _navigator.removeScreen(id);
        }
        if (completion != null) {
            completion();
        }
        return result;
    }

    // MARK: Push

    public function pushScreenWithId(id: String, screen: StackScreenNavigatorItem, transition: Function, completion: Function): void {
        addScreenWithId(id, screen, function(): void {
            _navigator.pushScreen(id, screen, getPushTransition(id, transition));
            if (completion != null) {
                completion();
            }
        });
    }

    // MARK: Pop

    public function popScreenWithId(id: String, transition: Function, completion: Function): void {
        waitForTransitionCompleteIfNeeded(function(): void {
            trackScreenTransitionComplete(function(): void {
                removeScreenWithId(id, completion);
            });
            _navigator.popScreen(getPopTransition(id, transition));
        });
    }

    public function popToRootScreenWithIds(ids: Vector.<String>, transition: Function, completion: Function): void {
        waitForTransitionCompleteIfNeeded(function(): void {
            trackScreenTransitionComplete(function(): void {
                doRemoveScreensWithIds(ids, completion, true);
            });
            _navigator.popToRootScreen(getPopToRootTransition(transition));
        });
    }

    // MARK: Root

    public function setRootScreenWithId(id: String, screen: StackScreenNavigatorItem, completion: Function): void {
        addScreenWithId(id, screen, function(): void {
            trackScreenTransitionComplete(completion);
            _navigator.rootScreenID = id;
        });
    }

    // MARK: Replace

    public function replaceScreenWithId(id: String, screen: StackScreenNavigatorItem, transition: Function, completion: Function): void {
        addScreenWithId(id, screen, function(): void {
            trackScreenTransitionComplete(completion);
            _navigator.replaceScreen(id, transition);
        });
    }

    // MARK: Transitions

    protected function getPushTransition(id: String, transition: Function): Function {
        if (transition == null) {
            return null;
        }
        var screen: StackScreenNavigatorItem = _navigator.getScreen(id);
        return screen.pushTransition || transition;
    }

    protected function getPopTransition(id: String, transition: Function): Function {
        if (transition == null) {
            return null;
        }
        var screen: StackScreenNavigatorItem = _navigator.getScreen(id);
        return screen.popTransition || transition;
    }

    private function getPopToRootTransition(transition: Function): Function {
        return getPopTransition(_navigator.rootScreenID, transition);
    }

    // MARK: Utils

    private function trackScreenTransitionStart(handler: Function): void {
        _navigator.addEventListener(FeathersEventType.TRANSITION_START, function(event: Event): void {
            _navigator.removeEventListener(FeathersEventType.TRANSITION_START, arguments.callee);
            if (handler != null) {
                handler();
            }
        });
    }

    private function trackScreenTransitionComplete(handler: Function): void {
        _navigator.addEventListener(FeathersEventType.TRANSITION_COMPLETE, function(event: Event): void {
            _navigator.removeEventListener(FeathersEventType.TRANSITION_COMPLETE, arguments.callee);
            if (handler != null) {
                handler();
            }
        });
    }

    private function waitForTransitionCompleteIfNeeded(handler: Function): void {
        if (_navigator.isTransitionActive) {
            trackScreenTransitionComplete(handler);
        } else {
            if (handler != null) {
                handler();
            }
        }
    }
}
}
