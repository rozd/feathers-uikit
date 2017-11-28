/**
 * Created by max.rozdobudko@gmail.com on 11/28/17.
 */
package feathersx.mvvc.controls {
import avmplus.getQualifiedClassName;

import feathers.controls.List;
import feathers.data.IListCollection;

import feathersx.mvvc.ViewController;
import feathersx.mvvc.events.ListEventType;

import starling.display.DisplayObject;

public class List extends feathers.controls.List {

    // Constructor

    public function List() {
        super();
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
                dispatchEventWith(ListEventType.VIEW_CONTROLLER_WILL_LOAD_VIEW, false, vc);
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
