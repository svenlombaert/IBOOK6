/**
 * Created with IntelliJ IDEA.
 * User: Svenn
 * Date: 27/11/12
 * Time: 15:48
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.view.controls {
import be.devine.cp3.model.AppModel;

import flash.display.BitmapData;
import flash.display.Shape;
import flash.geom.Point;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Button;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.RenderTexture;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import starling.utils.deg2rad;

public class PrevNextSlideButton extends Button{

    private var appModel:AppModel;
    private var type:String;
    private var hoverDisabled:Boolean = false;
    private var tween:Tween;
    private var textureAtlas:TextureAtlas;

    //----CONSTRUCTOR
    public function PrevNextSlideButton(textureAtlas:TextureAtlas, type:String) {
        appModel = AppModel.getInstance();
        super(renderTexture(textureAtlas, type, appModel.selectedColorIndex));
        this.textureAtlas = textureAtlas;
        this.type = type;
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
        if(event.getTouch(touchObject, TouchPhase.BEGAN)) {
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
        if(event.getTouch(touchObject, TouchPhase.ENDED)) {
            this.enabled = true;
            this.alpha = 1;
        }
    }

    private function hoverHandler(event:TouchEvent):void {
        var touchObject:DisplayObject = event.currentTarget as DisplayObject;
        //hover in en out voor prev en next

        if(event.getTouch(touchObject, TouchPhase.HOVER)) {
            //hover in
            if(!hoverDisabled){
                //tween naar zichtbaar
                tween = new Tween(this, 0.2, Transitions.EASE_IN);
                tween.animate('alpha', 1);
                tween.onComplete = setEnabled;
                Starling.juggler.add(tween);
                hoverDisabled = true;
            }
        }else {
            //hover out
            var touch:Touch = event.getTouch(this);
            var location:Point = new Point();
            if(touch != null){
                location  = touch.getLocation(this);
            } else {
                var globalPoint:Point = new Point(Starling.current.nativeStage.mouseX, Starling.current.nativeStage.mouseY);
                globalToLocal(globalPoint, location);
            }

            if(hoverDisabled && this.hitTest(location) == null) {
                tween = new Tween(this, 0.2, Transitions.EASE_IN);
                tween.animate('alpha', 0.1);
                tween.onComplete = setDisabled;
                Starling.juggler.add(tween);
                hoverDisabled = false;
            }
        }
    }

    private function setEnabled():void {
        Starling.juggler.remove(tween);
        this.enabled = true;
        this.useHandCursor = true;
    }

    private function setDisabled():void {
        Starling.juggler.remove(tween);
        this.enabled = false;
        this.useHandCursor = false;
    }

    private function renderTexture(textureAtlas: TextureAtlas, type: String, color:uint):Texture {
        var circleShape:Shape = new Shape();
        circleShape.graphics.beginFill(color, 0.8);
        circleShape.graphics.drawCircle(50,50, 50);
        circleShape.graphics.endFill();

        var arrow:Texture = textureAtlas.getTexture("arrow");
        var imgArrow:Image = new Image(arrow);
        imgArrow.pivotX = imgArrow.width/2;
        imgArrow.pivotY = imgArrow.height/2;
        if(type == "next") {
            imgArrow.rotation = deg2rad(90);
            imgArrow.x = circleShape.width/2 - 20;
        }else{
            imgArrow.rotation = deg2rad(-90);
            imgArrow.x = circleShape.width/2 + 20;
        }
        imgArrow.y = circleShape.width/2;

        var bmpData:BitmapData = new BitmapData(circleShape.width, circleShape.height, true, 0x000000);
        bmpData.draw(circleShape);

        var imgCircle:Image = new Image(Texture.fromBitmapData(bmpData));

        var renderTexture:RenderTexture = new RenderTexture(circleShape.width, circleShape.height);
        renderTexture.draw(imgCircle);
        renderTexture.draw(imgArrow);

        return renderTexture;
    }


}
}
