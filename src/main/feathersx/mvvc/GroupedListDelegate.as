/**
 * Created by max.rozdobudko@gmail.com on 11/11/17.
 */
package feathersx.mvvc {
import feathers.controls.GroupedList;

public interface GroupedListDelegate {
    function groupedListDidSelectRowAt(list: GroupedList, groupIndex: int, itemIndex: int, item: Object): void;
    function groupedListDidDeselectRowAt(list: GroupedList, groupIndex: int, itemIndex: int): void;
}
}
