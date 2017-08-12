/**
 * Created by max.rozdobudko@gmail.com on 7/29/17.
 */
package feathersx.mvvc {
import feathers.controls.ButtonGroup;
import feathers.core.FeathersControl;
import feathers.data.VectorCollection;
import feathers.layout.Direction;
import feathers.layout.HorizontalAlign;

import starling.display.Quad;

public class Toolbar extends FeathersControl {

    public static const ITEM_STYLE_NAME: String = "feathers-mvvc-toolbar-item";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function Toolbar() {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    protected var buttonGroup: ButtonGroup;

    protected var backgroundQuad: Quad;

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    override protected function initialize():void {
        super.initialize();

        backgroundQuad = new Quad(100, 100, _barTintColor);
        addChild(backgroundQuad);

        buttonGroup = new ButtonGroup();
        buttonGroup.customButtonStyleName = ITEM_STYLE_NAME;
        buttonGroup.direction = Direction.HORIZONTAL;
        buttonGroup.horizontalAlign = HorizontalAlign.JUSTIFY;
        buttonGroup.dataProvider = new VectorCollection(items);
        addChild(buttonGroup);
    }

    override protected function draw():void {
        super.draw();

        var sizeInvalid: Boolean = isInvalid(INVALIDATION_FLAG_SIZE);

        if (sizeInvalid) {
            if (buttonGroup) {
                buttonGroup.x = 0;
                buttonGroup.y = 0;
                buttonGroup.width = actualWidth;
                buttonGroup.height = actualHeight;
            }
            if (backgroundQuad) {
                backgroundQuad.x = 0;
                backgroundQuad.y = 0;
                backgroundQuad.width = actualWidth;
                backgroundQuad.height = actualHeight;
            }
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Items
    //
    //--------------------------------------------------------------------------

    private var _items: Vector.<BarButtonItem> = null;
    public function get items():Vector.<BarButtonItem> {
        return _items;
    }
    public function set items(value:Vector.<BarButtonItem>):void {
        setItems(value, false);
    }

    public function setItems(items:Vector.<BarButtonItem>, animated:Boolean):void {
        if (items == _items) {
            return;
        }
        _items = items;
        if (buttonGroup != null) {
            buttonGroup.dataProvider = new VectorCollection(items);
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Appearance
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  barTintColor
    //-------------------------------------

    private var _barTintColor: uint = 0xFFFFFF;
    public function get barTintColor():uint {
        return _barTintColor;
    }
    public function set barTintColor(value:uint):void {
        if (value == _barTintColor) return;
        _barTintColor = value;
        backgroundQuad.color= _barTintColor;
    }
}
}
