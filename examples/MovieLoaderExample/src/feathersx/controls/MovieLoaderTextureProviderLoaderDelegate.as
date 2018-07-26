/**
 * Created by max.rozdobudko@gmail.com on 5/13/18.
 */
package feathersx.controls {
import flash.utils.ByteArray;

import starling.textures.Texture;

public interface MovieLoaderTextureProviderLoaderDelegate {
    function textureLoaderTextureDidLoad(loader: MovieLoaderTextureProviderLoader, texture: Texture, bytes: ByteArray): void;
    function textureLoaderDidLoad(loader: MovieLoaderTextureProviderLoader): void;
    function textureLoaderDidFailure(loader: MovieLoaderTextureProviderFileDirectoryLoader, error: Error): void;
    function textureLoaderDidComplete(loader: MovieLoaderTextureProviderFileDirectoryLoader): void;
}
}
