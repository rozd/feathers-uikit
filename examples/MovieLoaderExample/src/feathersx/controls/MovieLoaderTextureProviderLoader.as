/**
 * Created by max.rozdobudko@gmail.com on 5/13/18.
 */
package feathersx.controls {
public interface MovieLoaderTextureProviderLoader {

    function get delegate(): MovieLoaderTextureProviderLoaderDelegate;
    function set delegate(value: MovieLoaderTextureProviderLoaderDelegate): void;

    function get source(): Object;

    function get isComplete(): Boolean;

    function loadSync(start: int, count: int): void;

    function loadAsync(start: uint, count: int): void;

    function dispose(): void;
}
}
