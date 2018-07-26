/**
 * Created by max.rozdobudko@gmail.com on 5/13/18.
 */
package feathersx.controls {
import flash.filesystem.File;
import flash.utils.ByteArray;

import starling.textures.Texture;

public class MovieLoaderTextureProviderFileDirectoryLoader implements MovieLoaderTextureProviderLoader {

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function MovieLoaderTextureProviderFileDirectoryLoader(source: Object) {
        super();

        _source = source as File;

        _listing = _source.getDirectoryListing();
        _listing.sortOn("name");
    }

    //--------------------------------------------------------------------------
    //
    //  Delegate
    //
    //--------------------------------------------------------------------------

    private var _delegate: MovieLoaderTextureProviderLoaderDelegate;
    public function get delegate(): MovieLoaderTextureProviderLoaderDelegate {
        return _delegate;
    }
    public function set delegate(value: MovieLoaderTextureProviderLoaderDelegate): void {
        _delegate = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var _listing: Array;

    private var _queue: MovieLoaderTextureProviderFileDirectoryLoaderQueue;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    private var _source: File;
    public function get source(): Object {
        return _source;
    }

    private var _isComplete = false;
    public function get isComplete(): Boolean {
        return _isComplete;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    public function loadSync(start: int, count: int): void {
        trace("MovieLoaderTextureProviderFileDirectoryLoader.loadSync");

        _queue = new MovieLoaderTextureProviderFileDirectoryLoaderQueue(_listing.slice(start, start + count));
        _queue.loadSync(handleProgress, function (error: Error = null): void {
            _isComplete = (start + count) >= _listing.length;
            handleCompletion(error);
        });
    }

    public function loadAsync(start: uint, count: int): void {
        trace("MovieLoaderTextureProviderFileDirectoryLoader.loadAsync");

        _queue = new MovieLoaderTextureProviderFileDirectoryLoaderQueue(_listing.slice(start, start + count));
        _queue.loadAsync(handleProgress, function (error: Error = null): void {
            _isComplete = (start + count) >= _listing.length;
            handleCompletion(error);
        });
    }

    public function dispose(): void {
        if (_queue) {
            _queue.cancel();
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Handlers
    //
    //--------------------------------------------------------------------------

    private function handleProgress(texture: Texture, bytes: ByteArray): void {
        if (delegate) {
            delegate.textureLoaderTextureDidLoad(this, texture, bytes);
        }
    }

    private function handleCompletion(error: Error = null): void {
        _queue = null;

        if (error) {
            if (delegate) {
                delegate.textureLoaderDidFailure(this, error);
            }
        } else {
            if (delegate) {
                delegate.textureLoaderDidLoad(this);
            }
            if (_isComplete) {
                if (delegate) {
                    delegate.textureLoaderDidComplete(this);
                }
            }
        }
    }
}
}
