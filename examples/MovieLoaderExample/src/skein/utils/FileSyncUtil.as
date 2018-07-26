/**
 * Created by max.rozdobudko@gmail.com on 1/18/18.
 */
package skein.utils {
import flash.debugger.enterDebugger;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.OutputProgressEvent;
import flash.utils.ByteArray;
import flash.utils.getDefinitionByName;

public class FileSyncUtil {

    //--------------------------------------------------------------------------
    //
    //  AIR classes references
    //
    //--------------------------------------------------------------------------

    protected static const File:Class = getDefinitionByName("flash.filesystem::File") as Class;

    protected static const FileMode:Class = getDefinitionByName("flash.filesystem::FileMode") as Class;

    protected static const FileStream:Class = getDefinitionByName("flash.filesystem::FileStream") as Class;

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    // Is Supported

    public static function get isSupported(): Boolean {
        return File && FileMode && FileStream;
    }

    // Save

    public static function save(file:Object, data:Object, callback:Function = null):void {
        var stream:Object = new FileStream();

        try {
            stream.open(file, FileMode.WRITE);

            if (data is ByteArray) {
                stream.writeBytes(data as ByteArray);
            } else {
                stream.writeObject(data);
            }
            stream.position = 0;
        } catch (error:Error) {
            if (callback != null) {
                callback(error);
            }
            return;
        }

        if (callback != null) {
            callback(stream.bytesAvailable);
            stream.close();
        }
    }

    // Read as Object

    public static function readObject(file:Object, callback:Function):void {
        open(file, function(value:*=undefined):void {
            if (value is FileStream) {
                var stream:Object = value as FileStream;

                var object:Object = stream.readObject();

                stream.close();

                callback(object);
            } else if (value is Error) {
                callback(value as Error);
            } else {
                callback();
            }
        });
    }

    // Read as ByteArray

    public static function readBytes(file:Object, callback:Function):void {
        open(file, function(value:*=undefined):void {
            if (value is FileStream) {
                var stream:Object = value as FileStream;

                var bytes:ByteArray = new ByteArray();
                stream.readBytes(bytes);

                stream.close();

                callback(bytes);
            } else if (value is Error) {
                callback(value as Error);
            } else {
                callback();
            }
        });
    }

    // Open File for read

    public static function open(file:Object, callback:Function):void {
        var stream:Object = new FileStream();

        try {
            stream.open(file, FileMode.READ);
        } catch (error: Error) {
            if (callback != null) {
                callback(error);
            }
            return;
        }

        if (callback != null) {
            callback(stream);
        }
    }
}
}
