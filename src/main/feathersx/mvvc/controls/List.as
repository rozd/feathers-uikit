/**
 * Created by max.rozdobudko@gmail.com on 11/28/17.
 */
package feathersx.mvvc.controls {
import feathers.controls.List;
import feathers.data.IListCollection;

import feathersx.mvvc.ViewController;

import skein.core.WeakReference;

import starling.display.DisplayObject;

public class List extends feathers.controls.List {

    // Constructor

    public function List() {
        super();
    }

    // Delegate

    private var _delegate: WeakReference;
    public function get delegate(): ListDelegate {
        return _delegate ? _delegate.value : null;
    }
    public function set delegate(value: ListDelegate): void {
        _delegate = new WeakReference(value);
    }

    // Overridden properties

    override public function set dataProvider(value: IListCollection): void {
        if (dataProvider == value) {
            return;
        }

        super.dataProvider = value;

        _itemRendererFactories = null;
        _itemRendererFactory = null;

        function createItemRendererFactory(vc: ViewController): Function {
            return function (): DisplayObject {
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
}
}
