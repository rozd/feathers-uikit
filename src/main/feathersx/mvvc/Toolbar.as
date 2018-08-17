/**
 * Created by max.rozdobudko@gmail.com on 7/29/17.
 */
package feathersx.mvvc {
import feathers.controls.ButtonGroup;
import feathers.core.FeathersControl;
import feathers.data.VectorCollection;
import feathers.layout.Direction;
import feathers.layout.HorizontalAlign;

import flash.geom.Point;

import starling.display.Quad;
import starling.filters.DropShadowFilter;

public class Toolbar extends FeathersControl {

    public static const ITEM_STYLE_NAME: String = "feathers-mvvc-toolbar-item";

    public static const appearance: ToolbarAppearance = new ToolbarAppearance();

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function Toolbar() {
        super();
        height = appearance.height;
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
        var styleInvalid: Boolean = isInvalid(INVALIDATION_FLAG_STYLES);

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

        if (styleInvalid) {
            if (_isTransparent) {
                backgroundQuad.visible = false;
            } else {
                backgroundQuad.visible = true;
                backgroundQuad.color = _barTintColor;
                if (shadowColor != uint.MAX_VALUE) {
                    if (backgroundQuad.filter) {
                        backgroundQuad.filter.dispose();
                    }
                    backgroundQuad.filter = createDropShadow();
                }
            }
        }
    }

    private function createDropShadow():DropShadowFilter {

        if (shadowColor == uint.MAX_VALUE) {
            return null;
        }

        var alpha:Number = isNaN(shadowAlpha) ? 0.5 : shadowAlpha;
        var blur:Number = isNaN(shadowRadius) ? 1.0 : shadowRadius;

        var center:Point = new Point();
        var offset:Point = shadowOffset || center;
        var delta:Point = offset.subtract(center);

        var distance:Number = Math.sqrt((offset.x - center.x) ^ 2 + (offset.y - center.y) ^ 2);
        var angle:Number = Math.atan2(delta.y, delta.x);

        var filter:DropShadowFilter = new DropShadowFilter(distance, angle, shadowColor, alpha, blur);
        filter.cache();
        return filter;
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
        invalidate(INVALIDATION_FLAG_STYLES);
    }

    //------------------------------------
    //  isTransparent
    //------------------------------------

    private var _isTransparent:Boolean;
    public function get isTransparent(): Boolean {
        return _isTransparent;
    }
    public function set isTransparent(value: Boolean): void {
        if (value == _isTransparent) return;
        _isTransparent = value;
        invalidate(INVALIDATION_FLAG_STYLES);
    }

    //------------------------------------
    //  shadowColor
    //------------------------------------

    private var _shadowColor:uint = uint.MAX_VALUE;
    public function get shadowColor():uint {
        return _shadowColor;
    }
    public function set shadowColor(value:uint):void {
        if (value == _shadowColor) return;
        _shadowColor = value;
        invalidate(INVALIDATION_FLAG_STYLES);
    }

    //------------------------------------
    //  shadowOffset
    //------------------------------------

    private var _shadowOffset:Point;
    public function get shadowOffset():Point {
        return _shadowOffset;
    }
    public function set shadowOffset(value:Point):void {
        if (value == _shadowOffset) return;
        _shadowOffset = value;
        invalidate(INVALIDATION_FLAG_STYLES);
    }

    //------------------------------------
    //  shadowRadius
    //------------------------------------

    private var _shadowRadius:Number;
    public function get shadowRadius():Number {
        return _shadowRadius;
    }
    public function set shadowRadius(value:Number):void {
        if (value == _shadowRadius) return;
        _shadowRadius = value;
        invalidate(INVALIDATION_FLAG_STYLES);
    }

    //------------------------------------
    //  shadowAlpha
    //------------------------------------

    private var _shadowAlpha:Number;
    public function get shadowAlpha():Number {
        return _shadowAlpha;
    }
    public function set shadowAlpha(value:Number):void {
        if (value == _shadowAlpha) return;
        _shadowAlpha = value;
        invalidate(INVALIDATION_FLAG_STYLES);
    }

    //------------------------------------
    //  Appearance methods
    //------------------------------------

    public function resetAppearanceToDefault():void {
        barTintColor = 0xFFFFFF;
        isTransparent = false;
        shadowColor = uint.MAX_VALUE;
        shadowOffset = null;
        shadowRadius = NaN;
        shadowAlpha = NaN;
    }
}
}
