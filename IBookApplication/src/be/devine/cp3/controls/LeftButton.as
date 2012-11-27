/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 27/11/12
 * Time: 15:48
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.controls {
import be.devine.cp3.model.AppModel;

import flash.events.Event;
import flash.events.EventDispatcher;

//extenden van basic left button (voorlopig EventDispatcher ivm Errors). BasicLeftButton =  movieclip met verschillende kleuren
public class LeftButton extends EventDispatcher{

    private var appModel:AppModel;

    //----CONSTRUCTOR
    public function LeftButton(color:uint) {
        appModel = AppModel.getInstance();
        appModel.addEventListener(AppModel.SELECTEDCOLORINDEX_CHANGED, colorChangedHandler);
        changeColor(color);
    }

    //-----METHODS
    private function colorChangedHandler(event:Event):void {
        changeColor(appModel.selectedColorIndex);
    }

    private function changeColor(color:uint):void{
        //verander de kleur aan de hand van een gotoAndStop;
    }
}
}
