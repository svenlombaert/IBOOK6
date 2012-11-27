/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 27/11/12
 * Time: 16:22
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.controls {
import be.devine.cp3.model.AppModel;

import flash.events.Event;
import flash.events.EventDispatcher;

public class RightButton extends EventDispatcher {

    private var appModel:AppModel;

    //----CONSTRUCTOR
    public function RightButton(color:uint) {
        appModel = AppModel.getInstance();
        appModel.addEventListener(AppModel.SELECTEDCOLORINDEX_CHANGED, colorChangedHandler);
        changeColor(color);

    }

    //----METHODS
    private function colorChangedHandler(event:Event):void {
        changeColor(appModel.selectedColorIndex);
    }

    private function changeColor(color:uint):void{
       //verander de kleur van de movieclip adhv gotoAndStop();
    }
}
}
