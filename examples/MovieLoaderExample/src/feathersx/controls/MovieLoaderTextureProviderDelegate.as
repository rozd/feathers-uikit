/**
 * Created by max.rozdobudko@gmail.com on 5/13/18.
 */
package feathersx.controls {
import starling.textures.Texture;

public interface MovieLoaderTextureProviderDelegate {
    function textureProviderInitialTexturesDidLoad(provider: MovieLoaderTextureProvider, textures: Vector.<Texture>): void;
    function textureProviderFurtherTextureDidLoad(provider: MovieLoaderTextureProvider, texture: Texture): void;
    function textureProviderBunchDidComplete(provider: MovieLoaderTextureProvider, bunchIndex: int): void;

    function textureProviderDidComplete(provider: MovieLoaderTextureProvider): void;

    function textureProviderDidFailure(provider: MovieLoaderDefaultTextureProvider, error: Error): void;
}
}
