/**
 * Created by max.rozdobudko@gmail.com on 5/13/18.
 */
package feathersx.controls {
import flash.utils.ByteArray;

import starling.textures.Texture;

public class MovieLoaderDefaultTextureProvider implements MovieLoaderTextureProvider, MovieLoaderTextureProviderLoaderDelegate {

    //--------------------------------------------------------------------------
    //
    //  Constants
    //
    //--------------------------------------------------------------------------

    public static const defaultInitialBunchSize: int = 10;
    public static const defaultFurtherBunchSize: int = 10;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function MovieLoaderDefaultTextureProvider(initialBunchSize: int, furtherBunchSize: int) {
        super();

        _initialBunchSize = initialBunchSize;
        _furtherBunchSize = furtherBunchSize;
    }

    //--------------------------------------------------------------------------
    //
    //  Delegate
    //
    //--------------------------------------------------------------------------

    private var _delegate: MovieLoaderTextureProviderDelegate;
    public function get delegate(): MovieLoaderTextureProviderDelegate {
        return _delegate;
    }
    public function set delegate(value: MovieLoaderTextureProviderDelegate): void {
        _delegate = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  initialBunchSize
    //-------------------------------------

    private var _initialBunchSize: int = defaultInitialBunchSize;
    public function get initialBunchSize(): int {
        return _initialBunchSize > 0 ? _initialBunchSize : defaultFurtherBunchSize;
    }

    //-------------------------------------
    //  furtherBunchSize
    //-------------------------------------

    private var _furtherBunchSize: int = defaultFurtherBunchSize;
    public function get furtherBunchSize(): int {
        return _furtherBunchSize > 0 ? _furtherBunchSize : defaultFurtherBunchSize;
    }

    //--------------------------------------------------------------------------
    //
    //  Textures
    //
    //--------------------------------------------------------------------------

    public function get hasTextures(): Boolean {
        return _textures != null && _textures.length > 0;
    }

    private var _textures: Vector.<Texture> = new <Texture>[];
    public function get textures(): Vector.<Texture> {
        return _textures;
    }

    //--------------------------------------------------------------------------
    //
    //  Load
    //
    //--------------------------------------------------------------------------

    protected var loader: MovieLoaderTextureProviderLoader;

    public function get source(): Object {
        return loader != null ? loader.source : null;
    }
    public function set source(value: Object): void {
        if (loader != null) {
            loader.delegate = null;
        }
        loader = MovieLoaderTextureProviderLoaderFactory.createLoaderForSource(value);
        if (loader != null) {
            loader.delegate = this;
        }
    }

    public function loadInitialTextures(): void {
        if (loader == null || loader.isComplete) {
            return;
        }

        loader.loadSync(0, initialBunchSize)
    }

    public function loadFurtherTextures(): void {
        if (loader == null || loader.isComplete) {
            return;
        }

        loader.loadAsync(_textures.length, furtherBunchSize);
    }

    //--------------------------------------------------------------------------
    //
    //  Dispose
    //
    //--------------------------------------------------------------------------

    public function dispose(): void {
        if (loader != null) {
            loader.dispose();
            loader.delegate = null;
            loader = null;
        }

        _textures.forEach(function(texture: Texture, ...rest): * {
            texture.root.onRestore = null;
            texture.dispose();
        });

        _textures.length = 0;
    }

    // <MovieLoaderTextureProviderLoaderDelegate>

    public function textureLoaderTextureDidLoad(loader: MovieLoaderTextureProviderLoader, texture: Texture, bytes: ByteArray): void {

        texture.root.onRestore = function(): void {
            texture.root.uploadAtfData(bytes, 0);
        };

        _textures.push(texture);

        var bunchIndex: int = 0;
        var bunchLength: int = _textures.length;

        if (_textures.length > initialBunchSize) {
            var furtherTextures: Vector.<Texture> = _textures.slice(initialBunchSize);
            bunchIndex = Math.ceil(furtherTextures.length / furtherBunchSize);
            bunchLength = furtherTextures.length - (bunchIndex - 1) * furtherBunchSize;
        }

        if (bunchIndex == 0) {
            if (bunchLength == initialBunchSize) {
                if (delegate) {
                    delegate.textureProviderInitialTexturesDidLoad(this, _textures);
                }
            }
        } else {
            if (delegate) {
                delegate.textureProviderFurtherTextureDidLoad(this, texture);
            }
        }
    }

    public function textureLoaderDidLoad(loader: MovieLoaderTextureProviderLoader): void {

        var bunchIndex: int = 0;

        if (_textures.length > initialBunchSize) {
            var furtherTextures: Vector.<Texture> = _textures.slice(initialBunchSize);
            bunchIndex = Math.ceil(furtherTextures.length / furtherBunchSize);
        }

        if (_textures.length < initialBunchSize) {
            if (delegate) {
                delegate.textureProviderInitialTexturesDidLoad(this, _textures);
            }
        } else if (_textures.length > initialBunchSize) {
            var bunchIndex: int = Math.ceil(_textures.slice(initialBunchSize).length / furtherBunchSize);
            if (delegate) {
                delegate.textureProviderBunchDidComplete(this, bunchIndex);
            }
        }
    }

    public function textureLoaderDidComplete(loader: MovieLoaderTextureProviderFileDirectoryLoader): void {
        if (delegate) {
            delegate.textureProviderDidComplete(this);
        }
    }

    public function textureLoaderDidFailure(loader: MovieLoaderTextureProviderFileDirectoryLoader, error: Error): void {
        if (delegate) {
            delegate.textureProviderDidFailure(this, error);
        }
    }

}
}
