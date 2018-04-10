/**
 * Created by max.rozdobudko@gmail.com on 9/11/17.
 */
package feathersx.mvvc {
import feathers.controls.Button;
import feathers.controls.LayoutGroup;
import feathers.controls.TextInput;
import feathers.layout.HorizontalAlign;
import feathers.layout.HorizontalLayout;
import feathers.layout.HorizontalLayoutData;
import feathers.layout.VerticalAlign;

import flash.utils.Dictionary;

import skein.core.WeakReference;

import starling.display.DisplayObject;
import starling.display.Quad;
import starling.events.Event;

public class SearchBar extends LayoutGroup {

    //--------------------------------------------------------------------------
    //
    //  Style constants
    //
    //--------------------------------------------------------------------------

    public static const SEARCH_BAR_INPUT_STYLE_NAME: String         = "mvvc-search-bar-input";
    public static const SEARCH_BAR_CANCEL_BUTTON_STYLE_NAME: String = "mvvc-search-bar-cancel-button";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function SearchBar() {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    protected var textField: TextInput;

    protected var cancelButton: Button;

    protected var _iconToStateToImage: Dictionary = new Dictionary();

    //--------------------------------------------------------------------------
    //
    //  Delegate
    //
    //--------------------------------------------------------------------------

    private var _delegate: WeakReference;
    public function get delegate(): SearchBarDelegate {
        return _delegate ? _delegate.value : null;
    }
    public function set delegate(value: SearchBarDelegate): void {
        _delegate = new WeakReference(value);
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  text
    //-------------------------------------

    private var _text: String;
    public function get text(): String {
        return _text;
    }
    public function set text(value: String): void {
        if (_text == value) return;
        _text = value;
        invalidate(INVALIDATION_FLAG_DATA);
    }

    //-------------------------------------
    //  placeholder
    //-------------------------------------

    private var _placeholder: String;
    public function get placeholder(): String {
        return _placeholder;
    }
    public function set placeholder(value: String): void {
        if (value == _placeholder) return;
        _placeholder = value;
        invalidate(INVALIDATION_FLAG_DATA);
    }

    //-------------------------------------
    //  showsCancelButton
    //-------------------------------------

    private var _showsCancelButton: Boolean;
    public function get showsCancelButton(): Boolean {
        return _showsCancelButton;
    }
    public function set showsCancelButton(value: Boolean): void {
        if (value == _showsCancelButton) return;
        _showsCancelButton = value;
        invalidate(INVALIDATION_FLAG_STYLES);
    }

    //-------------------------------------
    //  cancelLabel
    //-------------------------------------

    private var _cancelLabel: String;
    public function get cancelLabel(): String {
        return _cancelLabel;
    }
    public function set cancelLabel(value: String): void {
        if (value == _cancelLabel) return;
        _cancelLabel = value;
        invalidate(INVALIDATION_FLAG_DATA);
    }

    //-------------------------------------
    //  defaultSearchIcon
    //-------------------------------------

    private var _defaultSearchIcon: DisplayObject;
    public function get defaultSearchIcon(): DisplayObject {
        return _defaultSearchIcon;
    }
    public function set defaultSearchIcon(value: DisplayObject): void {
        _defaultSearchIcon = value;
    }

    //-------------------------------------
    //  backgroundColor
    //-------------------------------------

    private var _backgroundColor: uint = 0xFFFFFF;
    public function get backgroundColor(): uint {
        return _backgroundColor;
    }
    public function set backgroundColor(value: uint): void {
        if (this.processStyleRestriction(arguments.callee)) {
            return;
        }
        if (value == _backgroundColor) {
            return;
        }
        _backgroundColor = value;
        invalidate(INVALIDATION_FLAG_STYLES);
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    override protected function initialize(): void {
        super.initialize();

        if (_layout == null) {
            var layout: HorizontalLayout = new HorizontalLayout();
            layout.verticalAlign = VerticalAlign.MIDDLE;
            layout.horizontalAlign = HorizontalAlign.LEFT;
            layout.useVirtualLayout = false;
            layout.paddingTop = NavigationBar.appearance.paddingTop;
            layout.paddingLeft = NavigationBar.appearance.paddingLeft;
            layout.paddingRight = NavigationBar.appearance.paddingRight;
            layout.paddingBottom = NavigationBar.appearance.paddingBottom;
            this.layout = layout;
        }

        if (backgroundSkin == null) {
            backgroundSkin = new Quad(1, 1, _backgroundColor);
        }
    }

    override protected function draw(): void {
        super.draw();

        var dataInvalid: Boolean = isInvalid(INVALIDATION_FLAG_DATA);
        var stylesInvalid: Boolean = isInvalid(INVALIDATION_FLAG_STYLES);

        if (dataInvalid || stylesInvalid) {
            rearrangeChildren();
        }

        if (dataInvalid) {
            commitData();
        }

        if (stylesInvalid) {
            if (_backgroundSkin is Quad) {
                Quad(_backgroundSkin).color = _backgroundColor;
            }
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    //------------------------------------
    //  Methods: Children
    //------------------------------------

    protected function commitData(): void {
        textField.prompt = _placeholder;
        textField.text = _text;

        if (cancelButton) {
            cancelButton.label = _cancelLabel;
        }
    }

    protected function rearrangeChildren(): void {
        createTextFieldIfRequired();
        setChildIndex(textField, 0);

        if (showsCancelButton) {
            createCancelButtonIfRequired();
            setChildIndex(cancelButton, 1);
        } else {
            removeCancelButtonIfExists();
        }
    }

    //------------------------------------
    //  Methods: Icon
    //------------------------------------

    public function setImageForIconState(image: DisplayObject, icon: SearchBarIcon, state: String): void {
        var key:String = "setImageForIconState--" + icon.name;

        if (this.processStyleRestriction(key)) {
            return;
        }

        if (!(icon in _iconToStateToImage)) {
            _iconToStateToImage[icon] = {};
        }

        _iconToStateToImage[icon][state] = image;
    }

    //------------------------------------
    //  Methods: Text Field
    //------------------------------------

    protected function createTextFieldIfRequired():void {
        if (textField == null) {
            textField = new TextInput();
            textField.addEventListener(Event.CHANGE, textField_changeHandler);
            textField.styleName = SEARCH_BAR_INPUT_STYLE_NAME;
            textField.layoutData = new HorizontalLayoutData(100);
            textField.defaultIcon = _defaultSearchIcon;
            if (SearchBarIcon.Search in _iconToStateToImage) {
                var stateToIcon: Object = _iconToStateToImage[SearchBarIcon.Search];
                for (var state: String in stateToIcon) {
                    textField.setIconForState(state, stateToIcon[state]);
                }
            }
            addChild(textField);
        }
    }

    //------------------------------------
    //  Methods: Cancel Button
    //------------------------------------

    protected function createCancelButtonIfRequired(): void {
        if (cancelButton == null && showsCancelButton) {
            cancelButton = new Button();
            cancelButton.addEventListener(Event.TRIGGERED, cancelButton_triggeredHandler);
            cancelButton.styleName = SEARCH_BAR_CANCEL_BUTTON_STYLE_NAME;
            addChild(cancelButton);
        }
    }

    protected function removeCancelButtonIfExists(): void {
        if (cancelButton != null) {
            cancelButton.removeEventListener(Event.TRIGGERED, cancelButton_triggeredHandler);
            cancelButton.removeFromParent(true);
            cancelButton = null;
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function textField_changeHandler(event: Event): void {
        _text = textField.text;
        if (delegate) {
            delegate.searchBarTextDidChange(this, _text);
        }
    }

    private function cancelButton_triggeredHandler(event: Event): void {
        if (delegate) {
            delegate.searchBarCancelButtonClicked(this);
        }
    }
}
}
