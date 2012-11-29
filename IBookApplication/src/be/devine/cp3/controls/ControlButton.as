/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 27/11/12
 * Time: 15:48
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.controls {
import be.devine.cp3.model.AppModel;

import flash.display.Loader;

import starling.display.Button;
import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;

public class ControlButton extends Button{

    private var appModel:AppModel;
    private var image:Loader;
    private var leftRightButton:Button;
    private var type:String;

    //----CONSTRUCTOR
    public function ControlButton(upState:Texture, type:String) {
        super(upState);
        this.type = type;
        appModel = AppModel.getInstance();
        this.alphaWhenDisabled = 0.1;
        this.scaleWhenDown = 1;
        this.addEventListener(TouchEvent.TOUCH, touchedHandler);
        if(type != "viewmode"){
            this.enabled = false;
            this.addEventListener(TouchEvent.TOUCH, touchedHandler);
        }
    }

    private function touchedHandler(event:TouchEvent):void {
        var touchObject:DisplayObject = event.currentTarget as DisplayObject;
        //hover in en out voor prev en next
        if(type != "viewmode"){
            event.getTouch(event.currentTarget as DisplayObject, TouchPhase.HOVER) ? this.enabled = true : this.enabled=false;
        }
        //vuur juiste events af via het appModel
        if(event.getTouch(touchObject, TouchPhase.BEGAN)){
            this.enabled = true;
            switch(type){
                case "previous": appModel.gotoPreviousPage(); break;
                case 'next': appModel.gotoNextPage(); break;
                case "viewmode": appModel.openViewModes(); break;
            }
        }
        //alpha = 1 wanneer je de muisknop loslaat
        if(event.getTouch(touchObject, TouchPhase.ENDED)){
            this.enabled = true;
        }

    }
}
}
