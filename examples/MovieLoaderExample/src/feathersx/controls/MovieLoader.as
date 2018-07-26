/**
 * Created by max.rozdobudko@gmail.com on 5/13/18.
 */
package feathersx.controls {
import feathers.core.FeathersControl;

import flash.utils.getTimer;

import starling.core.Starling;
//import starling.display.MovieClip;
import starlingx.display.MovieClip;
import starling.events.Event;
import starling.textures.Texture;

public class MovieLoader extends FeathersControl implements MovieLoaderTextureProviderDelegate {

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function MovieLoader() {
        super();

        var provider: MovieLoaderDefaultTextureProvider = new MovieLoaderDefaultTextureProvider(10, 10);
        this.provider = provider;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    protected var movie: MovieClip;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //-------------------------------------
    //  provider
    //-------------------------------------

    private var _provider: MovieLoaderTextureProvider;
    public function get provider(): MovieLoaderTextureProvider {
        return _provider;
    }
    public function set provider(value: MovieLoaderTextureProvider): void {
        if (value == _provider) return;
        if (_provider != null) {
            _provider.delegate = null;
        }
        _provider = value;
        if (_provider != null) {
            _provider.delegate = this;
            _provider.source = _source;
        }
    }

    //-------------------------------------
    //  source
    //-------------------------------------

    private var _source: Object;
    public function get source(): Object {
        return _source;
    }
    public function set source(value: Object): void {
        if (value == _source) return;
        _source = value;
        if (_provider) {
            _provider.source = value;
        }
    }

    //-------------------------------------
    //  fps
    //-------------------------------------

    private var _fps: int = 24;
    public function get fps(): int {
        return _fps;
    }
    public function set fps(value: int): void {
        if (value == _fps) return;
        _fps = value;
        invalidate(INVALIDATION_FLAG_DATA);
    }

    //-------------------------------------
    //  isLooped
    //-------------------------------------

    private var _isLooped: Boolean = false;
    public function get isLooped(): Boolean {
        return _isLooped;
    }
    public function set isLooped(value: Boolean): void {
        if (value == _isLooped) return;
        _isLooped = value;
        invalidate(INVALIDATION_FLAG_DATA);
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    // Methods: FeathersControl

    override protected function initialize(): void {
        super.initialize();

        trace("MovieLoader.initialize1", getTimer());
        _provider.loadInitialTextures();
        trace("MovieLoader.initialize2", getTimer());
    }

    override protected function draw(): void {
        super.draw();

        var dataInvalid: Boolean = isInvalid(INVALIDATION_FLAG_DATA);
        var sizeInvalid: Boolean = isInvalid(INVALIDATION_FLAG_SIZE);

        if (dataInvalid) {
            refreshMovieClip();
        }

        if (dataInvalid || sizeInvalid) {
            layoutContent();
        }
    }

    // Layout

    protected function layoutContent(): void {
        if (movie) {
            setSizeInternal(movie.width, movie.height, false);
            trace(movie.width, movie.height);
            movie.x = (actualWidth - movie.width) / 2;
            movie.y = (actualHeight - movie.height) / 2;
        }
    }

    // Refresh

    protected function refreshMovieClip(): void {
        if (movie == null) {
            return;
        }

        movie.fps = fps;
        movie.loop = isLooped;
    }

    protected function createMovieClipIfNeeded(textures: Vector.<Texture>): void {
        if (movie != null) {
            return;
        }

        if (_provider == null) {
            return
        }

        if (_provider.textures == null || _provider.textures.length == 0) {
            return;
        }

        movie = new MovieClip(textures, fps);
        movie.loop = isLooped;
        addChild(movie);
        Starling.current.juggler.add(movie);

        invalidate(INVALIDATION_FLAG_SIZE);
    }

    protected function insertMovieClipTexture(texture: Texture): void {
        if (movie == null) {
            return;
        }

        movie.addFrame(texture);
    }

    // Methods: Dispose

    override public function dispose(): void {
        super.dispose();

        disposeMovieClipIfExists();

        disposeProviderIfExists();
    }

    protected function disposeMovieClipIfExists(): void {
        if (movie == null) {
            return;
        }

        Starling.current.juggler.remove(movie);
        movie.texture = null;
        removeChild(movie, true);
        movie = null;
    }

    protected function disposeProviderIfExists(): void {
        if (_provider == null) {
            return;
        }

        _provider.dispose();
        provider = null;
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    private function removedFromStageHandler(event: Event): void {
        disposeMovieClipIfExists();
    }

    // <MovieLoaderTextureProviderDelegate>

    public function textureProviderInitialTexturesDidLoad(provider: MovieLoaderTextureProvider, textures: Vector.<Texture>): void {
        createMovieClipIfNeeded(textures);

        provider.loadFurtherTextures();
    }

    public function textureProviderFurtherTextureDidLoad(provider: MovieLoaderTextureProvider, texture: Texture): void {
        insertMovieClipTexture(texture);
    }

    public function textureProviderBunchDidComplete(provider: MovieLoaderTextureProvider, bunchIndex: int): void {
        provider.loadFurtherTextures();
    }

    public function textureProviderDidComplete(provider: MovieLoaderTextureProvider): void {
        if (hasEventListener(Event.COMPLETE)) {
            dispatchEventWith(Event.COMPLETE);
        }
    }

    public function textureProviderDidFailure(provider: MovieLoaderDefaultTextureProvider, error: Error): void {
        if (hasEventListener(Event.IO_ERROR)) {
            dispatchEventWith(Event.IO_ERROR, false, error);
        }
    }
}
}
