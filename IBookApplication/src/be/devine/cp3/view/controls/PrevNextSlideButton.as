/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 27/11/12
 * Time: 15:48
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view.controls {
import be.devine.cp3.model.AppModel;

import flash.display.Loader;
import flash.geom.Point;
import flash.trace.Trace;
import flash.ui.Mouse;

import starling.animation.Transitions;

import starling.animation.Tween;
import starling.core.Starling;

import starling.display.Button;
import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;

public class PrevNextSlideButton extends Button{

    private var appModel:AppModel;
    private var image:Loader;
    private var leftRightButton:Button;
    private var type:String;
    private var hoverDisabled:Boolean = false;
    private var tween:Tween;

    //----CONSTRUCTOR
    public function PrevNextSlideButton(upState:Texture, type:String) {
        super(upState);
        this.type = type;
        appModel = AppModel.getInstance();
        this.alphaWhenDisabled = 1;
        this.scaleWhenDown = 1;
        this.addEventListener(TouchEvent.TOUCH, clickHandler);
        this.enabled = false;
        this.alpha = 0.1;
        this.addEventListener(TouchEvent.TOUCH, hoverHandler);
    }
    private function clickHandler(event:TouchEvent):void {
        //vuur juiste events af via het appModel
        var touchObject:DisplayObject = event.currentTarget as DisplayObject;
        if(event.getTouch(touchObject, TouchPhase.BEGAN)){
            this.enabled = true;
            switch(type){
                case "previous":
                    appModel.gotoPreviousPage();
                    break;
                case 'next':
                    appModel.gotoNextPage();
                    break;
            }
        }
        //alpha = 1 wanneer je de muisknop loslaat
        if(event.getTouch(touchObject, TouchPhase.ENDED)){
            this.enabled = true;
            this.alpha = 1;
        }
    }

    private function hoverHandler(event:TouchEvent):void {
        var touchObject:DisplayObject = event.currentTarget as DisplayObject;
        //hover in en out voor prev en next

        if(event.getTouch(touchObject, TouchPhase.HOVER)){
            //hover in
            if(!hoverDisabled){
                //tween naar zichtbaar
                tween = new Tween(this, 0.2, Transitions.EASE_IN);
                tween.animate('alpha', 1);
                tween.onComplete = setEnabled;
                Starling.juggler.add(tween);
                hoverDisabled = true;
            }
        }else{
            //hover out
            var touch:Touch = event.getTouch(this);
            var location:Point = new Point();
            if(touch != null){
                location  = touch.getLocation(this);
            } else {
                var globalPoint:Point = new Point(Starling.current.nativeStage.mouseX, Starling.current.nativeStage.mouseY);
                globalToLocal(globalPoint, location);
            }

            if(hoverDisabled && this.hitTest(location) == null){
                tween = new Tween(this, 0.2, Transitions.EASE_IN);
                tween.animate('alpha', 0.1);
                tween.onComplete = setDisabled;
                Starling.juggler.add(tween);
                hoverDisabled = false;
            }
        }
    }

    private function setEnabled():void{
        Starling.juggler.remove(tween);
        this.enabled = true;
        this.useHandCursor = true;
    }

    private function setDisabled():void{
        Starling.juggler.remove(tween);
        this.enabled = false;
        this.useHandCursor = false;
    }


}
}
