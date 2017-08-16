/**
 * Created by max.rozdobudko@gmail.com on 7/30/17.
 */
package feathersx.mvvc {
import feathers.core.FeathersControl;
import feathers.data.IListCollection;

public class NavigationItem {

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function NavigationItem(identifier: String) {
        super();
        _identifier = identifier
    }

    //--------------------------------------------------------------------------
    //
    //  Identifier
    //
    //--------------------------------------------------------------------------

    private var _identifier:String;
    public function get identifier(): String {
        return _identifier;
    }

    //--------------------------------------------------------------------------
    //
    //  Title
    //
    //--------------------------------------------------------------------------

    private var _title: String;
    public function get title(): String {
        return _title;
    }
    public function set title(value: String): void {
        _title = value;
    }

    private var _titleView: FeathersControl;
    public function get titleView(): FeathersControl {
        return _titleView;
    }
    public function set titleView(value: FeathersControl): void {
        _titleView = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Back Button
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  hidesBackButton
    //-------------------------------------

    private var _hidesBackButton: Boolean = false;
    public function get hidesBackButton():Boolean {
        return _hidesBackButton;
    }
    public function set hidesBackButton(value:Boolean):void {
        _hidesBackButton = value;
    }

    //-------------------------------------
    //  backBarButtonItem
    //-------------------------------------

    private var _backBarButtonItem: BarButtonItem;
    public function get backBarButtonItem(): BarButtonItem {
        return _backBarButtonItem;
    }
    public function set backBarButtonItem(value: BarButtonItem): void {
        _backBarButtonItem = value;
    }

    //-------------------------------------
    //  leftItemsSupplementBackButton
    //-------------------------------------

    private var _leftItemsSupplementBackButton: Boolean;
    public function get leftItemsSupplementBackButton(): Boolean {
        return _leftItemsSupplementBackButton;
    }
    public function set leftItemsSupplementBackButton(value: Boolean): void {
        _leftItemsSupplementBackButton = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Left Items
    //
    //--------------------------------------------------------------------------

    private var _leftItems:Vector.<BarButtonItem>;
    public function get leftItems(): Vector.<BarButtonItem> {
        return _leftItems;
    }
    public function set leftItems(value: Vector.<BarButtonItem>): void {
        setLeftItems(value, false);
    }

    public function setLeftItems(items: Vector.<BarButtonItem>, animated: Boolean): void {
        _leftItems = items;
    }

    //--------------------------------------------------------------------------
    //
    //  Right Items
    //
    //--------------------------------------------------------------------------

    private var _rightItems:Vector.<BarButtonItem>;
    public function get rightItems(): Vector.<BarButtonItem> {
        return _rightItems;
    }

    public function set rightItems(value: Vector.<BarButtonItem>): void {
        _rightItems = value;
    }
}
}
