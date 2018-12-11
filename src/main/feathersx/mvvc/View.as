/**
 * Created by max on 8/9/17.
 */
package feathersx.mvvc {
public interface View {
    function get topGuide():Number;
    function set topGuide(value: Number):void;

    function get leftGuide():Number;
    function set leftGuide(value: Number):void;

    function get bottomGuide():Number;
    function set bottomGuide(value: Number):void;

    function get rightGuide():Number;
    function set rightGuide(value: Number):void;
}
}
