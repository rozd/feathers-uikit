/**
 *
 * Created by max.rozdobudko@gmail.com on 11/11/17.
 */
package feathersx.mvvc {
import feathers.controls.GroupedList;

import starling.display.DisplayObject;
import starling.events.Event;

public class GroupedListViewController extends ViewController {

    // Constructor

    public function GroupedListViewController() {
        super();
    }

    // GroupedList

    public function get listView(): GroupedList {
        return this.view as GroupedList;
    }

    // View lifecycle

    override protected function loadView(): DisplayObject {
        return new GroupedList();
    }

    override protected function loadViewIfRequired(): void {
        var isFirstCall: Boolean = !isViewLoaded;
        super.loadViewIfRequired();
        if (isFirstCall) {
            listView.addEventListener(Event.CHANGE, listView_changeHandler);
        }
    }

    // Grouped List abstract methods

    protected function didSelectRowAt(groupIndex: int, itemIndex: int, item: Object): void {

    }

    protected function didDeselectRowAt(groupIndex: int, itemIndex: int): void {

    }

    // Handlers

    protected function listView_changeHandler(event: Event): void {
        if (listView.selectedItem) {
            didSelectRowAt(listView.selectedGroupIndex, listView.selectedItemIndex, listView.selectedItem);
        } else {
            didDeselectRowAt(listView.selectedGroupIndex, listView.selectedItemIndex);
        }
    }
}
}
