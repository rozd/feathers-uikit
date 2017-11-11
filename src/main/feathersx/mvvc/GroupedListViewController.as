/**
 *
 * Created by max.rozdobudko@gmail.com on 11/11/17.
 */
package feathersx.mvvc {
import feathers.controls.GroupedList;

import skein.core.WeakReference;

import starling.display.DisplayObject;
import starling.events.Event;

public class GroupedListViewController extends ViewController {

    // Constructor

    public function GroupedListViewController() {
        super();
    }

    // Delegate

    private var _delegate: WeakReference;
    public function get delegate(): GroupedListDelegate {
        return _delegate ? _delegate.value : null;
    }
    public function set delegate(value: GroupedListDelegate): void {
        _delegate = new WeakReference(value);
    }

    // GroupedList

    public function get listView(): GroupedList {
        return this.view as GroupedList;
    }

    // View lifecycle

    override protected function loadView(): DisplayObject {
        return new GroupedList();
    }

    // Handlers

    protected function list_changeHandler(event: Event): void {
        if (delegate) {
            if (listView.selectedItem) {
                delegate.groupedListDidSelectRowAt(listView, listView.selectedGroupIndex, listView.selectedItemIndex, listView.selectedItem);
            } else {
                delegate.groupedListDidDeselectRowAt(listView, listView.selectedGroupIndex, listView.selectedItemIndex);
            }
        }
    }
}
}
