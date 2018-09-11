/**
 * Created by max.rozdobudko@gmail.com on 11/28/17.
 */
package feathersx.mvvc.controls {
import feathers.controls.List;
import feathers.controls.renderers.IListItemRenderer;
import feathers.data.IListCollection;
import feathers.events.FeathersEventType;

import feathersx.mvvc.ViewController;

import skein.core.WeakReference;

import starling.display.DisplayObject;
import starling.events.Event;

public class EmbedViewControllerList extends List {

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function EmbedViewControllerList() {
        super();
        addEventListener(FeathersEventType.RENDERER_REMOVE, renderRemoveHandler);
    }

    //--------------------------------------------------------------------------
    //
    //  Delegate
    //
    //--------------------------------------------------------------------------

    private var _delegate: WeakReference;
    public function get delegate(): EmbedViewControllerListDelegate {
        return _delegate ? _delegate.value : null;
    }
    public function set delegate(value: EmbedViewControllerListDelegate): void {
        _delegate = new WeakReference(value);
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    override public function set dataProvider(value: IListCollection): void {
        if (dataProvider == value) {
            return;
        }

        super.dataProvider = value;

        _itemRendererFactories = null;
        _itemRendererFactory = null;

        function createItemRendererFactory(vc: ViewController): Function {
            return function (): DisplayObject {
                prepareEmbeddedViewControllerToBePresented(vc);
                if (delegate) {
                    delegate.listViewControllerWillLoadView(vc);
                }
                return vc.view;
            }
        }

        if (dataProvider != null) {
            for (var i: int = 0; i < dataProvider.length; i++) {
                var vc: ViewController = dataProvider.getItemAt(i) as ViewController;
                setItemRendererFactoryWithID(vc.identifier, createItemRendererFactory(vc))
            }
            factoryIDFunction = function (vc: ViewController, index: int): String {
                return vc.identifier;
            };
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  parentViewController
    //-------------------------------------

    private var _parentViewController: ViewController;
    public function get parentViewController(): ViewController {
        return _parentViewController;
    }
    public function set parentViewController(value: ViewController): void {
        if (value == _parentViewController) return;
        _parentViewController = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    protected function prepareEmbeddedViewControllerToBePresented(vc: ViewController): void {
        if (parentViewController) {
            parentViewController.addChildViewController(vc);
        }
    }

    protected function prepareEmbeddedViewControllerToBeDismissed(vc: ViewController): void {
        if (vc.parent) {
            vc.removeFromParentViewController();
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function renderRemoveHandler(event: Event): void {
        var renderer: IListItemRenderer = event.data as IListItemRenderer;
        var vc: ViewController = renderer.data as ViewController;
        if (vc != null) {
            prepareEmbeddedViewControllerToBeDismissed(vc);
        }
    }

}
}
