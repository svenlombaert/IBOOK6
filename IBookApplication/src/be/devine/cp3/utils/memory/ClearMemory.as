/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 17/12/12
 * Time: 11:58
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.utils.memory {
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Image;
import starling.textures.Texture;

public class ClearMemory {
    public function ClearMemory() {
    }

    public static function clear(container:DisplayObjectContainer):void{

        while( container.numChildren > 0 )
        {
            var child:DisplayObject = container.removeChildAt(0);
            child.dispose();
            child.removeEventListeners();
            if(child is Image){
                (child as Image).texture.base.dispose();
                (child as Image).texture.dispose();
            }
            if( child is DisplayObjectContainer )
                clear(child as DisplayObjectContainer);
        }
    }
}
}
