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

public class ClearMemory {
    public function ClearMemory() {
    }

    public static function clear(container:DisplayObjectContainer):void{

        while( container.numChildren > 0 )
        {
            var child:DisplayObject = container.removeChildAt(0, true);
            if( child is DisplayObjectContainer )
                clear(child as DisplayObjectContainer);
        }
    }
}
}
