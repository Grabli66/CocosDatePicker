#if macro
import haxe.crypto.Base64;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import sys.io.File;
import haxe.io.Bytes;
#end

class AssetHelper {
    /**
     * Inline svg like data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL...
     */
    public static macro function inlineSvgData(path:String):ExprOf<String> {
        var fileContent = File.getContent(path);
        var base64Content = Base64.encode(Bytes.ofString(fileContent));
        var content = "data:image/svg+xml;base64," + base64Content;
        return macro $v{content};
    }

    /**
     * Inline text
     */
    public static macro function inlineText(path:String):ExprOf<String> {
        var content = File.getContent(path);                
        return macro $v{content};
    }
}