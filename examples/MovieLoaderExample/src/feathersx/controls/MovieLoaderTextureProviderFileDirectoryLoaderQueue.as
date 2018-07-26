/**
 * Created by max.rozdobudko@gmail.com on 5/13/18.
 */
package feathersx.controls {
import flash.events.ErrorEvent;
import flash.filesystem.File;
import flash.utils.ByteArray;
import flash.utils.getTimer;

import skein.utils.FileAsyncUtil;

import skein.utils.FileSyncUtil;

import starling.textures.Texture;

public class MovieLoaderTextureProviderFileDirectoryLoaderQueue {

    // Constructor
    public function MovieLoaderTextureProviderFileDirectoryLoaderQueue(files: Array) {
        super();

        _files = files;
    }

    // Variables

    private var _files: Array;

    private var completeHandler: Function;
    private var progressHandler: Function;

    // Common

    private var isCancelled: Boolean = false;
    public function cancel(): void {
        isCancelled = true;
    }

    // Sync

    public function loadSync(progress: Function, complete: Function): void {
        progressHandler = progress;
        completeHandler = complete;

        doLoadSync(0);
    }

    private function doLoadSync(fileIndex: int): void {

        if (isCancelled) {
            notifyError(new Error("Cancelled loading texture."));
            return;
        }

        if (fileIndex >= _files.length) {
            notifySuccess();
            return;
        }

        FileSyncUtil.readBytes(_files[fileIndex], function (value: Object = null): void {
            trace("MovieLoaderTextureProviderFileDirectoryLoaderQueue.loaded("+_files[fileIndex].name+")", getTimer());

            if (value is ByteArray) {
                var texture: Texture = Texture.fromAtfData(value as ByteArray, 2, false);
                texture.root.onRestore = null;
                trace("MovieLoaderTextureProviderFileDirectoryLoaderQueue.loadedTexture("+_files[fileIndex].name+")", getTimer());
                notifyProgress(texture, value as ByteArray);
                doLoadSync(fileIndex + 1);
            } else {
                notifyError(value as Error);
            }

        });
    }

    // Async

    public function loadAsync(progress: Function, complete: Function): void {
        progressHandler = progress;
        completeHandler = complete;

        doLoadAsync(0);
    }

    private function doLoadAsync(fileIndex: int): void {

        if (isCancelled) {
            notifyError(new Error("Cancelled loading texture."));
            return;
        }

        if (fileIndex >= _files.length) {
            notifySuccess();
            return;
        }

        trace("MovieLoaderTextureProviderFileDirectoryLoaderQueue.load("+_files[fileIndex].name+")", getTimer());
        FileSyncUtil.readBytes(_files[fileIndex], function (value: Object = null): void {
            trace("MovieLoaderTextureProviderFileDirectoryLoaderQueue.loaded("+_files[fileIndex].name+")", getTimer());

            if (value is ByteArray) {
//                var texture: Texture = Texture.fromAtfData(value as ByteArray, 2, false);
//                texture.root.onRestore = null;
//                trace("MovieLoaderTextureProviderFileDirectoryLoaderQueue.loadedTexture("+_files[fileIndex].name+")", getTimer());
//                notifyProgress(texture, value as ByteArray);
//                doLoadAsync(fileIndex + 1);

                var texture: Texture = Texture.fromAtfData(value as ByteArray, 2, false, function(texture: Texture, error: ErrorEvent): void {
                    trace("MovieLoaderTextureProviderFileDirectoryLoaderQueue.loadedTexture("+_files[fileIndex].name+")", getTimer());
                    if (error) {
                        notifyError(new Error(error.text, error.errorID));
                    } else {
                        notifyProgress(texture, value as ByteArray);
                        doLoadAsync(fileIndex + 1);
                    }
                });
                texture.root.onRestore = null;
            } else {
                notifyError(value as Error);
            }
        });
    }

    // Notify

    private function notifyProgress(value: Texture, bytes: ByteArray): void {
        if (progressHandler != null) {
            progressHandler(value, bytes);
        }
    }

    private function notifySuccess(): void {
        if (completeHandler != null) {
            completeHandler();
        }
    }

    private function notifyError(error: Error): void {
        if (completeHandler != null) {
            if (error == null) {
                completeHandler(new Error("Unknown error during loading texture."));
            } else {
                completeHandler(error);
            }
        }
    }
}
}
