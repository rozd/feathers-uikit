/**
 * Created by max.rozdobudko@gmail.com on 5/13/18.
 */
package feathersx.controls {
import starling.textures.Texture;

public interface MovieLoaderTextureProvider {

    function get delegate(): MovieLoaderTextureProviderDelegate;
    function set delegate(value: MovieLoaderTextureProviderDelegate): void;

    function get hasTextures(): Boolean;
    function get textures(): Vector.<Texture>

    function get source(): Object;
    function set source(value: Object): void;

    function loadInitialTextures(): void;
    function loadFurtherTextures(): void;

    function dispose(): void;
}
}
