/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 30/11/12
 * Time: 15:42
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.controls {
import be.devine.cp3.model.AppModel;

import flash.display.BitmapData;

import starling.animation.Transitions;

import starling.animation.Tween;

import starling.core.Starling;

import starling.display.Button;
import starling.display.DisplayObject;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;

public class ViewModeControlButton extends Button{

    private var appModel:AppModel;
    private var tween:Tween;
    private var openState:Texture;
    private var closedState:Texture;

    public function ViewModeControlButton(upState:Texture, openState:Texture) {
        super(upState);
        this.openState = openState;
        this.closedState = upState;
        appModel = AppModel.getInstance();
        this.scaleWhenDown = 1;
        this.addEventListener(TouchEvent.TOUCH, touchHandler);
    }

    private function touchHandler(event:TouchEvent):void {
        var touchObject:DisplayObject = event.currentTarget as DisplayObject;
        Starling.juggler.removeTweens(tween);
        if(event.getTouch(touchObject, TouchPhase.BEGAN)){
            this.removeEventListeners(TouchEvent.TOUCH);
            appModel.openViewModes();
                if(appModel.timelineView){
                    Starling.juggler.removeTweens(this);
                    if(appModel.viewModesOpened){
                        //open het
                        tween = new Tween(this, 0.5, Transitions.EASE_IN_OUT);
                        tween.animate("y", this.y - 258);
                        tween.onComplete = addListener;
                        Starling.juggler.add(tween);
                    }else{
                        //sluit het
                        tween = new Tween(this, 0.4, Transitions.EASE_IN_OUT);
                        tween.animate("y", this.y + 258);
                        tween.onComplete = addListener;
                        Starling.juggler.add(tween);
                    }
                }else{
                    //if gridview, tween helemaal naar boven
                    appModel.viewModesOpened ? this.y -= stage.stageHeight - 22 - this.height : this.y += stage.stageHeight - 22 - this.height;
                }
        }

    }

    private function addListener():void{

    }

}
}
