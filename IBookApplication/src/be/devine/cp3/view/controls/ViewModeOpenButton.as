/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 30/11/12
 * Time: 15:42
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view.controls {
import be.devine.cp3.model.AppModel;

import flash.events.Event;

import starling.animation.Tween;

import starling.display.Button;
import starling.display.DisplayObject;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;

public class ViewModeOpenButton extends Button{

    private var appModel:AppModel;
    private var tween:Tween;
    private var openState:Texture;
    private var closedState:Texture;
    private var _updateListeners:Boolean = false;

    public function ViewModeOpenButton(upState:Texture, openState:Texture) {
        super(upState);
        this.openState = openState;
        this.closedState = upState;
        appModel = AppModel.getInstance();
        this.scaleWhenDown = 1;
        this.addEventListener(TouchEvent.TOUCH, touchHandler);
        this.appModel.addEventListener(AppModel.VIEWMODES_OPENED, viewmodesOpenedHandler);
    }

    //TODO: Bug oplossen bij snel klikken
    private function touchHandler(event:TouchEvent):void {
        var touchObject:DisplayObject = event.currentTarget as DisplayObject;
        if(event.getTouch(touchObject, TouchPhase.BEGAN)){
            appModel.openViewModes();
        }
    }

    private function viewmodesOpenedHandler(event:Event):void {
        if(appModel.viewModesOpened){
            this.upState = openState;
        }else{
            this.upState = closedState;
        }
    }

    //getters en setters
    public function get updateListeners():Boolean {
        return _updateListeners;
    }

    public function set updateListeners(value:Boolean):void {
        _updateListeners = value;

        if(_updateListeners){
            this.removeEventListener(TouchEvent.TOUCH, touchHandler);
        }else{
            this.addEventListener(TouchEvent.TOUCH, touchHandler);
        }
    }
}
}
