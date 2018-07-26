/**
 * Created by max.rozdobudko@gmail.com on 5/13/18.
 */
package feathersx.controls {
import flash.filesystem.File;

public class MovieLoaderTextureProviderLoaderFactory {

    public static function createLoaderForSource(source: Object): MovieLoaderTextureProviderLoader {
        if (source is File) {
            return new MovieLoaderTextureProviderFileDirectoryLoader(source);
        }

        return null;
    }
}
}
