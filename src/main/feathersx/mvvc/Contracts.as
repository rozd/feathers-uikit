/**
 * Created by max.rozdobudko@gmail.com on 9/19/17.
 */
package feathersx.mvvc {
import flash.utils.Dictionary;

public class Contracts {

    private static const _implementations:Dictionary = new Dictionary();
    public static function setImplementationFor(contract:Class, implementation:Class):void {
        _implementations[contract] = implementation;
    }
    public static function getImplementationFor(contract:Class):Class {
        return _implementations[contract];
    }

    public static function hasImplementationFor(contract: Class): Boolean {
        return contract in _implementations;
    }

    public static function newInstanceFor(contract:Class):Object {
        var Implementation:Class = getImplementationFor(contract);

        if (Implementation != null) {
            return new Implementation();
        }

        return null;
    }
}
}
