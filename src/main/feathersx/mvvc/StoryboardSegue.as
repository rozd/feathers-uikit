/**
 * Created by max.rozdobudko@gmail.com on 7/22/17.
 */
package feathersx.mvvc {
public class StoryboardSegue {

    //--------------------------------------------------------------------------
    //
    // Constructor
    //
    //--------------------------------------------------------------------------

    public function StoryboardSegue(identifier: String, source: ViewController, destination: ViewController) {
        super();
        _identifier = identifier;
        _source = source;
        _destination = destination;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    private var _source: ViewController;
    public function get source(): ViewController {
        return _source;
    }

    private var _destination: ViewController;
    public function get destination(): ViewController {
        return _destination;
    }

    private var _identifier: String;
    public function get identifier(): String {
        return _identifier;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    public function perform():void {

    }
}
}
